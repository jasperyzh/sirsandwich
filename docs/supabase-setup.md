# Supabase Setup Guide for Sirsandwich Shop

This guide will walk you through setting up Supabase for the Sirsandwich Shop project, including database configuration, authentication, and environment variables.

## 🚀 Getting Started

### 1. Create a Supabase Account

1. Go to [supabase.com](https://supabase.com)
2. Click "Start your project" 
3. Sign up with GitHub, Google, or email
4. Verify your email if required

### 2. Create a New Project

1. Click "New Project" in your Supabase dashboard
2. Choose your organization (or create one)
3. Fill in project details:
   - **Name**: `sirsandwich-shop`
   - **Database Password**: Create a strong password (save this!)
   - **Region**: Choose closest to your location
4. Click "Create new project"
5. Wait 2-3 minutes for project setup

### 3. Get Your Project Credentials

Once your project is ready:

1. Go to **Settings** → **API** in your Supabase dashboard
2. Copy the following values:
   - **Project URL** (looks like: `https://your-project-id.supabase.co`)
   - **anon/public key** (starts with `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`)

## 🔧 Environment Configuration

### 1. Create Environment File

In your project root, create a `.env` file:

```bash
# Copy .env.example to .env
cp .env.example .env
```

### 2. Add Your Supabase Credentials

Edit `.env` and add your actual Supabase values:

```env
# Supabase Configuration
PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Development settings
NODE_ENV=development
```

**⚠️ Important**: Never commit your `.env` file to version control!

## 🗄️ Database Setup

### 1. Run the Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New query"
3. Copy the entire contents of `docs/database-schema.sql`
4. Paste it into the SQL editor
5. Click "Run" to execute the schema

This will create:
- All necessary tables (products, categories, orders, etc.)
- Row Level Security (RLS) policies
- Triggers for automatic timestamps
- Sample data for testing

### 2. Verify Database Setup

After running the schema, check:

1. **Tables**: Go to **Table Editor** and verify these tables exist:
   - `categories`
   - `products` 
   - `orders`
   - `order_items`
   - `user_profiles`

2. **Sample Data**: Check that sample products and categories were inserted

3. **RLS Policies**: Go to **Authentication** → **Policies** to see security policies

## 🔐 Authentication Configuration

### 1. Enable Email Authentication

1. Go to **Authentication** → **Settings**
2. Under **Auth Providers**, ensure **Email** is enabled
3. Configure email settings:
   - **Enable email confirmations**: Toggle based on your preference
   - **Enable email change confirmations**: Recommended to keep enabled


---
---
---

### 2. Configure Site URL (for production)

1. In **Authentication** → **Settings**
2. Under **Site URL**, add your production domain
3. For development, `http://localhost:4321` should work

### 3. Email Templates (Optional)

Customize email templates in **Authentication** → **Email Templates**:
- Confirmation email
- Password reset email
- Email change confirmation

## 🧪 Testing the Setup

### 1. Test Database Connection

Run your development server:

```bash
npm run dev
```

Check the browser console for any Supabase connection errors.

### 2. Test Authentication

1. Go to `/login` in your app
2. Try creating a new account
3. Check **Authentication** → **Users** in Supabase dashboard
4. Verify the user appears in the dashboard

### 3. Test Database Operations

1. Go to `/admin` in your app
2. Try adding, editing, or deleting products
3. Check **Table Editor** → **products** in Supabase dashboard
4. Verify changes appear in the database

## 🔒 Security Configuration

### 1. Row Level Security (RLS)

RLS is automatically enabled by the schema. Key policies:

- **Products**: Public read access, admin-only write access
- **Orders**: Users can only see their own orders
- **User Profiles**: Users can only edit their own profile

### 2. API Keys

- **anon/public key**: Safe to use in frontend code
- **service_role key**: Never expose in frontend! Use only in server-side code

### 3. Database Roles

The schema creates these user roles:
- `customer`: Default role for new users
- `staff`: Can view/update orders
- `admin`: Full access to products and orders

## 📊 Monitoring & Logs

### 1. Database Logs

Monitor database activity in **Logs** → **Database**:
- Query performance
- Error logs
- Connection stats

### 2. Authentication Logs

Track auth events in **Logs** → **Auth**:
- Sign-ups
- Sign-ins
- Password resets

### 3. API Usage

Monitor API usage in **Settings** → **Usage**:
- Database requests
- Auth requests
- Storage usage

## 🚀 Production Deployment

### 1. Environment Variables

For production deployment (Vercel, Netlify, etc.):

1. Add environment variables in your hosting platform
2. Use the same variable names as in `.env`
3. Never expose service role keys in frontend

### 2. Domain Configuration

1. Update **Site URL** in Supabase auth settings
2. Add production domain to allowed origins
3. Update CORS settings if needed

### 3. Database Backups

Supabase automatically backs up your database:
- Point-in-time recovery available
- Manual backups can be created
- Export options available in dashboard

## 🛠️ Troubleshooting

### Common Issues

1. **Connection Errors**
   - Verify URL and API key are correct
   - Check network connectivity
   - Ensure project is not paused

2. **Authentication Issues**
   - Check email confirmation settings
   - Verify site URL configuration
   - Check browser console for errors

3. **Database Errors**
   - Verify RLS policies are correct
   - Check user permissions
   - Review database logs

4. **CORS Errors**
   - Add your domain to allowed origins
   - Check authentication settings
   - Verify API key permissions

### Getting Help

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Discord Community](https://discord.supabase.com)
- [GitHub Issues](https://github.com/supabase/supabase/issues)

## 📝 Next Steps

After completing this setup:

1. ✅ Test all authentication flows
2. ✅ Verify database operations work
3. ✅ Test RLS policies
4. 🔄 Integrate with your application
5. 🔄 Deploy to production
6. 🔄 Monitor usage and performance

---

**Setup Complete!** 🎉

Your Supabase backend is now ready for the Sirsandwich Shop application. The database includes sample data, authentication is configured, and security policies are in place.

## 🎯 Quick Start Checklist

- [ ] Create Supabase account and project
- [ ] Copy Project URL and anon key
- [ ] Create `.env` file with credentials
- [ ] Run `docs/database-schema.sql` in SQL Editor
- [ ] Enable email authentication
- [ ] Test login at `/login`
- [ ] Verify user creation in dashboard
- [ ] Test admin features (if admin user)

## 🔗 Useful Links

- **Supabase Dashboard**: [app.supabase.com](https://app.supabase.com)
- **Documentation**: [supabase.com/docs](https://supabase.com/docs)
- **SQL Editor**: Your Project → SQL Editor
- **Table Editor**: Your Project → Table Editor
- **Authentication**: Your Project → Authentication 