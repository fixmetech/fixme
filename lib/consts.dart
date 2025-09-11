import 'package:flutter_dotenv/flutter_dotenv.dart';

// Get Stripe keys from environment variables
String get stripePublishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
String get stripeSecretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? '';