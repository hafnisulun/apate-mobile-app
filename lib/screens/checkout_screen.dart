import 'package:apate/components/cart_item_card.dart';
import 'package:apate/data/models/cart_item.dart';
import 'package:apate/data/models/merchant.dart';
import 'package:apate/db_helper.dart';
import 'package:apate/utils/number.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatefulWidget {
  final Merchant merchant;

  CheckoutScreen({
    required this.merchant,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final DbHelper _dbHelper = new DbHelper();
  List<CartItem> _cart = new List.empty(growable: true);

  _CheckoutScreenState() {
    _updateCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesanan"),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: _clearCart,
                child: Icon(Icons.delete),
              )),
        ],
      ),
      body: CheckoutBody(
        merchant: widget.merchant,
        cart: _cart,
      ),
    );
  }

  void _clearCart() async {
    int result = await _dbHelper.clear();
    if (result > 0) {
      _updateCart();
    }
  }

  void _updateCart() {
    final Future<Database> dbFuture = _dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<CartItem>> cartFuture = _dbHelper.getCart();
      cartFuture.then((cart) {
        setState(() {
          _cart = cart;
        });
      });
    });
  }
}

class CheckoutBody extends StatefulWidget {
  final Merchant merchant;
  final List<CartItem> cart;

  CheckoutBody({
    required this.merchant,
    required this.cart,
  });

  @override
  _CheckoutBodyState createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CheckoutCart(
            cart: widget.cart,
          ),
        ),
        CheckoutTotal(
          cart: widget.cart,
        ),
        CheckoutOrderButtonContainer(
          merchant: widget.merchant,
          cart: widget.cart,
        ),
      ],
    );
  }
}

class CheckoutCart extends StatefulWidget {
  final List<CartItem> cart;

  CheckoutCart({
    required this.cart,
  });

  @override
  _CheckoutCartState createState() => _CheckoutCartState();
}

class _CheckoutCartState extends State<CheckoutCart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.cart.length,
        itemBuilder: (context, index) {
          return CartItemCard(cartItem: widget.cart.elementAt(index));
        },
      ),
    );
  }
}

class CheckoutTotal extends StatefulWidget {
  final List<CartItem> cart;

  CheckoutTotal({
    required this.cart,
  });

  @override
  _CheckoutTotalState createState() => _CheckoutTotalState();
}

class _CheckoutTotalState extends State<CheckoutTotal> {
  @override
  Widget build(BuildContext context) {
    int totalAmount = 0;
    for (CartItem item in widget.cart) {
      totalAmount += item.productPrice * item.productQty;
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "Total",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          Text(
            Number.formatCurrency(totalAmount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutOrderButtonContainer extends StatelessWidget {
  final Merchant merchant;
  final List<CartItem> cart;

  CheckoutOrderButtonContainer({
    required this.merchant,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    if (merchant.phone?.isEmpty ?? true) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                CheckoutOrderButton(
                  merchant: merchant,
                  cart: cart,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CheckoutOrderButton extends StatelessWidget {
  final Merchant merchant;
  final List<CartItem> cart;

  CheckoutOrderButton({
    required this.merchant,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: TextButton(
        onPressed: () => _sendOrderMessage(context),
        child: Text("PESAN"),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(12.0),
          textStyle: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  void _showAlertDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _launchWhatsApp(BuildContext context,
      String phone,
      String message,) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    Uri uri = Uri(
      scheme: "whatsapp",
      host: "send",
      query: encodeQueryParameters(<String, String>{
        "phone": phone,
        "text": message,
      }),
    );
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      _showAlertDialog(
        context,
        "Tidak dapat membuka Whatsapp",
        "Silakan pasang Whatsapp untuk mengirimkan pesanan",
      );
    }
  }

  void _sendOrderMessage(BuildContext context) {
    if (cart.length == 0) {
      _showAlertDialog(
        context,
        "Keranjang belanja kosong",
        "Silakan pilih produk terlebih dahulu",
      );
      return;
    }
    String message = "Halo, saya mau pesan:\n";
    for (CartItem item in cart) {
      message += "${item.productQty} × ${item.productName}\n";
    }
    message += "Terima kasih.";
    _launchWhatsApp(context, merchant.phone!, message);
  }
}
