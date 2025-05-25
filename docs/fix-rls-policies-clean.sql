-- Clean Fix for RLS Policies - Infinite Recursion Issue
-- Run this in your Supabase SQL Editor to fix the authentication problem

-- First, drop ALL existing policies for user_profiles to start clean
DROP POLICY IF EXISTS "Users can view their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON user_profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON user_profiles;
DROP POLICY IF EXISTS "Admins can update any profile" ON user_profiles;

-- Create simple, safe policies that don't cause recursion
-- Policy 1: Users can view their own profile (no recursion)
CREATE POLICY "Users can view own profile" ON user_profiles 
FOR SELECT USING (auth.uid() = id);

-- Policy 2: Users can update their own profile (no recursion)
CREATE POLICY "Users can update own profile" ON user_profiles 
FOR UPDATE USING (auth.uid() = id);

-- Policy 3: Users can insert their own profile (no recursion)
CREATE POLICY "Users can insert own profile" ON user_profiles 
FOR INSERT WITH CHECK (auth.uid() = id);

-- Verify the fix works
-- Test query: SELECT * FROM user_profiles WHERE id = auth.uid();

-- Note: Admin access to other profiles will be handled in the application layer
-- This prevents the infinite recursion issue completely 