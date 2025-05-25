-- FINAL FIX for Contact Messages RLS Policy Issues
-- This addresses the common "permission denied for table" errors
-- Run this in your Supabase SQL Editor

-- Step 1: Grant basic schema permissions (common fix from Stack Overflow)
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;

-- Step 2: Drop all existing policies to start fresh
DO $$
BEGIN
    -- Drop all existing policies for contact_messages
    DROP POLICY IF EXISTS "Anyone can submit contact messages" ON contact_messages;
    DROP POLICY IF EXISTS "Allow anonymous contact form submissions" ON contact_messages;
    DROP POLICY IF EXISTS "Admins can view all contact messages" ON contact_messages;
    DROP POLICY IF EXISTS "Admins can update contact messages" ON contact_messages;
    DROP POLICY IF EXISTS "contact_form_anonymous_insert" ON contact_messages;
    DROP POLICY IF EXISTS "contact_admin_select" ON contact_messages;
    DROP POLICY IF EXISTS "contact_admin_update" ON contact_messages;
    
    RAISE NOTICE 'Existing policies dropped successfully';
EXCEPTION
    WHEN undefined_table THEN
        RAISE NOTICE 'Table contact_messages does not exist yet';
    WHEN OTHERS THEN
        RAISE NOTICE 'Some policies may not have existed: %', SQLERRM;
END $$;

-- Step 3: Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS contact_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  subject VARCHAR(100) NOT NULL,
  message TEXT NOT NULL,
  status VARCHAR(50) DEFAULT 'new' CHECK (status IN ('new', 'read', 'replied', 'resolved')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  admin_notes TEXT
);

-- Step 4: Grant explicit table permissions BEFORE enabling RLS
-- This is crucial - permissions must be granted before RLS is enabled
GRANT INSERT ON contact_messages TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON contact_messages TO authenticated;
GRANT ALL ON contact_messages TO postgres, service_role;

-- Step 5: Enable Row Level Security
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Step 6: Create simple, non-conflicting policies
-- Policy for anonymous users to insert (contact form submissions)
CREATE POLICY "allow_anonymous_insert" ON contact_messages 
FOR INSERT TO anon WITH CHECK (true);

-- Policy for authenticated users to insert
CREATE POLICY "allow_authenticated_insert" ON contact_messages 
FOR INSERT TO authenticated WITH CHECK (true);

-- Policy for admins to select all messages
CREATE POLICY "admin_select_all" ON contact_messages 
FOR SELECT TO authenticated USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- Policy for admins to update messages
CREATE POLICY "admin_update_all" ON contact_messages 
FOR UPDATE TO authenticated USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- Step 7: Grant additional permissions that might be needed
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;

-- Step 8: Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_contact_messages_status ON contact_messages(status);
CREATE INDEX IF NOT EXISTS idx_contact_messages_created_at ON contact_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_contact_messages_email ON contact_messages(email);

-- Step 9: Create or replace the trigger function
CREATE OR REPLACE FUNCTION update_contact_messages_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 10: Drop and recreate the trigger
DROP TRIGGER IF EXISTS trigger_update_contact_messages_updated_at ON contact_messages;
CREATE TRIGGER trigger_update_contact_messages_updated_at
  BEFORE UPDATE ON contact_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_contact_messages_updated_at();

-- Step 11: Add sample data only if table is empty
INSERT INTO contact_messages (name, email, phone, subject, message, status) 
SELECT 'John Doe', 'john@example.com', '(555) 123-4567', 'general', 'I love your sandwiches! Do you offer catering services?', 'new'
WHERE NOT EXISTS (SELECT 1 FROM contact_messages LIMIT 1);

INSERT INTO contact_messages (name, email, phone, subject, message, status) 
SELECT 'Jane Smith', 'jane@example.com', NULL, 'order', 'I placed an order but haven''t received confirmation. Order #12345', 'read'
WHERE (SELECT COUNT(*) FROM contact_messages) < 2;

-- Step 12: Verify the setup
SELECT 'Checking table permissions...' as step;
SELECT grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name = 'contact_messages' 
ORDER BY grantee, privilege_type;

SELECT 'Checking RLS policies...' as step;
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'contact_messages'
ORDER BY policyname;

-- Step 13: Test insert permission for anonymous users
SELECT 'Testing anonymous insert permission...' as step;
-- This should return true if anonymous users can insert
SELECT has_table_privilege('anon', 'contact_messages', 'INSERT') as anon_can_insert;

SELECT 'Setup completed successfully!' as status; 