const request = require('supertest');

// ---------------------------------------------------------------------------
// Mock Stripe SDK avec constructEvent
// ---------------------------------------------------------------------------

const stripeMock = {
  webhooks: {
    constructEvent: jest.fn(),
  },
  subscriptions: {},
  paymentMethods: {},
};

jest.mock('stripe', () => {
  return jest.fn(() => stripeMock);
});

const app = require('../index');

beforeEach(() => {
  jest.clearAllMocks();
});

describe('POST /webhook', () => {
  it('accepte un évènement subscription.updated valide', async () => {
    const eventPayload = JSON.stringify({ type: 'customer.subscription.updated' });

    stripeMock.webhooks.constructEvent.mockReturnValue({ type: 'customer.subscription.updated' });

    const res = await request(app)
      .post('/webhook')
      .set('stripe-signature', 'sig_valid')
      .set('Content-Type', 'application/json')
      .send(eventPayload);

    expect(res.statusCode).toBe(200);
    expect(res.body.received).toBe(true);
    expect(stripeMock.webhooks.constructEvent).toHaveBeenCalled();
  });

  it('accepte un évènement charge.refunded valide', async () => {
    const eventPayload = JSON.stringify({ type: 'charge.refunded' });

    stripeMock.webhooks.constructEvent.mockReturnValue({ type: 'charge.refunded' });

    const res = await request(app)
      .post('/webhook')
      .set('stripe-signature', 'sig_valid')
      .set('Content-Type', 'application/json')
      .send(eventPayload);

    expect(res.statusCode).toBe(200);
    expect(res.body.received).toBe(true);
  });

  it('renvoie 400 si la signature est invalide', async () => {
    const eventPayload = JSON.stringify({});
    stripeMock.webhooks.constructEvent.mockImplementation(() => {
      throw new Error('Invalid signature');
    });

    const res = await request(app)
      .post('/webhook')
      .set('stripe-signature', 'bad_sig')
      .set('Content-Type', 'application/json')
      .send(eventPayload);

    expect(res.statusCode).toBe(400);
  });
});