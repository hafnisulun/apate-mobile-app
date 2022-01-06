import 'package:apate/bloc/cart_item_bloc.dart';
import 'package:apate/bloc/products_bloc.dart';
import 'package:apate/components/product_card.dart';
import 'package:apate/data/models/cart_item.dart';
import 'package:apate/data/models/merchant.dart';
import 'package:apate/data/models/product.dart';
import 'package:apate/data/models/products.dart';
import 'package:apate/data/repositories/products_repository.dart';
import 'package:apate/db_helper.dart';
import 'package:apate/screens/checkout_screen.dart';
import 'package:apate/utils/auth.dart';
import 'package:apate/utils/number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class MerchantScreen extends StatelessWidget {
  final Merchant merchant;

  MerchantScreen({
    required this.merchant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MerchantBody(
        merchant: merchant,
      ),
    );
  }
}

class MerchantBody extends StatefulWidget {
  final Merchant merchant;

  MerchantBody({
    required this.merchant,
  });

  @override
  _MerchantBodyState createState() => _MerchantBodyState();
}

class _MerchantBodyState extends State<MerchantBody> {
  final MerchantCartNotifier _notifier = MerchantCartNotifier();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocProvider(
          create: (context) => ProductsBloc(ProductsRepository())
            ..add(ProductsFetchEvent(widget.merchant.uuid)),
          child: MerchantScrollView(
            merchant: widget.merchant,
            updateCartCallback: _notifier.updateCart,
          ),
        ),
        AnimatedBuilder(
          animation: _notifier,
          builder: (_, __) => MerchantCart(
            totalItems: _notifier.totalItems,
            totalAmount: _notifier.totalAmount,
            updateCartCallback: _notifier.updateCart,
          ),
        ),
      ],
    );
  }
}

class MerchantScrollView extends StatefulWidget {
  final Merchant merchant;
  final Function updateCartCallback;

  MerchantScrollView({
    required this.merchant,
    required this.updateCartCallback,
  });

  @override
  _MerchantScrollViewState createState() => _MerchantScrollViewState();
}

class _MerchantScrollViewState extends State<MerchantScrollView> {
  final DbHelper _dbHelper = DbHelper();
  List<CartItem> _cart = new List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    _loadCart();

    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductsFetchUnauthorized) {
          Auth.logout(context);
        } else if (state is ProductsFetchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProductsFetchSuccess) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 192,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.merchant.name),
                  background: FadeInImage.assetNetwork(
                    placeholder: "assets/images/no_image.png",
                    image: widget.merchant.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(_buildList(state.products)),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _loadCart() {
    Future<List<CartItem>> cartFuture = _dbHelper.getCart();
    cartFuture.then((cart) async {
      _cart = cart;
    });
  }

  List<Widget> _buildList(Products products) {
    List<Widget> widgets = List.empty(growable: true);
    int qty = 0;

    widgets.add(MerchantInfo(merchant: widget.merchant));
    widgets.add(Divider(thickness: 8.0));

    for (int i = 0; i < products.data.length; i++) {
      Product product = products.data[i];
      int j = 0;
      while (j < _cart.length) {
        if (_cart[j].productId == product.uuid) {
          break;
        }
        j++;
      }

      if (j == _cart.length) {
        qty = 0;
      } else {
        qty = _cart[j].productQty;
      }

      widgets.add(
        ProductCard(
          merchantId: widget.merchant.uuid,
          product: product,
          qty: qty,
          onCartItemUpdated: _updateCartItem,
        ),
      );
    }

    widgets.add(SizedBox(height: 80.0));

    return widgets;
  }

  void _updateCartItem(CartItem item, CartItemBloc cartItemCubit) async {
    const int MAX_ITEM_QTY = 999;
    Future<List<CartItem>> cartFuture = _dbHelper.getCart();
    cartFuture.then((cart) async {
      int result = 0;
      int i = 0;

      if (cart.length > 0 && cart[i].merchantId != item.merchantId) {
        // Different merchant, clear cart
        await _dbHelper.clear();
      }

      while (i < cart.length) {
        if (cart[i].productId == item.productId) {
          if (item.productQty > 0 && item.productQty < MAX_ITEM_QTY) {
            cart[i].productQty = item.productQty;
            result = await _dbHelper.update(cart[i]);
          } else {
            result = await _dbHelper.delete(cart[i]);
          }
          break;
        }
        i++;
      }
      if (i == cart.length) {
        result = await _dbHelper.insert(item);
      }
      if (result > 0) {
        cartItemCubit.add(CartItemFetchEvent(item.productId));
        widget.updateCartCallback();
      }
    });
  }
}

class MerchantInfo extends StatelessWidget {
  final Merchant merchant;

  MerchantInfo({required this.merchant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined),
              SizedBox(width: 8.0),
              Text('${merchant.lat}, ${merchant.lon}'),
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.watch_later_outlined),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          child: Text(
                            "Sunday",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("09:00 - 17:00"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          child: Text(
                            "Monday",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("09:00 - 17:00"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          child: Text(
                            "Wednesday",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("09:00 - 17:00"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          child: Text(
                            "Thursday",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("09:00 - 17:00"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          child: Text(
                            "Wednesday",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("09:00 - 17:00"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          child: Text(
                            "Friday",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("Closed"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          child: Text(
                            "Saturday",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("09:00 - 17:00"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MerchantCart extends StatefulWidget {
  final int totalItems;
  final int totalAmount;
  final Function updateCartCallback;

  MerchantCart({
    required this.totalItems,
    required this.totalAmount,
    required this.updateCartCallback,
  });

  @override
  _MerchantCartState createState() => _MerchantCartState();
}

class _MerchantCartState extends State<MerchantCart> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: widget.totalItems > 0.0 ? 0.0 : -70.0,
      right: 0,
      width: MediaQuery.of(context).size.width,
      child: AnimatedOpacity(
        opacity: widget.totalItems > 0.0 ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckoutScreen()),
              ).then((value) => widget.updateCartCallback());
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    "${Number.formatNumber(widget.totalItems)} item",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      padding: const EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: Text(
                        "${Number.formatCurrency(widget.totalAmount)}",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.shopping_basket,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}

class MerchantCartNotifier extends ChangeNotifier {
  final DbHelper _dbHelper = DbHelper();
  int totalItems = 0;
  int totalAmount = 0;

  void updateCart() {
    final Future<Database> dbFuture = _dbHelper.initDb();
    dbFuture.then((database) {
      totalItems = 0;
      totalAmount = 0;
      Future<List<CartItem>> cartFuture = _dbHelper.getCart();
      cartFuture.then((cart) {
        for (CartItem item in cart) {
          totalItems += item.productQty;
          totalAmount += (item.productPrice * item.productQty);
        }
        notifyListeners();
      });
    });
  }
}
