import 'package:apate/bloc/cart_item_bloc.dart';
import 'package:apate/data/models/cart_item.dart';
import 'package:apate/data/models/product.dart';
import 'package:apate/data/repositories/cart_repository.dart';
import 'package:apate/utils/number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  final String merchantId;
  final Product product;
  final int qty;
  final Function onCartItemUpdated;

  const ProductCard({
    required this.merchantId,
    required this.product,
    required this.qty,
    required this.onCartItemUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            product.image ?? "assets/images/no_image.png",
            height: 64,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      Number.formatCurrency(product.price),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  product.description ?? "",
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: BlocProvider(
                    create: (context) => CartItemBloc(CartRepository())
                      ..add(CartItemFetchEvent(product.uuid)),
                    child: ActionButtons(
                      merchantId: merchantId,
                      product: product,
                      onCartItemUpdated: onCartItemUpdated,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final String merchantId;
  final Product product;
  final Function onCartItemUpdated;

  ActionButtons({
    required this.merchantId,
    required this.product,
    required this.onCartItemUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartItemBloc, CartItemState>(
      listenWhen: (previous, current) {
        return current is CartItemFetchError;
      },
      buildWhen: (previous, current) {
        return current is CartItemFetchSuccess;
      },
      listener: (context, state) {
        if (state is CartItemFetchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CartItemFetchSuccess) {
          if (state.item != null && state.item!.productQty > 0) {
            return RemoveAndAddButtons(
              cartItem: state.item!,
              cartItemBloc: context.watch<CartItemBloc>(),
              onCartItemUpdated: onCartItemUpdated,
            );
          } else {
            final CartItem cartItem = CartItem(
              merchantId: merchantId,
              productId: product.uuid,
              productName: product.name,
              productPrice: product.price,
              productQty: 0,
            );
            return AddButton(
              cartItem: cartItem,
              cartItemBloc: context.watch<CartItemBloc>(),
              onCartItemUpdated: onCartItemUpdated,
            );
          }
        }
        return Container();
      },
    );
  }
}

class AddButton extends StatelessWidget {
  final CartItem cartItem;
  final CartItemBloc cartItemBloc;
  final Function onCartItemUpdated;

  AddButton({
    required this.cartItem,
    required this.cartItemBloc,
    required this.onCartItemUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        cartItem.productQty++;
        onCartItemUpdated(cartItem, cartItemBloc);
      },
      child: Text("TAMBAH"),
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class RemoveAndAddButtons extends StatelessWidget {
  final CartItem cartItem;
  final CartItemBloc cartItemBloc;
  final Function onCartItemUpdated;

  RemoveAndAddButtons({
    required this.cartItem,
    required this.cartItemBloc,
    required this.onCartItemUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          width: 36.0,
          child: TextButton(
            child: Icon(Icons.remove),
            onPressed: () {
              cartItem.productQty--;
              onCartItemUpdated(cartItem, cartItemBloc);
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.zero,
              shape: CircleBorder(),
            ),
          ),
        ),
        Container(
          width: 44.0,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cartItem.productQty.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 36.0,
          child: TextButton(
            child: Icon(Icons.add),
            onPressed: () {
              cartItem.productQty++;
              onCartItemUpdated(cartItem, cartItemBloc);
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.zero,
              shape: CircleBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
