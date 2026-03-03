import 'scheme_model.dart';

class SchemeService {

  static Future<List<SchemeModel>> getSchemes() async {

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    return const [

      SchemeModel(
        title: "Suvarna Gold Savings",
        duration: "11 Months",
        minAmount: "₹1,000/mo",
        benefits: [
          "Bonus gold on maturity",
          "Flexible monthly amount",
          "No making charges on select items",
        ],
      ),

      SchemeModel(
        title: "Suvarna Diamond Plan",
        duration: "18 Months",
        minAmount: "₹2,500/mo",
        benefits: [
          "5% bonus on maturity",
          "Priority access to new collections",
          "Free hallmarking",
        ],
      ),

      SchemeModel(
        title: "Suvarna Heritage Plan",
        duration: "24 Months",
        minAmount: "₹5,000/mo",
        benefits: [
          "8% bonus on maturity",
          "Exclusive heritage designs",
          "Free insurance cover",
          "Personal jewellery advisor",
        ],
      ),

    ];
  }
}