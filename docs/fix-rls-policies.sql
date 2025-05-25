-- Fix RLS Policies for Infinite Recursion Issue
-- Run this in your Supabase SQL Editor to fix the authentication problem

-- First, drop the problematic policies
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;

-- Create new, simplified policies that don't cause recursion
-- Users can always view their own profile
CREATE POLICY "Users can view their own profile" ON user_profiles 
FOR SELECT USING (auth.uid() = id);

-- Admins can view all profiles (using a direct role check without recursion)
CREATE POLICY "Admins can view all profiles" ON user_profiles 
FOR SELECT USING (
  auth.uid() = id OR 
  (SELECT role FROM user_profiles WHERE id = auth.uid()) IN ('admin', 'staff')
);

-- Users can update their own profile
CREATE POLICY "Users can update their own profile" ON user_profiles 
FOR UPDATE USING (auth.uid() = id);

-- Users can insert their own profile
CREATE POLICY "Users can insert their own profile" ON user_profiles 
FOR INSERT WITH CHECK (auth.uid() = id);

-- Admins can update any profile
CREATE POLICY "Admins can update any profile" ON user_profiles 
FOR UPDATE USING (
  (SELECT role FROM user_profiles WHERE id = auth.uid()) = 'admin'
);

-- Alternative approach: Use a function to check roles safely
CREATE OR REPLACE FUNCTION get_user_role(user_id uuid)
RETURNS text AS $$
BEGIN
  RETURN (SELECT role FROM user_profiles WHERE id = user_id LIMIT 1);
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'customer';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop the complex policies and create simpler ones
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON user_profiles;

-- Create the final, safe policies
CREATE POLICY "Users can view their own profile" ON user_profiles 
FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON user_profiles 
FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON user_profiles 
FOR INSERT WITH CHECK (auth.uid() = id);

-- For admin access, we'll handle this in the application layer instead of RLS
-- This prevents the infinite recursion issue

-- Verify the fix by testing a simple query
-- SELECT * FROM user_profiles WHERE id = auth.uid(); 