# Supabase Email Templates for Sirsandwich Shop

This document contains all the email templates for Supabase authentication. Copy and paste these into your Supabase dashboard under **Authentication** → **Email Templates**.

## 📧 Available Templates

1. [Confirm Signup](#confirm-signup)
2. [Invite User](#invite-user)
3. [Magic Link](#magic-link)
4. [Change Email Address](#change-email-address)
5. [Reset Password](#reset-password)
6. [Reauthentication](#reauthentication)

## 🔧 Available Variables

- `{{ .ConfirmationURL }}` - URL for email confirmation
- `{{ .Token }}` - Authentication token
- `{{ .TokenHash }}` - Hashed token for security
- `{{ .SiteURL }}` - Your application's base URL
- `{{ .Email }}` - User's current email address
- `{{ .NewEmail }}` - User's new email address (for email changes)
- `{{ .Data }}` - Additional user metadata
- `{{ .RedirectTo }}` - URL to redirect after action

---

## Confirm Signup

**Subject:** Welcome to Sirsandwich Shop! Please confirm your email

**HTML Template:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Sirsandwich Shop</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; background: #28a745; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
        .button:hover { background: #218838; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
        .sandwich-icon { font-size: 48px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="header">
        <div class="sandwich-icon">🥪</div>
        <h1>Welcome to Sirsandwich Shop!</h1>
        <p>Premium sandwiches made fresh daily</p>
    </div>
    
    <div class="content">
        <h2>Hi there! 👋</h2>
        
        <p>Thank you for joining Sirsandwich Shop! We're excited to have you as part of our sandwich-loving community.</p>
        
        <p>To get started and secure your account, please confirm your email address by clicking the button below:</p>
        
        <div style="text-align: center;">
            <a href="{{ .ConfirmationURL }}" class="button">Confirm Email Address</a>
        </div>
        
        <p>Once confirmed, you'll be able to:</p>
        <ul>
            <li>🛒 Browse our delicious menu</li>
            <li>🛍️ Place orders with saved preferences</li>
            <li>📋 Track your order history</li>
            <li>⭐ Save your favorite sandwiches</li>
            <li>🎯 Receive exclusive offers and updates</li>
        </ul>
        
        <p><strong>Email:</strong> {{ .Email }}</p>
        
        <hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">
        
        <p><small>If you didn't create an account with us, you can safely ignore this email. The link will expire in 24 hours for security.</small></p>
        
        <p><small>If the button doesn't work, copy and paste this link into your browser:<br>
        <a href="{{ .ConfirmationURL }}">{{ .ConfirmationURL }}</a></small></p>
    </div>
    
    <div class="footer">
        <p>© 2024 Sirsandwich Shop | Premium Sandwiches Made Fresh Daily</p>
        <p>Visit us at <a href="{{ .SiteURL }}">{{ .SiteURL }}</a></p>
    </div>
</body>
</html>
```

---

## Invite User

**Subject:** You're invited to join Sirsandwich Shop!

**HTML Template:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invitation to Sirsandwich Shop</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #ff6b6b 0%, #ffa500 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; background: #ff6b6b; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
        .button:hover { background: #ff5252; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
        .invitation-icon { font-size: 48px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="header">
        <div class="invitation-icon">🎉</div>
        <h1>You're Invited!</h1>
        <p>Join Sirsandwich Shop</p>
    </div>
    
    <div class="content">
        <h2>Special Invitation 🥪</h2>
        
        <p>You've been invited to join Sirsandwich Shop, where we craft premium sandwiches with the finest ingredients, made fresh daily!</p>
        
        <p>Click the button below to accept your invitation and create your account:</p>
        
        <div style="text-align: center;">
            <a href="{{ .ConfirmationURL }}" class="button">Accept Invitation</a>
        </div>
        
        <p>As a member, you'll enjoy:</p>
        <ul>
            <li>🍞 Access to our full menu of artisanal sandwiches</li>
            <li>🚀 Fast and easy online ordering</li>
            <li>💾 Saved preferences and order history</li>
            <li>🎁 Exclusive member offers and discounts</li>
            <li>📱 Priority customer support</li>
        </ul>
        
        <p><strong>Invited Email:</strong> {{ .Email }}</p>
        
        <hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">
        
        <p><small>This invitation was sent to {{ .Email }}. If you weren't expecting this invitation, you can safely ignore this email.</small></p>
        
        <p><small>If the button doesn't work, copy and paste this link into your browser:<br>
        <a href="{{ .ConfirmationURL }}">{{ .ConfirmationURL }}</a></small></p>
    </div>
    
    <div class="footer">
        <p>© 2024 Sirsandwich Shop | Premium Sandwiches Made Fresh Daily</p>
        <p>Visit us at <a href="{{ .SiteURL }}">{{ .SiteURL }}</a></p>
    </div>
</body>
</html>
```

---

## Magic Link

**Subject:** Your secure sign-in link for Sirsandwich Shop

**HTML Template:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Magic Link Sign In</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; background: #6f42c1; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
        .button:hover { background: #5a32a3; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
        .magic-icon { font-size: 48px; margin-bottom: 10px; }
        .security-note { background: #e3f2fd; padding: 15px; border-left: 4px solid #2196f3; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <div class="magic-icon">✨</div>
        <h1>Magic Link Sign In</h1>
        <p>Secure, password-free access</p>
    </div>
    
    <div class="content">
        <h2>Sign in to Sirsandwich Shop 🔐</h2>
        
        <p>Click the button below to securely sign in to your Sirsandwich Shop account. No password required!</p>
        
        <div style="text-align: center;">
            <a href="{{ .ConfirmationURL }}" class="button">Sign In Securely</a>
        </div>
        
        <div class="security-note">
            <strong>🛡️ Security Note:</strong> This magic link will automatically sign you in and expires in 1 hour for your security.
        </div>
        
        <p><strong>Account Email:</strong> {{ .Email }}</p>
        
        <p>After signing in, you can:</p>
        <ul>
            <li>🛒 Browse our fresh sandwich menu</li>
            <li>📋 View your order history</li>
            <li>⚙️ Update your account preferences</li>
            <li>🎯 Access exclusive member features</li>
        </ul>
        
        <hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">
        
        <p><small>If you didn't request this sign-in link, you can safely ignore this email. Someone may have entered your email address by mistake.</small></p>
        
        <p><small>If the button doesn't work, copy and paste this link into your browser:<br>
        <a href="{{ .ConfirmationURL }}">{{ .ConfirmationURL }}</a></small></p>
    </div>
    
    <div class="footer">
        <p>© 2024 Sirsandwich Shop | Premium Sandwiches Made Fresh Daily</p>
        <p>Visit us at <a href="{{ .SiteURL }}">{{ .SiteURL }}</a></p>
    </div>
</body>
</html>
```

---

## Change Email Address

**Subject:** Confirm your new email address for Sirsandwich Shop

**HTML Template:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Email Change</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; background: #17a2b8; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
        .button:hover { background: #138496; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
        .email-icon { font-size: 48px; margin-bottom: 10px; }
        .email-change-box { background: #fff3cd; padding: 15px; border-left: 4px solid #ffc107; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <div class="email-icon">📧</div>
        <h1>Email Change Request</h1>
        <p>Confirm your new email address</p>
    </div>
    
    <div class="content">
        <h2>Confirm Email Address Change 🔄</h2>
        
        <p>You've requested to change your email address for your Sirsandwich Shop account. Please confirm this change by clicking the button below:</p>
        
        <div style="text-align: center;">
            <a href="{{ .ConfirmationURL }}" class="button">Confirm Email Change</a>
        </div>
        
        <div class="email-change-box">
            <strong>📝 Email Change Details:</strong><br>
            <strong>Current Email:</strong> {{ .Email }}<br>
            <strong>New Email:</strong> {{ .NewEmail }}
        </div>
        
        <p><strong>Important:</strong> After confirmation:</p>
        <ul>
            <li>✅ Your new email will become your login email</li>
            <li>📧 All future communications will be sent to your new email</li>
            <li>🔐 You'll need to use the new email for sign-in</li>
            <li>📋 Your order history and preferences will remain intact</li>
        </ul>
        
        <hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">
        
        <p><small>If you didn't request this email change, please ignore this email and contact our support team immediately. Your current email address will remain unchanged.</small></p>
        
        <p><small>If the button doesn't work, copy and paste this link into your browser:<br>
        <a href="{{ .ConfirmationURL }}">{{ .ConfirmationURL }}</a></small></p>
    </div>
    
    <div class="footer">
        <p>© 2024 Sirsandwich Shop | Premium Sandwiches Made Fresh Daily</p>
        <p>Visit us at <a href="{{ .SiteURL }}">{{ .SiteURL }}</a></p>
    </div>
</body>
</html>
```

---

## Reset Password

**Subject:** Reset your Sirsandwich Shop password

**HTML Template:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; background: #dc3545; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
        .button:hover { background: #c82333; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
        .lock-icon { font-size: 48px; margin-bottom: 10px; }
        .security-tips { background: #d1ecf1; padding: 15px; border-left: 4px solid #bee5eb; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <div class="lock-icon">🔒</div>
        <h1>Password Reset</h1>
        <p>Secure your account</p>
    </div>
    
    <div class="content">
        <h2>Reset Your Password 🔑</h2>
        
        <p>You've requested to reset your password for your Sirsandwich Shop account. Click the button below to create a new password:</p>
        
        <div style="text-align: center;">
            <a href="{{ .ConfirmationURL }}" class="button">Reset Password</a>
        </div>
        
        <p><strong>Account Email:</strong> {{ .Email }}</p>
        
        <div class="security-tips">
            <strong>🛡️ Security Tips for Your New Password:</strong>
            <ul style="margin: 10px 0;">
                <li>Use at least 8 characters</li>
                <li>Include uppercase and lowercase letters</li>
                <li>Add numbers and special characters</li>
                <li>Avoid using personal information</li>
                <li>Don't reuse old passwords</li>
            </ul>
        </div>
        
        <p><strong>This link will expire in 1 hour</strong> for your security. If you need a new reset link, you can request another one from our sign-in page.</p>
        
        <hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">
        
        <p><small>If you didn't request a password reset, you can safely ignore this email. Your password will remain unchanged. If you're concerned about your account security, please contact our support team.</small></p>
        
        <p><small>If the button doesn't work, copy and paste this link into your browser:<br>
        <a href="{{ .ConfirmationURL }}">{{ .ConfirmationURL }}</a></small></p>
    </div>
    
    <div class="footer">
        <p>© 2024 Sirsandwich Shop | Premium Sandwiches Made Fresh Daily</p>
        <p>Visit us at <a href="{{ .SiteURL }}">{{ .SiteURL }}</a></p>
    </div>
</body>
</html>
```

---

## Reauthentication

**Subject:** Confirm your identity for Sirsandwich Shop

**HTML Template:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reauthentication Required</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #fd7e14 0%, #e55a4e 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; background: #fd7e14; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
        .button:hover { background: #e55a4e; }
        .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
        .shield-icon { font-size: 48px; margin-bottom: 10px; }
        .security-alert { background: #fff3cd; padding: 15px; border-left: 4px solid #ffc107; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <div class="shield-icon">🛡️</div>
        <h1>Identity Verification</h1>
        <p>Confirm your identity</p>
    </div>
    
    <div class="content">
        <h2>Reauthentication Required 🔐</h2>
        
        <p>For your security, we need to verify your identity before proceeding with this sensitive action on your Sirsandwich Shop account.</p>
        
        <div style="text-align: center;">
            <a href="{{ .ConfirmationURL }}" class="button">Verify Identity</a>
        </div>
        
        <div class="security-alert">
            <strong>🔒 Why is this needed?</strong><br>
            This extra verification step helps protect your account from unauthorized access when performing sensitive operations like changing passwords, updating payment methods, or modifying account settings.
        </div>
        
        <p><strong>Account Email:</strong> {{ .Email }}</p>
        
        <p>After verification, you'll be able to:</p>
        <ul>
            <li>✅ Complete your requested action securely</li>
            <li>🔐 Maintain full account protection</li>
            <li>📱 Continue using all account features</li>
            <li>🛡️ Keep your personal information safe</li>
        </ul>
        
        <p><strong>This verification link expires in 15 minutes</strong> for maximum security.</p>
        
        <hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">
        
        <p><small>If you didn't initiate this action, please ignore this email and consider changing your password. If you're concerned about your account security, contact our support team immediately.</small></p>
        
        <p><small>If the button doesn't work, copy and paste this link into your browser:<br>
        <a href="{{ .ConfirmationURL }}">{{ .ConfirmationURL }}</a></small></p>
    </div>
    
    <div class="footer">
        <p>© 2024 Sirsandwich Shop | Premium Sandwiches Made Fresh Daily</p>
        <p>Visit us at <a href="{{ .SiteURL }}">{{ .SiteURL }}</a></p>
    </div>
</body>
</html>
```

---

## 📋 Implementation Instructions

### 1. Access Supabase Email Templates
1. Go to your Supabase dashboard
2. Navigate to **Authentication** → **Email Templates**
3. Select each template type from the dropdown

### 2. Copy Template Content
1. Copy the HTML content from above
2. Paste into the **Message (HTML)** field
3. Update the **Subject** field with the provided subject line
4. Click **Save** for each template

### 3. Customize for Your Brand
- Replace "Sirsandwich Shop" with your actual business name
- Update colors in the CSS to match your brand
- Modify the footer with your actual website URL
- Add your logo URL if desired

### 4. Test Templates
- Use Supabase's test email feature
- Verify all links work correctly
- Check email rendering in different clients
- Test on mobile devices

## 🎨 Customization Options

### Colors Used
- **Primary Blue**: `#667eea` to `#764ba2`
- **Success Green**: `#28a745`
- **Warning Orange**: `#fd7e14`
- **Danger Red**: `#dc3545`
- **Info Cyan**: `#17a2b8`

### Responsive Design
All templates are mobile-responsive and will display correctly on:
- Desktop email clients
- Mobile email apps
- Web-based email services

### Brand Elements
- Sandwich emoji (🥪) as brand icon
- Gradient backgrounds for visual appeal
- Professional typography and spacing
- Clear call-to-action buttons

---

**Templates Ready!** 🎉 Copy these into your Supabase dashboard to provide a professional email experience for your users. 