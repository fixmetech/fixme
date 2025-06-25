import 'package:fixme/widgets/service_box.dart';
import 'package:flutter/material.dart';


class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          // Row 1: Car & Home
          Row(
            children: [
              Expanded(child: ServiceBox(title: 'car', height: 120,)),
              const SizedBox(width: 12),
              Expanded(child: ServiceBox(title: 'home', height: 120,)),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Towing, Electrical, Plumbing
          Row(
            children: [
              Expanded(child: ServiceBox(title: 'towing', height: 100,)),
              const SizedBox(width: 12),
              Expanded(child: ServiceBox(title: 'electrical', height: 100,)),
              const SizedBox(width: 12),
              Expanded(child: ServiceBox(title: 'plumbing', height: 100,)),
            ],
          ),
          const SizedBox(height: 12),

          // Row 3: More button full width
          SizedBox(
            width: double.infinity,
            child: ServiceBox(title: 'more', height: 50,),
          ),
        ],
      ),
    );
  }
}
