-- Fix Contact Messages RLS Policy
-- Run this in your Supabase SQL Editor to fix the contact form submission issue

-- First, check if the table exists and create it if it doesn't
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

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Anyone can submit contact messages" ON contact_messages;
DROP POLICY IF EXISTS "Admins can view all contact messages" ON contact_messages;
DROP POLICY IF EXISTS "Admins can update contact messages" ON contact_messages;

-- Enable Row Level Security
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Create a simple policy that allows anyone (including anonymous users) to insert
CREATE POLICY "Allow anonymous contact form submissions" ON contact_messages 
FOR INSERT TO anon, authenticated WITH CHECK (true);

-- Allow admins to view all contact messages
CREATE POLICY "Admins can view all contact messages" ON contact_messages 
FOR SELECT TO authenticated USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- Allow admins to update contact messages (change status, add notes)
CREATE POLICY "Admins can update contact messages" ON contact_messages 
FOR UPDATE TO authenticated USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_contact_messages_status ON contact_messages(status);
CREATE INDEX IF NOT EXISTS idx_contact_messages_created_at ON contact_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_contact_messages_email ON contact_messages(email);

-- Create trigger for updating updated_at timestamp
CREATE OR REPLACE FUNCTION update_contact_messages_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_contact_messages_updated_at ON contact_messages;
CREATE TRIGGER trigger_update_contact_messages_updated_at
  BEFORE UPDATE ON contact_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_contact_messages_updated_at();

-- Grant necessary permissions
GRANT INSERT ON contact_messages TO anon;
GRANT ALL ON contact_messages TO authenticated;

-- Insert some sample data for testing (only if table is empty)
INSERT INTO contact_messages (name, email, phone, subject, message, status) 
SELECT 'John Doe', 'john@example.com', '(555) 123-4567', 'general', 'I love your sandwiches! Do you offer catering services?', 'new'
WHERE NOT EXISTS (SELECT 1 FROM contact_messages LIMIT 1);

INSERT INTO contact_messages (name, email, phone, subject, message, status) 
SELECT 'Jane Smith', 'jane@example.com', NULL, 'order', 'I placed an order but haven''t received confirmation. Order #12345', 'read'
WHERE (SELECT COUNT(*) FROM contact_messages) < 2;

INSERT INTO contact_messages (name, email, phone, subject, message, status) 
SELECT 'Mike Johnson', 'mike@example.com', '(555) 987-6543', 'feedback', 'The Turkey Club was amazing! Best sandwich I''ve ever had.', 'replied'
WHERE (SELECT COUNT(*) FROM contact_messages) < 3;

INSERT INTO contact_messages (name, email, phone, subject, message, status) 
SELECT 'Sarah Wilson', 'sarah@example.com', '(555) 456-7890', 'catering', 'We need catering for 50 people next Friday. What are your options?', 'new'
WHERE (SELECT COUNT(*) FROM contact_messages) < 4; 