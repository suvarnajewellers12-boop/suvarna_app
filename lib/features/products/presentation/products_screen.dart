import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/product_service.dart';
import '../models/product_model.dart';
import 'widgets/product_card.dart';
import 'dart:convert';

class ProductsScreen extends StatefulWidget {

  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  String metalTab = "gold";

  List<Product> products = [];



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
      return p.metalType.toLowerCase() == metalTab;
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

  Widget _productDetails(Product product) {
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
            child: Image.memory(
              base64Decode(product.image.split(',').last),
              height: 220,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            product.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF5E5548),
            ),
          ),

          const SizedBox(height: 20),

          _detail("Metal", product.metalType),
          _detail("Purity", product.carats),
          _detail("Weight", "${product.weight} g"),

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