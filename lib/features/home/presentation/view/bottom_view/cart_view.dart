import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/get_all_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/create_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/delete_cart_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/cart/update_cart_item_usecase.dart';
// import 'package:sparexpress/features/home/domin/usecase/cart_usecases/get_all_cart_usecase.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_event.dart';
import 'package:sparexpress/features/home/presentation/widgets/cart/cart_items_list.dart';
import 'package:sparexpress/features/home/presentation/widgets/cart/checkout_card.dart';
import 'package:sparexpress/features/home/presentation/widgets/dashboard_header/modern_app_bar.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final getAllCartUsecase = GetIt.instance<GetAllCartUsecase>();
    final createCartUsecase = GetIt.instance<CreateCartUsecase>();
    final deleteCartUsecase = GetIt.instance<DeleteCartUsecase>();
    final updateCartItemUsecase = GetIt.instance<UpdateCartItemUsecase>();

    return BlocProvider(
      create: (_) => CartBloc(
        getAllCartUsecase: getAllCartUsecase,
        createCartUsecase: createCartUsecase,
        deleteCartUsecase: deleteCartUsecase,
        updateCartItemUsecase: updateCartItemUsecase,
      )..add(LoadCart()),
      child: Scaffold(
        appBar: const ModernAppBar(
          title: 'Your Cart',
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            ),
          ],
        ),
        body: Column(
          children: const [
            Expanded(child: CartListView()),
            CheckoutSection(),
          ],
        ),
      ),
    );
  }
}
