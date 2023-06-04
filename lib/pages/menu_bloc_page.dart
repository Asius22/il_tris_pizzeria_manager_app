import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/bloc/product_bloc.dart';
import 'package:il_tris_manager/components/page_contaneirs/menu_page.dart';
import 'package:il_tris_manager/pages/waiting_page.dart';

class MenuBlocPage extends StatelessWidget {
  const MenuBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProductBloc, ProductBlocState>(
        buildWhen: (previous, current) => current is! UpdateSuccessState,
        builder: (context, state) {
          if (state is ProductBlocInitial) {
            BlocProvider.of<ProductBloc>(context).add(FetchProductEvent());
            return const WaitingPage();
          } else if (state is ProductBlocFetching) {
            return const WaitingPage();
          } else {
            return MenuPage(
              productList: state.products,
            );
          }
        },
      ),
    );
  }
}
