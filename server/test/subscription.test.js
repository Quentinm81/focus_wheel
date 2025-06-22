const request = require('supertest');
const nock = require('nock');
const app = require('../src/index.js');

const stripeApiBase = 'https://api.stripe.com';

describe('POST /create-subscription', () => {
  afterEach(() => nock.cleanAll());

  it('devrait créer un abonnement et retourner le client_secret', async () => {
    // Préparation du mock Stripe
    const customerId = 'cus_test_123';
    const priceId = 'price_test_123';

    const mockSubscriptionResponse = {
      id: 'sub_test_123',
      latest_invoice: {
        payment_intent: {
          client_secret: 'pi_secret_test_123',
        },
      },
    };

    nock(stripeApiBase)
      .post('/v1/subscriptions')
      .reply(200, mockSubscriptionResponse);

    const response = await request(app)
      .post('/create-subscription')
      .send({ customerId, priceId });

    expect(response.status).toBe(200);
    expect(response.body.subscriptionId).toBe(mockSubscriptionResponse.id);
    expect(response.body.clientSecret).toBe('pi_secret_test_123');
  });

  it('devrait retourner 400 si les paramètres sont manquants', async () => {
    const response = await request(app).post('/create-subscription').send({});

    expect(response.status).toBe(400);
    expect(response.body.error).toBeDefined();
  });
});