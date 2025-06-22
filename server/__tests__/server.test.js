const request = require('supertest');
const { app, server } = require('../index');

// Mock Stripe
jest.mock('stripe', () => {
  return jest.fn().mockImplementation(() => ({
    subscriptions: {
      list: jest.fn().mockResolvedValue({ data: [] }),
      create: jest.fn().mockResolvedValue({ id: 'sub_test123' }),
      cancel: jest.fn().mockResolvedValue({ id: 'sub_test123', status: 'canceled' })
    },
    webhooks: {
      constructEvent: jest.fn().mockReturnValue({
        type: 'payment_intent.succeeded',
        data: { object: { id: 'pi_test123' } }
      })
    }
  }));
});

afterAll((done) => {
  server.close(done);
});

describe('API Endpoints', () => {
  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app).get('/health');
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'healthy');
      expect(response.body).toHaveProperty('timestamp');
    });
  });

  describe('GET /api', () => {
    it('should return API info', async () => {
      const response = await request(app).get('/api');
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('message', 'Focus Wheel API');
      expect(response.body).toHaveProperty('version', '1.0.0');
      expect(response.body).toHaveProperty('endpoints');
    });
  });

  describe('Subscription Endpoints', () => {
    describe('GET /api/subscriptions', () => {
      it('should return subscriptions list', async () => {
        const response = await request(app).get('/api/subscriptions');
        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('data');
      });
    });

    describe('POST /api/subscriptions/create', () => {
      it('should create a subscription', async () => {
        const response = await request(app)
          .post('/api/subscriptions/create')
          .send({
            customerId: 'cus_test123',
            priceId: 'price_test123'
          });
        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('id');
      });

      it('should return 400 if parameters missing', async () => {
        const response = await request(app)
          .post('/api/subscriptions/create')
          .send({});
        expect(response.status).toBe(400);
        expect(response.body).toHaveProperty('error');
      });
    });

    describe('POST /api/subscriptions/cancel', () => {
      it('should cancel a subscription', async () => {
        const response = await request(app)
          .post('/api/subscriptions/cancel')
          .send({
            subscriptionId: 'sub_test123'
          });
        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('status', 'canceled');
      });

      it('should return 400 if subscriptionId missing', async () => {
        const response = await request(app)
          .post('/api/subscriptions/cancel')
          .send({});
        expect(response.status).toBe(400);
        expect(response.body).toHaveProperty('error');
      });
    });
  });

  describe('Webhook Endpoint', () => {
    it('should handle valid webhook', async () => {
      const response = await request(app)
        .post('/webhook')
        .set('stripe-signature', 'valid_signature')
        .send({
          type: 'payment_intent.succeeded',
          data: { object: { id: 'pi_test123' } }
        });
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('received', true);
    });

    it('should return 500 if webhook secret not configured', async () => {
      const originalSecret = process.env.STRIPE_WEBHOOK_SECRET;
      delete process.env.STRIPE_WEBHOOK_SECRET;
      
      const response = await request(app)
        .post('/webhook')
        .send({});
      expect(response.status).toBe(500);
      
      process.env.STRIPE_WEBHOOK_SECRET = originalSecret;
    });
  });

  describe('Error Handling', () => {
    it('should return 404 for unknown endpoint', async () => {
      const response = await request(app).get('/unknown');
      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('error', 'Endpoint not found');
    });
  });
});