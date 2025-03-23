import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/lingue/new_lingua_form.dart';
import 'package:il_tris_manager/pages/waiting_page.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';

class LinguaPage extends StatelessWidget {
  const LinguaPage({super.key});
  static const String routeName = 'lingue';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Aggiungi una nuova lingua al sito'),
      ),
      body: BlocBuilder<ProductBloc, ProductBlocState>(
        builder: (context, state) {
          if (state is ProductBlocInitial) {
            BlocProvider.of<ProductBloc>(context).add(FetchProductEvent());
            return const WaitingPage();
          } else if (state is ProductBlocFetching) {
            return const WaitingPage();
          }
          return const NewLinguaForm();
        },
      ),
    );
  }
}
