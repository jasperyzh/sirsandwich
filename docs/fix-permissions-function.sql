-- Fix Permissions Function - Data Type Mismatch Issue
-- Run this in your Supabase SQL Editor to fix the permissions loading

-- Drop the existing function with the wrong return type
DROP FUNCTION IF EXISTS get_user_permissions(uuid);

-- Create the corrected function with proper return types
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
  SELECT 
    rp.permission::text, 
    rp.resource::text, 
    rp.description::text
  FROM role_permissions rp
  WHERE rp.role = user_role
  ORDER BY rp.resource, rp.permission;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Also fix the user_has_permission function to be more robust
DROP FUNCTION IF EXISTS user_has_permission(uuid, text, text);

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

-- Test the functions
-- SELECT * FROM get_user_permissions('36e2f2e3-fdfb-4fa0-aada-fd1bca7f5beb');
-- SELECT user_has_permission('36e2f2e3-fdfb-4fa0-aada-fd1bca7f5beb', 'create', 'products'); 