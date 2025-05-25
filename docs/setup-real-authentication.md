# Real Authentication Setup Guide

This guide will help you set up real authentication with role-based authorization for Sirsandwich Shop.

## 🎯 **Overview**

We're creating two live accounts with different roles:
- **Admin Account**: `live_admin@sirsandwich.com` (Full system access)
- **Customer Account**: `live_customer@emailtest.com` (Standard user access)

## 📋 **Prerequisites**

1. ✅ Supabase project created and configured
2. ✅ Database schema deployed (`docs/database-schema.sql`)
3. ✅ Environment variables configured (`.env` file)

## 🔧 **Step 1: Create Users in Supabase Dashboard**

### 1.1 Access Supabase Dashboard
1. Go to [supabase.com/dashboard](https://supabase.com/dashboard)
2. Select your `sirsandwich-shop` project
3. Navigate to **Authentication** → **Users**

### 1.2 Create Admin User
1. Click **"Add user"** button
2. Fill in the form:
   - **Email**: `live_admin@sirsandwich.com`
   - **Password**: `SecureAdmin123!`
   - **Auto Confirm User**: ✅ Check this box
   - **Email Confirm**: ✅ Check this box
3. Click **"Create user"**

### 1.3 Create Customer User
1. Click **"Add user"** button again
2. Fill in the form:
   - **Email**: `live_customer@emailtest.com`
   - **Password**: `SecureCustomer123!`
   - **Auto Confirm User**: ✅ Check this box
   - **Email Confirm**: ✅ Check this box
3. Click **"Create user"**

## 🗄️ **Step 2: Set Up User Profiles and Permissions**

### 2.1 Run the SQL Script
1. In Supabase Dashboard, go to **SQL Editor**
2. Click **"New query"**
3. Copy the entire contents of `docs/create-real-users.sql`
4. Paste into the SQL editor
5. Click **"Run"** to execute

### 2.2 Verify Setup
Run this query to verify users were created correctly:

```sql
SELECT 
  u.email,
  u.email_confirmed_at,
  u.created_at as user_created,
  p.full_name,
  p.role,
  p.created_at as profile_created
FROM auth.users u
LEFT JOIN user_profiles p ON u.id = p.id
WHERE u.email IN ('live_admin@sirsandwich.com', 'live_customer@emailtest.com')
ORDER BY u.created_at DESC;
```

Expected result:
```
email                          | email_confirmed_at | user_created | full_name         | role     | profile_created
live_admin@sirsandwich.com     | 2024-01-XX...     | 2024-01-XX   | Live Admin User   | admin    | 2024-01-XX
live_customer@emailtest.com    | 2024-01-XX...     | 2024-01-XX   | Live Customer User| customer | 2024-01-XX
```

## 🔐 **Step 3: Test Authentication**

### 3.1 Test Admin Account
1. Go to `http://localhost:4321/login`
2. Enter credentials:
   - **Email**: `live_admin@sirsandwich.com`
   - **Password**: `SecureAdmin123!`
3. Click **"Sign In"**
4. Verify you see admin role dashboard with full permissions

### 3.2 Test Customer Account
1. Sign out from admin account
2. Enter credentials:
   - **Email**: `live_customer@emailtest.com`
   - **Password**: `SecureCustomer123!`
3. Click **"Sign In"**
4. Verify you see customer role dashboard with limited permissions

## 🎭 **Role-Based Authorization System**

### Admin Role Permissions
- ✅ **Products**: Create, Read, Update, Delete
- ✅ **Categories**: Create, Read, Update, Delete
- ✅ **Orders**: Read, Update, Delete (all orders)
- ✅ **Users**: Read, Update (manage user roles)
- ✅ **Analytics**: Read (sales data and reports)
- ✅ **System**: Manage (system settings)

### Staff Role Permissions
- ✅ **Products**: Read, Update (stock only)
- ✅ **Orders**: Read, Update (order status)
- ✅ **Analytics**: Read (basic reports)

### Customer Role Permissions
- ✅ **Products**: Read (active products only)
- ✅ **Categories**: Read
- ✅ **Orders**: Create, Read (own orders only)
- ✅ **Profile**: Read, Update (own profile only)

## 📊 **Role Dashboard Features**

Each role gets a customized dashboard showing:

### 🔍 **Permission Overview**
- Total permissions count
- Resources accessible
- Detailed permission breakdown by resource
- Visual permission badges (Create, Read, Update, Delete)

### ⚡ **Role Capabilities**
- **Admin**: Product Management, Order Management, User Management, Analytics
- **Staff**: Order Processing, Inventory Updates
- **Customer**: Shopping, Account Management

### 🚀 **Quick Actions**
- **Admin**: Add Product, View Orders, Analytics, Settings
- **Staff**: View Orders, Update Stock, Reports, Support
- **Customer**: Shop Now, My Orders, Profile, Support

## 🔧 **Permission Checking in Code**

### Frontend Permission Checks
```javascript
// Check if user has specific permission
if (authStore.hasPermission('create', 'products')) {
  // Show "Add Product" button
}

// Check user role
if (authStore.isAdmin) {
  // Show admin features
}
```

### Backend Permission Checks (SQL)
```sql
-- Check user permission
SELECT user_has_permission(
  'user-uuid-here',
  'create',
  'products'
);

-- Get all user permissions
SELECT * FROM get_user_permissions('user-uuid-here');
```

## 🛡️ **Security Features**

### Row Level Security (RLS)
- **Products**: Public read, admin-only write
- **Orders**: Users see only their orders, staff/admin see all
- **User Profiles**: Users can only edit their own profile

### Permission Functions
- `user_has_permission()`: Check specific permission
- `get_user_permissions()`: Get all user permissions
- `create_user_profile()`: Set user role and profile

## 🧪 **Development vs Production**

### Development Mode
- Demo accounts work without database setup
- Simulated authentication for quick testing
- No real Supabase users required

### Production Mode
- Real Supabase authentication
- Database-backed user profiles
- Full permission system active

## 🔍 **Troubleshooting**

### Issue: "Invalid login credentials"
**Solution**: 
1. Verify user exists in Supabase Dashboard
2. Check email is confirmed
3. Verify password is correct
4. Ensure user profile was created

### Issue: "No permissions showing"
**Solution**:
1. Check user has a profile in `user_profiles` table
2. Verify role is set correctly
3. Run permission setup SQL script
4. Check browser console for errors

### Issue: "Demo accounts not working"
**Solution**:
1. Ensure you're in development mode
2. Check `import.meta.env.DEV` is true
3. Verify demo account credentials match exactly

## 📝 **Next Steps**

1. ✅ Create real users in Supabase
2. ✅ Test authentication with both accounts
3. ✅ Verify role-based permissions
4. 🔄 Implement protected routes
5. 🔄 Add order management features
6. 🔄 Deploy to production

## 🎉 **Success Indicators**

You'll know the setup is working when:
- ✅ Both live accounts can sign in successfully
- ✅ Admin sees full permission dashboard
- ✅ Customer sees limited permission dashboard
- ✅ Role badges display correctly
- ✅ Quick actions are enabled/disabled based on permissions
- ✅ No console errors during authentication

---

**🎯 Ready to test!** Your real authentication system with role-based authorization is now set up and ready for use. 