import 'dart:ui';
import 'package:flutter/material.dart';
import '../../rates/data/rate_service.dart';
import '../models/rate_model.dart';
import 'widgets/rate_card.dart';

class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        /// Background Image
        Positioned.fill(
          child: Image.asset(
            "assets/images/showroom_bg.png",
            fit: BoxFit.cover,
          ),
        ),

        /// Blur layer (same as Home)
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: const Color(0xFFF5EBDD).withOpacity(0.55),
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 10),

              const Text(
                "Live Rates",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Updated today · Market rates",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 14),

              /// Info banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E8D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Rates are indicative and may vary at the time of purchase. Visit store for final pricing.",
                        style: TextStyle(fontSize: 11),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// Rates list
              Expanded(
                child: FutureBuilder<List<RateModel>>(
                  future: RateService.getRates(),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final rates = snapshot.data!;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: rates.length,
                      itemBuilder: (context, index) {
                        return RateCard(rate: rates[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}