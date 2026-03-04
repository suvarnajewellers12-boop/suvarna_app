import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/product_service.dart';
import '../models/product_model.dart';
import 'widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {

  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  String metalTab = "gold";
  String activeCategory = "All";

  List<Product> products = [];

  final goldCategories = [
    "All","Rings","Chains","Bangles","Anklets","Necklaces","Earrings"
  ];

  final silverCategories = [
    "All","Rings","Chains","Bangles","Anklets","Necklaces","Earrings","Silver Idols"
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {

    final data = await ProductService.getProducts();

    setState(() {
      products = data;
    });
  }

  List<Product> get filteredProducts {

    return products.where((p) {

      final metalMatch = p.metal == metalTab;

      final categoryMatch =
          activeCategory == "All" || p.category == activeCategory;

      return metalMatch && categoryMatch;

    }).toList();
  }

  void _openProduct(Product product){

    showModalBottomSheet(

      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF6F0E4),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),

      builder: (_) => _productDetails(product),

    );
  }

  @override
  Widget build(BuildContext context) {

    final categories =
    metalTab == "gold" ? goldCategories : silverCategories;

    return Stack(
      children: [

        Positioned.fill(
          child: Image.asset(
            "assets/images/showroom_bg.png",
            fit: BoxFit.cover,
          ),
        ),

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

              const SizedBox(height: 18),

              Text(
                "Our Collection",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3B2A1F),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  _metalButton("gold","✦ Gold"),
                  const SizedBox(width: 10),
                  _metalButton("silver","✦ Silver"),

                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: categories.map((cat){

                    final selected = activeCategory == cat;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            activeCategory = cat;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal:16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFFF6F0E4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF7A7267),
                            ),
                          ),
                        ),
                      ),
                    );

                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(

                child: GridView.builder(

                  padding: const EdgeInsets.symmetric(horizontal: 14),

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.78,

                  ),

                  itemCount: filteredProducts.length,

                  itemBuilder: (_,index){

                    final product = filteredProducts[index];

                    return ProductCard(

                      product: product,

                      onTap: (){
                        _openProduct(product);
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

  Widget _metalButton(String metal,String label){

    final selected = metalTab == metal;

    return GestureDetector(

      onTap: (){
        setState(() {
          metalTab = metal;
          activeCategory = "All";
        });
      },

      child: Container(

        padding: const EdgeInsets.symmetric(horizontal:26,vertical:10),

        decoration: BoxDecoration(

          color: selected
              ? const Color(0xFFD4AF37)
              : const Color(0xFFE7DBC9),

          borderRadius: BorderRadius.circular(30),

        ),

        child: Text(

          label,

          style: GoogleFonts.poppins(

            fontWeight: FontWeight.w600,

            color: selected
                ? Colors.white
                : const Color(0xFF6E665A),

          ),
        ),
      ),
    );
  }

  Widget _productDetails(Product product){

    return Padding(

      padding: const EdgeInsets.all(22),

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            product.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              product.image,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            product.description,
            style: GoogleFonts.poppins(fontSize: 13),
          ),

          const SizedBox(height: 18),

          _detail("Purity", product.purity),
          _detail("Weight", product.weight),
          _detail("Making", product.making),
          _detail("Hallmark", product.hallmark ? "BIS Certified" : "N/A"),

          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _detail(String label,String value){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(label,
              style: GoogleFonts.poppins(fontSize: 13)),

          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),

        ],
      ),
    );
  }
}