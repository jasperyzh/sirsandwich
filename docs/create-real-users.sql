-- Create Real Users for Sirsandwich Shop
-- Run this in your Supabase SQL Editor after creating users in the dashboard

-- First, create the users manually in Supabase Dashboard:
-- 1. Go to Authentication → Users → Add user
-- 2. Create these users:
--    - Email: live_admin@sirsandwich.com, Password: SecureAdmin123!, Email Confirm: true
--    - Email: live_customer@emailtest.com, Password: SecureCustomer123!, Email Confirm: true

-- Then run this SQL to set their roles and create profiles:

-- Function to set user role and create profile
CREATE OR REPLACE FUNCTION create_user_profile(
  user_email text,
  user_role text,
  full_name text DEFAULT NULL
)
RETURNS void AS $$
DECLARE
  user_id uuid;
BEGIN
  -- Get user ID from email
  SELECT id INTO user_id 
  FROM auth.users 
  WHERE email = user_email;
  
  IF user_id IS NULL THEN
    RAISE EXCEPTION 'User with email % not found', user_email;
  END IF;
  
  -- Insert or update user profile
  INSERT INTO user_profiles (id, full_name, role, created_at, updated_at)
  VALUES (user_id, full_name, user_role, NOW(), NOW())
  ON CONFLICT (id) 
  DO UPDATE SET 
    role = EXCLUDED.role,
    full_name = COALESCE(EXCLUDED.full_name, user_profiles.full_name),
    updated_at = NOW();
    
  RAISE NOTICE 'Profile created/updated for % with role %', user_email, user_role;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create profiles for our real users
-- (Run these AFTER creating the users in the dashboard)
SELECT create_user_profile('live_admin@sirsandwich.com', 'admin', 'Live Admin User');
SELECT create_user_profile('live_customer@emailtest.com', 'customer', 'Live Customer User');

-- Verify the users were created correctly
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

-- Create role permissions table for better authorization management
CREATE TABLE IF NOT EXISTS role_permissions (
  id SERIAL PRIMARY KEY,
  role VARCHAR(50) NOT NULL,
  permission VARCHAR(100) NOT NULL,
  resource VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(role, permission, resource)
);

-- Insert role permissions
INSERT INTO role_permissions (role, permission, resource, description) VALUES
-- Admin permissions
('admin', 'create', 'products', 'Can create new products'),
('admin', 'read', 'products', 'Can view all products including inactive'),
('admin', 'update', 'products', 'Can edit product details'),
('admin', 'delete', 'products', 'Can delete products'),
('admin', 'create', 'categories', 'Can create new categories'),
('admin', 'read', 'categories', 'Can view all categories'),
('admin', 'update', 'categories', 'Can edit categories'),
('admin', 'delete', 'categories', 'Can delete categories'),
('admin', 'read', 'orders', 'Can view all orders'),
('admin', 'update', 'orders', 'Can update order status'),
('admin', 'delete', 'orders', 'Can cancel/delete orders'),
('admin', 'read', 'users', 'Can view user profiles'),
('admin', 'update', 'users', 'Can update user roles'),
('admin', 'read', 'analytics', 'Can view sales analytics'),
('admin', 'manage', 'system', 'Can manage system settings'),

-- Staff permissions
('staff', 'read', 'products', 'Can view all products'),
('staff', 'update', 'products', 'Can edit product stock'),
('staff', 'read', 'orders', 'Can view all orders'),
('staff', 'update', 'orders', 'Can update order status'),
('staff', 'read', 'analytics', 'Can view basic analytics'),

-- Customer permissions
('customer', 'read', 'products', 'Can view active products'),
('customer', 'read', 'categories', 'Can view categories'),
('customer', 'create', 'orders', 'Can place orders'),
('customer', 'read', 'orders', 'Can view own orders'),
('customer', 'update', 'profile', 'Can update own profile'),
('customer', 'read', 'profile', 'Can view own profile')

ON CONFLICT (role, permission, resource) DO NOTHING;

-- Function to check user permissions
CREATE OR REPLACE FUNCTION user_has_permission(
  user_id uuid,
  required_permission text,
  required_resource text
)
RETURNS boolean AS $$
DECLARE
  user_role text;
  has_permission boolean := false;
BEGIN
  -- Get user role
  SELECT role INTO user_role
  FROM user_profiles
  WHERE id = user_id;
  
  IF user_role IS NULL THEN
    RETURN false;
  END IF;
  
  -- Check if role has the required permission
  SELECT EXISTS(
    SELECT 1 FROM role_permissions
    WHERE role = user_role
    AND permission = required_permission
    AND resource = required_resource
  ) INTO has_permission;
  
  RETURN has_permission;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get all user permissions
CREATE OR REPLACE FUNCTION get_user_permissions(user_id uuid)
RETURNS TABLE(
  permission text,
  resource text,
  description text
) AS $$
DECLARE
  user_role text;
BEGIN
  -- Get user role
  SELECT up.role INTO user_role
  FROM user_profiles up
  WHERE up.id = user_id;
  
  IF user_role IS NULL THEN
    RETURN;
  END IF;
  
  -- Return all permissions for the user's role
  RETURN QUERY
  SELECT rp.permission, rp.resource, rp.description
  FROM role_permissions rp
  WHERE rp.role = user_role
  ORDER BY rp.resource, rp.permission;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Test the permission system
-- SELECT user_has_permission(
--   (SELECT id FROM auth.users WHERE email = 'live_admin@sirsandwich.com'),
--   'create',
--   'products'
-- );

-- View all permissions for a user
-- SELECT * FROM get_user_permissions(
--   (SELECT id FROM auth.users WHERE email = 'live_admin@sirsandwich.com')
-- ); 