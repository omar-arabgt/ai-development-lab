import 'package:flutter/material.dart';

void main() => runApp(const CarMarketApp());

class CarMarketApp extends StatelessWidget {
  const CarMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Market',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ListingsPage(),
    );
  }
}

class Car {
  const Car(this.name, this.price);
  final String name;
  final int price;
}

const cars = [
  Car('Toyota Corolla 2022', 15500),
  Car('Kia Sportage 2023', 21000),
  // Long names come straight from the dealer feed.
  Car('Mercedes-Benz EQS 580 4MATIC AMG Line Premium Plus 2024', 89000),
  Car('Hyundai Tucson 2024', 24500),
];

class ListingsPage extends StatelessWidget {
  const ListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Market')),
      body: ListView.separated(
        itemCount: cars.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final car = cars[index];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.directions_car, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    car.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${car.price} JOD',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Directionality(
        textDirection: TextDirection.rtl,
        child: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال طلب الحجز')),
            );
          },
          label: const Text('احجز الآن'),
          icon: const Icon(Icons.event_available),
        ),
      ),
    );
  }
}
