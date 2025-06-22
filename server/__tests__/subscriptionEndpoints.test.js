const request = require('supertest');

// ----------------------------------------------
// Mock Stripe SDK
// ----------------------------------------------

const stripeMock = {
  subscriptions: {
    create: jest.fn(),
    del: jest.fn(),
    retrieve: jest.fn(),
    update: jest.fn(),
  },
  paymentMethods: {
    attach: jest.fn(),
  },
};

jest.mock('stripe', () => {
  return jest.fn(() => stripeMock);
});

// Charge l'application après avoir mocké Stripe
const app = require('../index');

// Utilitaire pour réinitialiser les mocks entre les tests
beforeEach(() => {
  jest.clearAllMocks();
});

// ---------------------------------------------------------------------------
// Tests pour /create-subscription
// ---------------------------------------------------------------------------

describe('POST /create-subscription', () => {
  it('crée un abonnement et renvoie 200', async () => {
    stripeMock.subscriptions.create.mockResolvedValue({ id: 'sub_123' });

    const res = await request(app)
      .post('/create-subscription')
      .send({
        customer: 'cus_test',
        price: 'price_123',
        paymentMethod: 'pm_123',
      });

    expect(res.statusCode).toBe(200);
    expect(res.body.ok).toBe(true);
    expect(stripeMock.subscriptions.create).toHaveBeenCalledWith({
      customer: 'cus_test',
      items: [{ price: 'price_123' }],
      default_payment_method: 'pm_123',
    });
  });

  it('renvoie 400 si paramètres manquants', async () => {
    const res = await request(app).post('/create-subscription').send({});
    expect(res.statusCode).toBe(400);
  });
});

// ---------------------------------------------------------------------------
// Tests pour /cancel-subscription
// ---------------------------------------------------------------------------

describe('POST /cancel-subscription', () => {
  it('annule un abonnement et renvoie 200', async () => {
    stripeMock.subscriptions.del.mockResolvedValue({ id: 'sub_123', canceled: true });

    const res = await request(app)
      .post('/cancel-subscription')
      .send({ subscriptionId: 'sub_123' });

    expect(res.statusCode).toBe(200);
    expect(res.body.ok).toBe(true);
    expect(stripeMock.subscriptions.del).toHaveBeenCalledWith('sub_123');
  });

  it('renvoie 400 si subscriptionId manquant', async () => {
    const res = await request(app).post('/cancel-subscription').send({});
    expect(res.statusCode).toBe(400);
  });
});

// ---------------------------------------------------------------------------
// Tests pour /update-payment-method
// ---------------------------------------------------------------------------

describe('POST /update-payment-method', () => {
  it('met à jour la carte et renvoie 200', async () => {
    stripeMock.subscriptions.retrieve.mockResolvedValue({ customer: 'cus_test' });
    stripeMock.paymentMethods.attach.mockResolvedValue({});
    stripeMock.subscriptions.update.mockResolvedValue({ id: 'sub_123', updated: true });

    const res = await request(app)
      .post('/update-payment-method')
      .send({ subscriptionId: 'sub_123', paymentMethod: 'pm_new' });

    expect(res.statusCode).toBe(200);
    expect(res.body.ok).toBe(true);

    expect(stripeMock.subscriptions.retrieve).toHaveBeenCalledWith('sub_123');
    expect(stripeMock.paymentMethods.attach).toHaveBeenCalledWith('pm_new', { customer: 'cus_test' });
    expect(stripeMock.subscriptions.update).toHaveBeenCalledWith('sub_123', {
      default_payment_method: 'pm_new',
    });
  });

  it('renvoie 400 si paramètres manquants', async () => {
    const res = await request(app).post('/update-payment-method').send({});
    expect(res.statusCode).toBe(400);
  });
});