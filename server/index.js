require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN || '*',
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);

// General middleware
app.use(compression());
app.use(morgan('combined'));
app.use(express.json({
  verify: (req, res, buf) => {
    // Store raw body for Stripe webhook verification
    if (req.originalUrl.startsWith('/webhook')) {
      req.rawBody = buf.toString('utf8');
    }
  }
}));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// API Routes
app.get('/api', (req, res) => {
  res.json({ 
    message: 'Focus Wheel API', 
    version: '1.0.0',
    endpoints: {
      health: '/health',
      subscriptions: '/api/subscriptions',
      webhook: '/webhook'
    }
  });
});

// Subscription endpoints
app.get('/api/subscriptions', async (req, res) => {
  try {
    const subscriptions = await stripe.subscriptions.list({
      limit: 10,
    });
    res.json(subscriptions);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/subscriptions/create', async (req, res) => {
  try {
    const { customerId, priceId } = req.body;
    
    if (!customerId || !priceId) {
      return res.status(400).json({ 
        error: 'customerId and priceId are required' 
      });
    }

    const subscription = await stripe.subscriptions.create({
      customer: customerId,
      items: [{ price: priceId }],
    });

    res.json(subscription);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/subscriptions/cancel', async (req, res) => {
  try {
    const { subscriptionId } = req.body;
    
    if (!subscriptionId) {
      return res.status(400).json({ 
        error: 'subscriptionId is required' 
      });
    }

    const subscription = await stripe.subscriptions.cancel(subscriptionId);
    res.json(subscription);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Stripe webhook endpoint
app.post('/webhook', async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;

  if (!webhookSecret) {
    console.error('STRIPE_WEBHOOK_SECRET not configured');
    return res.status(500).send('Webhook secret not configured');
  }

  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.rawBody || req.body,
      sig,
      webhookSecret
    );
  } catch (err) {
    console.error('Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object;
      console.log('Payment succeeded:', paymentIntent.id);
      break;
    
    case 'subscription.created':
    case 'subscription.updated':
    case 'subscription.deleted':
      const subscription = event.data.object;
      console.log(`Subscription ${event.type}:`, subscription.id);
      break;
    
    case 'customer.subscription.trial_will_end':
      const trialSubscription = event.data.object;
      console.log('Trial ending soon for:', trialSubscription.id);
      // Send notification email
      break;
    
    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  res.json({ received: true });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

// Start server
const server = app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📡 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🔗 Health check: http://localhost:${PORT}/health`);
});

module.exports = { app, server };