-- Sirsandwich Shop Database Schema
-- Run this SQL in your Supabase SQL Editor to set up the database

-- Enable Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  image_url TEXT,
  stock_quantity INTEGER DEFAULT 0 CHECK (stock_quantity >= 0),
  category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
  specs JSONB DEFAULT '{}',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
  status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled')),
  customer_name VARCHAR(255),
  customer_email VARCHAR(255),
  customer_phone VARCHAR(50),
  delivery_address TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
  total_price DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
  product_snapshot JSONB, -- Store product details at time of order
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name VARCHAR(255),
  phone VARCHAR(50),
  address TEXT,
  role VARCHAR(50) DEFAULT 'customer' CHECK (role IN ('customer', 'admin', 'staff')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items(product_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies for categories
CREATE POLICY "Categories are viewable by everyone" ON categories FOR SELECT USING (true);
CREATE POLICY "Categories are editable by admins" ON categories FOR ALL USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- RLS Policies for products
CREATE POLICY "Products are viewable by everyone" ON products FOR SELECT USING (is_active = true OR EXISTS (
  SELECT 1 FROM user_profiles 
  WHERE user_profiles.id = auth.uid() 
  AND user_profiles.role IN ('admin', 'staff')
));

CREATE POLICY "Products are editable by admins" ON products FOR ALL USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role = 'admin'
  )
);

-- RLS Policies for orders
CREATE POLICY "Users can view their own orders" ON orders FOR SELECT USING (
  auth.uid() = user_id OR EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role IN ('admin', 'staff')
  )
);

CREATE POLICY "Users can create their own orders" ON orders FOR INSERT WITH CHECK (
  auth.uid() = user_id
);

CREATE POLICY "Admins and staff can update orders" ON orders FOR UPDATE USING (
  EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE user_profiles.id = auth.uid() 
    AND user_profiles.role IN ('admin', 'staff')
  )
);

-- RLS Policies for order_items
CREATE POLICY "Order items are viewable with orders" ON order_items FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.id = order_items.order_id 
    AND (orders.user_id = auth.uid() OR EXISTS (
      SELECT 1 FROM user_profiles 
      WHERE user_profiles.id = auth.uid() 
      AND user_profiles.role IN ('admin', 'staff')
    ))
  )
);

CREATE POLICY "Order items are insertable with orders" ON order_items FOR INSERT WITH CHECK (
  EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.id = order_items.order_id 
    AND orders.user_id = auth.uid()
  )
);

-- RLS Policies for user_profiles
CREATE POLICY "Users can view their own profile" ON user_profiles FOR SELECT USING (
  auth.uid() = id OR EXISTS (
    SELECT 1 FROM user_profiles up
    WHERE up.id = auth.uid() 
    AND up.role IN ('admin', 'staff')
  )
);

CREATE POLICY "Users can update their own profile" ON user_profiles FOR UPDATE USING (
  auth.uid() = id
);

CREATE POLICY "Users can insert their own profile" ON user_profiles FOR INSERT WITH CHECK (
  auth.uid() = id
);

-- Insert default categories
INSERT INTO categories (name, description) VALUES
  ('Classics', 'Traditional sandwich favorites'),
  ('Gourmet', 'Premium artisanal sandwiches'),
  ('Vegetarian', 'Plant-based options'),
  ('BBQ', 'Barbecue-style sandwiches'),
  ('Chicken', 'Chicken-based sandwiches'),
  ('Seafood', 'Fresh seafood options')
ON CONFLICT (name) DO NOTHING;

-- Insert sample products (you can modify these)
INSERT INTO products (name, description, price, image_url, stock_quantity, category_id, specs) VALUES
  (
    'The Classic Club',
    'A timeless favorite featuring layers of fresh turkey, crispy bacon, lettuce, tomato, and mayo on toasted bread.',
    12.99,
    '🥪',
    50,
    (SELECT id FROM categories WHERE name = 'Classics'),
    '{"calories": 520, "allergens": ["gluten", "dairy"], "prepTime": "5-7 minutes"}'
  ),
  (
    'Gourmet Caprese',
    'Fresh mozzarella, ripe tomatoes, basil leaves, and balsamic glaze on artisan ciabatta bread.',
    14.99,
    '🥖',
    30,
    (SELECT id FROM categories WHERE name = 'Gourmet'),
    '{"calories": 450, "allergens": ["gluten", "dairy"], "prepTime": "6-8 minutes"}'
  ),
  (
    'Veggie Delight',
    'A colorful medley of fresh vegetables, hummus, avocado, and sprouts on whole grain bread.',
    11.99,
    '🥗',
    40,
    (SELECT id FROM categories WHERE name = 'Vegetarian'),
    '{"calories": 380, "allergens": ["gluten"], "prepTime": "4-6 minutes"}'
  ),
  (
    'BBQ Pulled Pork',
    'Slow-cooked pulled pork with tangy BBQ sauce, coleslaw, and pickles on a brioche bun.',
    15.99,
    '🍖',
    25,
    (SELECT id FROM categories WHERE name = 'BBQ'),
    '{"calories": 680, "allergens": ["gluten", "dairy"], "prepTime": "7-9 minutes"}'
  ),
  (
    'Buffalo Chicken Wrap',
    'Spicy buffalo chicken with lettuce, tomatoes, ranch dressing, and cheese in a flour tortilla.',
    13.99,
    '🌯',
    35,
    (SELECT id FROM categories WHERE name = 'Chicken'),
    '{"calories": 590, "allergens": ["gluten", "dairy"], "prepTime": "5-7 minutes"}'
  ),
  (
    'Tuna Melt Supreme',
    'Premium tuna salad with melted cheese, tomatoes, and red onions on sourdough bread.',
    13.49,
    '🐟',
    20,
    (SELECT id FROM categories WHERE name = 'Seafood'),
    '{"calories": 510, "allergens": ["gluten", "dairy", "fish"], "prepTime": "6-8 minutes"}'
  )
ON CONFLICT DO NOTHING;

-- Create a function to handle user profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, full_name, role)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', 'customer');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user profile creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated; 