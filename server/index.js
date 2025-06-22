// Chargement des variables d'environnement
require('dotenv').config();

const express = require('express');
const cors = require('cors');
const Stripe = require('stripe');

// Initialise Stripe (clé fictive par défaut pour éviter les crash en dev)
const stripe = Stripe(process.env.STRIPE_SECRET_KEY || 'sk_test_dummy');

const app = express();

// Middleware CORS sécurisé (origines autorisées définies dans CLIENT_ORIGIN)
const allowedOrigins = (process.env.CLIENT_ORIGIN || '').split(',').map((o) => o.trim()).filter((o) => o);

app.use(
  cors({
    origin: (origin, callback) => {
      // Autorise les requêtes server-side ou Postman sans header Origin
      if (!origin) return callback(null, true);

      if (allowedOrigins.length === 0 || allowedOrigins.includes(origin)) {
        return callback(null, true);
      }
      return callback(new Error('Not allowed by CORS'));
    },
    credentials: true,
  }),
);

// -----------------------------------------------------------------------------
// Webhook Stripe (doit être déclaré AVANT express.json())
// -----------------------------------------------------------------------------
app.post('/webhook', express.raw({ type: 'application/json' }), (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;
  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET || 'whsec_dummy'
    );
  } catch (err) {
    console.error('❌  Signature webhook invalide', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Traitement des évènements pertinents
  switch (event.type) {
    case 'customer.subscription.updated':
      console.log('📩 subscription updated');
      // TODO: mettre à jour la BDD / notifier
      break;
    case 'charge.refunded':
      console.log('📩 charge refunded');
      // TODO: mettre à jour la BDD / notifier
      break;
    default:
      console.log(`ℹ️  Évènement non géré: ${event.type}`);
  }

  return res.json({ received: true });
});

// Parse JSON pour toutes les routes (sauf webhook ci-dessus)
app.use(express.json());

// Middleware d'authentification simple via header Authorization: Bearer <API_KEY>
app.use((req, res, next) => {
  const requiredKey = process.env.API_KEY;
  if (!requiredKey) return next(); // aucune clé requise si non définie

  const header = req.get('Authorization');
  if (header !== `Bearer ${requiredKey}`) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  next();
});

// -----------------------------------------------------------------------------
// Endpoints abonnement Stripe
// -----------------------------------------------------------------------------

// 1) Créer un abonnement
app.post('/create-subscription', async (req, res) => {
  const { customer, price, paymentMethod } = req.body;
  if (!customer || !price || !paymentMethod) {
    return res.status(400).json({ error: 'Missing parameters' });
  }

  try {
    const subscription = await stripe.subscriptions.create({
      customer,
      items: [{ price }],
      default_payment_method: paymentMethod,
    });
    return res.json({ ok: true, subscription });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
});

// 2) Résilier un abonnement
app.post('/cancel-subscription', async (req, res) => {
  const { subscriptionId } = req.body;
  if (!subscriptionId) {
    return res.status(400).json({ error: 'Missing subscriptionId' });
  }

  try {
    const canceled = await stripe.subscriptions.del(subscriptionId);
    return res.json({ ok: true, subscription: canceled });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
});

// 3) Mettre à jour la carte par défaut
app.post('/update-payment-method', async (req, res) => {
  const { subscriptionId, paymentMethod } = req.body;
  if (!subscriptionId || !paymentMethod) {
    return res.status(400).json({ error: 'Missing parameters' });
  }

  try {
    // Attache d'abord le PM au customer de l'abonnement
    const subscription = await stripe.subscriptions.retrieve(subscriptionId);
    await stripe.paymentMethods.attach(paymentMethod, { customer: subscription.customer });

    const updated = await stripe.subscriptions.update(subscriptionId, {
      default_payment_method: paymentMethod,
    });

    return res.json({ ok: true, subscription: updated });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
});

// -----------------------------------------------------------------------------
// Lancement du serveur
// -----------------------------------------------------------------------------

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀  Backend prêt sur http://localhost:${PORT}`);
});

module.exports = app; // pour les tests Jest