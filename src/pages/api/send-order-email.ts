import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request }) => {
  try {
    const body = await request.json();
    const { order, customer } = body;

    // Validate required data
    if (!order || !customer || !customer.email) {
      return new Response(JSON.stringify({ 
        error: 'Missing required order or customer data' 
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }

    // For now, we'll simulate email sending
    // In a real implementation, you would integrate with Resend, SendGrid, or similar
    console.log('📧 Sending order confirmation email to:', customer.email);
    console.log('📦 Order details:', {
      orderId: order.id,
      total: order.total_amount,
      items: order.items?.length || 0
    });

    // Simulate email content
    const emailContent = {
      to: customer.email,
      subject: `Order Confirmation - Sirsandwich Shop #${order.id.slice(0, 8).toUpperCase()}`,
      html: generateOrderEmailHTML(order, customer)
    };

    // TODO: Replace with actual email service integration
    // Example with Resend:
    /*
    const resend = new Resend(process.env.RESEND_API_KEY);
    
    const { data, error } = await resend.emails.send({
      from: 'orders@sirsandwich.com',
      to: customer.email,
      subject: emailContent.subject,
      html: emailContent.html,
    });

    if (error) {
      throw new Error(`Email sending failed: ${error.message}`);
    }
    */

    // For demo purposes, log the email content
    console.log('📧 Email content generated:', emailContent.subject);

    return new Response(JSON.stringify({ 
      success: true,
      message: 'Order confirmation email sent successfully',
      emailPreview: emailContent.html
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    });

  } catch (error) {
    console.error('❌ Email sending error:', error);
    
    return new Response(JSON.stringify({ 
      error: 'Failed to send order confirmation email',
      details: error instanceof Error ? error.message : 'Unknown error'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

// Generate HTML email template
function generateOrderEmailHTML(order: any, customer: any): string {
  const orderNumber = order.id.slice(0, 8).toUpperCase();
  const orderDate = new Date(order.created_at).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });

  return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Order Confirmation</title>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #f97316; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
        .content { background: #f9f9f9; padding: 20px; border-radius: 0 0 8px 8px; }
        .order-details { background: white; padding: 15px; border-radius: 6px; margin: 15px 0; }
        .item { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }
        .total { font-weight: bold; font-size: 1.2em; color: #f97316; }
        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 0.9em; }
      </style>
    </head>
    <body>
      <div class="header">
        <h1>🥪 Sirsandwich Shop</h1>
        <h2>Order Confirmation</h2>
      </div>
      
      <div class="content">
        <p>Dear ${customer.firstName} ${customer.lastName},</p>
        
        <p>Thank you for your order! We're excited to prepare your delicious sandwiches.</p>
        
        <div class="order-details">
          <h3>Order #${orderNumber}</h3>
          <p><strong>Order Date:</strong> ${orderDate}</p>
          <p><strong>Status:</strong> ${order.status.charAt(0).toUpperCase() + order.status.slice(1)}</p>
          
          <h4>Order Items:</h4>
          ${order.items?.map((item: any) => `
            <div class="item">
              <span>${item.product_name} (x${item.quantity})</span>
              <span>$${item.subtotal.toFixed(2)}</span>
            </div>
          `).join('') || '<p>No items found</p>'}
          
          <div class="item total">
            <span>Total Amount:</span>
            <span>$${order.total_amount.toFixed(2)}</span>
          </div>
        </div>
        
        ${customer.delivery ? `
          <div class="order-details">
            <h4>Delivery Address:</h4>
            <p>
              ${customer.delivery.address}<br>
              ${customer.delivery.city}, ${customer.delivery.state} ${customer.delivery.zipCode}
            </p>
            ${customer.delivery.instructions ? `<p><em>Instructions: ${customer.delivery.instructions}</em></p>` : ''}
          </div>
        ` : ''}
        
        <p>We'll send you updates as your order progresses. Your sandwiches will be prepared fresh and delivered as soon as possible.</p>
        
        <p>If you have any questions about your order, please don't hesitate to contact us.</p>
        
        <p>Thank you for choosing Sirsandwich Shop!</p>
      </div>
      
      <div class="footer">
        <p>Sirsandwich Shop - Premium sandwiches made fresh daily</p>
        <p>This is an automated message. Please do not reply to this email.</p>
      </div>
    </body>
    </html>
  `;
} 