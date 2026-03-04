import '../models/product_model.dart';

class ProductService {

  static Future<List<Product>> getProducts() async {

    await Future.delayed(const Duration(milliseconds: 400));

    return [

      Product(
        id: "1",
        name: "Kundan Necklace Set",
        weight: "32.5g",
        image: "assets/images/products/gold_necklace.png",
        category: "Necklaces",
        metal: "gold",
        purity: "22K (916)",
        making: "Handcrafted Kundan",
        hallmark: true,
        description:
        "Exquisite bridal kundan necklace with intricate meenakari work on the reverse side.",
      ),

      Product(
        id: "2",
        name: "Traditional Bangles",
        weight: "18.2g",
        image: "assets/images/products/gold_bangles.png",
        category: "Bangles",
        metal: "gold",
        purity: "22K (916)",
        making: "Machine Cut",
        hallmark: true,
        description:
        "Classic daily-wear bangles with delicate laser-cut patterns.",
      ),

      Product(
        id: "3",
        name: "Royal Gemstone Ring",
        weight: "5.6g",
        image: "assets/images/products/gold_ring.png",
        category: "Rings",
        metal: "gold",
        purity: "18K (750)",
        making: "Cast & Polished",
        hallmark: true,
        description:
        "Statement ring featuring natural emerald centre stone.",
      ),

      Product(
        id: "4",
        name: "Rope Chain",
        weight: "24.8g",
        image: "assets/images/products/gold_chain.png",
        category: "Chains",
        metal: "gold",
        purity: "22K (916)",
        making: "Machine Made",
        hallmark: true,
        description:
        "Sturdy rope-link chain with a high polish finish.",
      ),

      Product(
        id: "5",
        name: "Temple Jhumka Earrings",
        weight: "12.4g",
        image: "assets/images/products/gold_earrings.png",
        category: "Earrings",
        metal: "gold",
        purity: "22K (916)",
        making: "Temple Craft",
        hallmark: true,
        description:
        "Traditional South Indian temple jhumkas with Lakshmi motif.",
      ),

      Product(
        id: "7",
        name: "Ganesha Idol",
        weight: "150g",
        image: "assets/images/products/silver_idol.png",
        category: "Silver Idols",
        metal: "silver",
        purity: "999 Fine Silver",
        making: "Hand Carved",
        hallmark: true,
        description:
        "Pure silver Ganesha idol with fine detailing.",
      ),

      Product(
        id: "8",
        name: "Oxidized Bangles Set",
        weight: "45g",
        image: "assets/images/products/silver_bangles.png",
        category: "Bangles",
        metal: "silver",
        purity: "925 Sterling",
        making: "Oxidized Finish",
        hallmark: true,
        description:
        "Set of oxidized silver bangles with tribal motifs.",
      ),

      Product(
        id: "9",
        name: "Silver Chain",
        weight: "28.5g",
        image: "assets/images/products/silver_chain.png",
        category: "Chains",
        metal: "silver",
        purity: "925 Sterling",
        making: "Machine Made",
        hallmark: true,
        description:
        "Heavy-duty sterling silver chain with rhodium plating.",
      ),

      Product(
        id: "10",
        name: "Silver Ring Classic",
        weight: "8.2g",
        image: "assets/images/products/silver_ring.png",
        category: "Rings",
        metal: "silver",
        purity: "925 Sterling",
        making: "Cast & Polished",
        hallmark: true,
        description:
        "Minimalist sterling silver band with satin finish.",
      ),
    ];
  }
}