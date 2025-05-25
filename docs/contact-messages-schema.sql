-- Contact Messages Table Schema
-- Run this in your Supabase SQL Editor to create the contact_messages table

-- Create contact_messages table
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

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_contact_messages_status ON contact_messages(status);
CREATE INDEX IF NOT EXISTS idx_contact_messages_created_at ON contact_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_contact_messages_email ON contact_messages(email);

-- Enable Row Level Security
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for contact_messages
-- Anyone can insert (submit contact form)
CREATE POLICY "Anyone can submit contact messages" ON contact_messages 
FOR INSERT WITH CHECK (true);

-- Only admins can view contact messages
CREATE POLICY "Admins can view all contact messages" ON contact_messages 
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- Only admins can update contact messages (change status, add notes)
CREATE POLICY "Admins can update contact messages" ON contact_messages 
FOR UPDATE USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- Create trigger for updating updated_at timestamp
CREATE OR REPLACE FUNCTION update_contact_messages_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_contact_messages_updated_at
  BEFORE UPDATE ON contact_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_contact_messages_updated_at();

-- Insert some sample data for testing
INSERT INTO contact_messages (name, email, phone, subject, message, status) VALUES
('John Doe', 'john@example.com', '(555) 123-4567', 'general', 'I love your sandwiches! Do you offer catering services?', 'new'),
('Jane Smith', 'jane@example.com', NULL, 'order', 'I placed an order but haven''t received confirmation. Order #12345', 'read'),
('Mike Johnson', 'mike@example.com', '(555) 987-6543', 'feedback', 'The Turkey Club was amazing! Best sandwich I''ve ever had.', 'replied'),
('Sarah Wilson', 'sarah@example.com', '(555) 456-7890', 'catering', 'We need catering for 50 people next Friday. What are your options?', 'new');

-- Grant necessary permissions
GRANT ALL ON contact_messages TO authenticated;
GRANT ALL ON contact_messages TO anon; 