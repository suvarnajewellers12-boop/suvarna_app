import '../models/rate_model.dart';

class RateService {
  static Future<List<RateModel>> getRates() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      RateModel(
        label: "Gold 22K",
        rate: 6850,
        change: 45,
        unit: "₹/g",
        purity: "91.6%",
        per10g: 68500,
        per100g: 685000,
        perTola: 79913,
        lastUpdated: "2 Mar 2026, 10:30 AM",
      ),
      RateModel(
        label: "Gold 24K",
        rate: 7450,
        change: 60,
        unit: "₹/g",
        purity: "99.9%",
        per10g: 74500,
        per100g: 745000,
        perTola: 86915,
        lastUpdated: "2 Mar 2026, 10:30 AM",
      ),
      RateModel(
        label: "Gold 18K",
        rate: 5138,
        change: 30,
        unit: "₹/g",
        purity: "75.0%",
        per10g: 51380,
        per100g: 513800,
        perTola: 59929,
        lastUpdated: "2 Mar 2026, 10:30 AM",
      ),
      RateModel(
        label: "Silver 999",
        rate: 92,
        change: -1.5,
        unit: "₹/g",
        purity: "99.9%",
        per10g: 920,
        per100g: 9200,
        perTola: 1073,
        lastUpdated: "2 Mar 2026, 10:30 AM",
      ),
      RateModel(
        label: "Silver 925",
        rate: 85,
        change: -1.2,
        unit: "₹/g",
        purity: "92.5%",
        per10g: 850,
        per100g: 8500,
        perTola: 992,
        lastUpdated: "2 Mar 2026, 10:30 AM",
      ),
    ];
  }
}