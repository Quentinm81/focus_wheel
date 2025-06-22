const express = require('express');
const dotenv = require('dotenv');
const Stripe = require('stripe');

// Chargement de la configuration d'environnement
dotenv.config();

const app = express();
const port = process.env.PORT || 4242;

// Stripe nécessite l'accès au Buffer brut du corps pour valider la signature du webhook
app.use(
  express.json({
    verify: (req, res, buf) => {
      // On stocke le buffer brut pour la route webhook seulement
      if (req.originalUrl === '/webhooks') {
        req.rawBody = buf;
      }
    },
  }),
);

// Initialisation du client Stripe
const stripeSecretKey = process.env.STRIPE_SECRET_KEY || 'sk_test_dummy';
const stripe = new Stripe(stripeSecretKey, {
  apiVersion: '2023-10-16',
});

/**
 * Endpoint pour créer un abonnement Stripe.
 * Corps attendu : { customerId: string, priceId: string }
 */
app.post('/create-subscription', async (req, res) => {
  try {
    const { customerId, priceId } = req.body;

    if (!customerId || !priceId) {
      return res.status(400).json({ error: 'customerId et priceId sont requis.' });
    }

    // Création de l'abonnement
    const subscription = await stripe.subscriptions.create({
      customer: customerId,
      items: [{ price: priceId }],
      payment_behavior: 'default_incomplete',
      expand: ['latest_invoice.payment_intent'],
    });

    const clientSecret = subscription.latest_invoice.payment_intent.client_secret;

    res.status(200).json({ subscriptionId: subscription.id, clientSecret });
  } catch (err) {
    console.error('[create-subscription] Erreur :', err.message);
    res.status(500).json({ error: 'Échec de création de l\'abonnement.' });
  }
});

/**
 * Endpoint Webhook pour recevoir les événements Stripe.
 */
app.post('/webhooks', (req, res) => {
  const sig = req.headers['stripe-signature'];
  const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET;

  let event;

  try {
    if (!endpointSecret) {
      throw new Error('STRIPE_WEBHOOK_SECRET manquant.');
    }

    event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
  } catch (err) {
    console.error('[webhooks] Signature invalide :', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Traitement des événements pertinents
  switch (event.type) {
    case 'invoice.payment_succeeded':
      console.log('Paiement réussi pour :', event.data.object.id);
      break;
    case 'invoice.payment_failed':
      console.log('Paiement échoué pour :', event.data.object.id);
      break;
    case 'customer.subscription.deleted':
      console.log('Abonnement annulé :', event.data.object.id);
      break;
    default:
      console.log(`Événement non géré : ${event.type}`);
  }

  // Accusé de réception à Stripe
  res.json({ received: true });
});

// Démarrage du serveur uniquement si l'on n'est pas en test
if (process.env.NODE_ENV !== 'test') {
  app.listen(port, () => {
    console.log(`Backend Focus Wheel démarré sur le port ${port}`);
  });
}

module.exports = app;