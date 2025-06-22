const request = require('supertest');

// Création d'un mock Stripe utilisable plus tard
const stripeMock = {
  webhooks: {
    constructEvent: jest.fn(),
  },
};

jest.mock('stripe', () => {
  return jest.fn().mockImplementation(() => {
    return {
      webhooks: {
        constructEvent: jest.fn(),
      },
    };
  });
});

const Stripe = require('stripe');
const app = require('../src/index.js');

// Récupère l'instance Stripe créée par l'application pour la manipuler
const stripeMockInstance = Stripe.mock.results[0].value;

describe('POST /webhooks', () => {
  beforeAll(() => {
    process.env.STRIPE_WEBHOOK_SECRET = 'whsec_test';
  });

  it('devrait accepter un webhook valide', async () => {
    stripeMockInstance.webhooks.constructEvent.mockReturnValue({ type: 'invoice.payment_succeeded', data: { object: { id: 'in_test' } } });

    const response = await request(app)
      .post('/webhooks')
      .set('stripe-signature', 'signature_test')
      .send({});

    expect(response.status).toBe(200);
    expect(response.body.received).toBe(true);
  });

  it('devrait rejeter un webhook avec une signature invalide', async () => {
    stripeMockInstance.webhooks.constructEvent.mockImplementation(() => {
      throw new Error('Signature invalide');
    });

    const response = await request(app)
      .post('/webhooks')
      .set('stripe-signature', 'bad_signature')
      .send({});

    expect(response.status).toBe(400);
  });
});