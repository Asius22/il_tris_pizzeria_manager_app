import 'package:flutter/material.dart';
import 'package:il_tris_manager/components/menu/detail_product_form.dart';
import 'package:pizzeria_model_package/model/product.dart';
import 'package:sizer/sizer.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key, required this.product, this.onTap});
  final Product product;
  final Function()? onTap;

  final GlobalKey<DetailProductFormState> _formKey =
      GlobalKey<DetailProductFormState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colorScheme.secondaryContainer,
        title: Text(
          product.nome,
          style: TextStyle(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 100.h,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: DetailProductForm(key: _formKey, product: product),
          ),
        ),
      ),
    );
  }
}
