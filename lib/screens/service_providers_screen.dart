import 'package:fixme/widgets/service_provider_card.dart';
import 'package:flutter/material.dart';

class ServiceProvidersScreen extends StatelessWidget {
  const ServiceProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Service Providers'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ServiceProviderCard(
            name: 'AutoCare Center',
            rating: 4.5,
            serviceType: 'Vehicle Services',
            distance: '1.2 km',
          ),
          ServiceProviderCard(
            name: 'HomeFix Solutions',
            rating: 4.8,
            serviceType: 'Home Services',
            distance: '0.8 km',
          ),
          ServiceProviderCard(
            name: 'Quick Towing',
            rating: 4.2,
            serviceType: 'Towing',
            distance: '3.5 km',
          ),
        ],
      ),
    );
  }
}
