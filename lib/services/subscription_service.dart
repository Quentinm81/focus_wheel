import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service chargé d'interagir avec l'API backend pour la gestion des abonnements.
class SubscriptionService {
  final http.Client _client;
  final String _baseUrl;

  SubscriptionService({http.Client? client})
      : _client = client ?? http.Client(),
        _baseUrl = dotenv.env['API_URL']?.trim() ?? 'http://localhost:3000';

  /// Crée un nouvel abonnement Stripe.
  ///
  /// [customerId]  – identifiant Stripe du customer.
  /// [priceId]     – ID du prix (Price) configuré sur Stripe.
  /// [paymentMethodId] – ID de la carte / méthode de paiement par défaut.
  ///
  /// Renvoie la réponse JSON décodée.
  Future<Map<String, dynamic>> createSubscription({
    required String customerId,
    required String priceId,
    required String paymentMethodId,
  }) async {
    final uri = Uri.parse('$_baseUrl/create-subscription');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customer': customerId,
        'price': priceId,
        'paymentMethod': paymentMethodId,
      }),
    );
    _throwIfError(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Annule un abonnement Stripe.
  Future<Map<String, dynamic>> cancelSubscription(String subscriptionId) async {
    final uri = Uri.parse('$_baseUrl/cancel-subscription');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'subscriptionId': subscriptionId,
      }),
    );
    _throwIfError(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Met à jour la méthode de paiement par défaut d'un abonnement.
  Future<Map<String, dynamic>> updatePaymentMethod({
    required String subscriptionId,
    required String paymentMethodId,
  }) async {
    final uri = Uri.parse('$_baseUrl/update-payment-method');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'subscriptionId': subscriptionId,
        'paymentMethod': paymentMethodId,
      }),
    );
    _throwIfError(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  void _throwIfError(http.Response res) {
    if (res.statusCode >= 400) {
      throw Exception(
        'Erreur API (${res.statusCode}) : ${res.body.isNotEmpty ? res.body : res.reasonPhrase}',
      );
    }
  }

  /// Ferme le client HTTP (à appeler dans dispose).
  void close() => _client.close();
}