# Contact Form RLS Policy Troubleshooting Guide

## Problem Description

You're encountering this error when submitting the contact form:

```
POST https://[your-project].supabase.co/rest/v1/contact_messages 403 (Forbidden)
Error: {code: '42501', details: null, hint: null, message: 'new row violates row-level security policy for table "contact_messages"'}
```

## Root Cause

This is a **Row Level Security (RLS) policy issue** in Supabase. The error occurs because:

1. **RLS is enabled** on the `contact_messages` table
2. **No policy exists** that allows anonymous users (`anon` role) to insert records
3. **Missing table permissions** for the `anon` role
4. **Schema permissions** might not be properly granted

## Solutions (Try in Order)

### Solution 1: Run the Comprehensive Fix Script

**File:** `docs/fix-contact-rls-final.sql`

This script addresses all common causes:
- Grants schema permissions
- Drops conflicting policies
- Grants table permissions BEFORE enabling RLS
- Creates simple, non-conflicting policies
- Includes verification steps

**Steps:**
1. Open your Supabase project dashboard
2. Go to **SQL Editor**
3. Copy and paste the entire content of `docs/fix-contact-rls-final.sql`
4. Click **Run**
5. Check the output for any errors

### Solution 2: Quick Permission Fix

If you just need a quick fix, run this in Supabase SQL Editor:

```sql
-- Grant basic permissions
GRANT USAGE ON SCHEMA public TO anon;
GRANT INSERT ON contact_messages TO anon;

-- Create simple insert policy for anonymous users
CREATE POLICY "allow_contact_form_submissions" ON contact_messages 
FOR INSERT TO anon WITH CHECK (true);
```

### Solution 3: Disable RLS Temporarily (Not Recommended for Production)

```sql
-- Temporarily disable RLS to test
ALTER TABLE contact_messages DISABLE ROW LEVEL SECURITY;

-- Test your contact form, then re-enable with proper policies
-- ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
```

### Solution 4: Check for Extension Issues

Based on Stack Overflow discussions, sometimes the `pg_net` extension can cause permission issues:

1. Go to **Database** → **Extensions** in Supabase dashboard
2. Find `pg_net` extension
3. **Disable** it, then **Enable** it again
4. Test your contact form

## Verification Steps

After applying any fix, verify the setup:

### 1. Check Table Permissions

```sql
SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name = 'contact_messages' 
ORDER BY grantee, privilege_type;
```

**Expected output should include:**
- `anon` with `INSERT` privilege
- `authenticated` with `INSERT`, `SELECT`, `UPDATE`, `DELETE` privileges

### 2. Check RLS Policies

```sql
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'contact_messages'
ORDER BY policyname;
```

**Expected output should include:**
- A policy allowing `anon` to `INSERT`
- Policies for `authenticated` users (admins) to `SELECT` and `UPDATE`

### 3. Test Anonymous Insert Permission

```sql
SELECT has_table_privilege('anon', 'contact_messages', 'INSERT') as anon_can_insert;
```

**Expected output:** `true`

## Common Mistakes to Avoid

### 1. Enabling RLS Before Granting Permissions
```sql
-- ❌ WRONG ORDER
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
GRANT INSERT ON contact_messages TO anon;

-- ✅ CORRECT ORDER
GRANT INSERT ON contact_messages TO anon;
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
```

### 2. Conflicting Policy Names
Make sure policy names are unique. Drop old policies before creating new ones.

### 3. Missing Schema Permissions
Always grant schema usage:
```sql
GRANT USAGE ON SCHEMA public TO anon;
```

### 4. Complex Policies for Simple Use Cases
For contact forms, keep it simple:
```sql
-- ✅ Simple and effective
CREATE POLICY "allow_anonymous_insert" ON contact_messages 
FOR INSERT TO anon WITH CHECK (true);

-- ❌ Overly complex for a contact form
CREATE POLICY "complex_policy" ON contact_messages 
FOR INSERT TO anon WITH CHECK (
  length(name) > 0 AND 
  email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' AND
  length(message) > 10
);
```

## Testing Your Fix

After applying the fix:

1. **Clear browser cache** and refresh the page
2. **Open browser developer tools** (F12)
3. **Go to Network tab**
4. **Submit the contact form**
5. **Check the network request** - it should return `201 Created` instead of `403 Forbidden`

## Alternative: Using Service Role Key (Not Recommended)

If you're still having issues, you can temporarily use the service role key for testing:

```javascript
// In your ContactForm.vue - ONLY FOR TESTING
const supabaseService = createClient(
  import.meta.env.PUBLIC_SUPABASE_URL,
  import.meta.env.SUPABASE_SERVICE_ROLE_KEY // Use service role key
);
```

**⚠️ Warning:** Never use the service role key in production frontend code as it bypasses all RLS policies.

## When to Contact Support

Contact Supabase support if:
- None of the above solutions work
- You see errors about `supabase_admin` role
- Your project was recently paused/unpaused
- You recently upgraded PostgreSQL version
- You're using database hooks/functions

## Related Resources

- [Supabase RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL GRANT Documentation](https://www.postgresql.org/docs/current/sql-grant.html)
- [Stack Overflow: Supabase Permission Denied](https://stackoverflow.com/questions/67559176/supabase-client-permission-denied-for-schema-public)
- [GitHub Issue: Permissions denied for table](https://github.com/supabase/supabase/issues/4883) 