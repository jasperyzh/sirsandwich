-- Clean Fix for Contact Messages RLS Policy
-- Run this in your Supabase SQL Editor

-- First, let's check what policies exist and clean them up
DO $$
BEGIN
    -- Drop all existing policies for contact_messages
    DROP POLICY IF EXISTS "Anyone can submit contact messages" ON contact_messages;
    DROP POLICY IF EXISTS "Allow anonymous contact form submissions" ON contact_messages;
    DROP POLICY IF EXISTS "Admins can view all contact messages" ON contact_messages;
    DROP POLICY IF EXISTS "Admins can update contact messages" ON contact_messages;
    
    RAISE NOTICE 'Existing policies dropped successfully';
EXCEPTION
    WHEN undefined_table THEN
        RAISE NOTICE 'Table contact_messages does not exist yet';
END $$;

-- Create the table if it doesn't exist
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

-- Enable Row Level Security
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Create new policies with unique names
CREATE POLICY "contact_form_anonymous_insert" ON contact_messages 
FOR INSERT TO anon, authenticated WITH CHECK (true);

CREATE POLICY "contact_admin_select" ON contact_messages 
FOR SELECT TO authenticated USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

CREATE POLICY "contact_admin_update" ON contact_messages 
FOR UPDATE TO authenticated USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- Grant explicit permissions
GRANT INSERT ON contact_messages TO anon;
GRANT ALL ON contact_messages TO authenticated;

-- Create indexes if they don't exist
CREATE INDEX IF NOT EXISTS idx_contact_messages_status ON contact_messages(status);
CREATE INDEX IF NOT EXISTS idx_contact_messages_created_at ON contact_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_contact_messages_email ON contact_messages(email);

-- Create or replace the trigger function
CREATE OR REPLACE FUNCTION update_contact_messages_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop and recreate the trigger
DROP TRIGGER IF EXISTS trigger_update_contact_messages_updated_at ON contact_messages;
CREATE TRIGGER trigger_update_contact_messages_updated_at
  BEFORE UPDATE ON contact_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_contact_messages_updated_at();

-- Add sample data only if table is empty
INSERT INTO contact_messages (name, email, phone, subject, message, status) 
SELECT 'John Doe', 'john@example.com', '(555) 123-4567', 'general', 'I love your sandwiches! Do you offer catering services?', 'new'
WHERE NOT EXISTS (SELECT 1 FROM contact_messages LIMIT 1);

INSERT INTO contact_messages (name, email, phone, subject, message, status) 
SELECT 'Jane Smith', 'jane@example.com', NULL, 'order', 'I placed an order but haven''t received confirmation. Order #12345', 'read'
WHERE (SELECT COUNT(*) FROM contact_messages) < 2;

-- Show current policies for verification
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'contact_messages';

-- Test the permissions
SELECT 'Permissions check completed' as status; 