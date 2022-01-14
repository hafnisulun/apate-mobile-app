import 'package:apate/bloc/merchants_bloc.dart';
import 'package:apate/components/merchant_card.dart';
import 'package:apate/data/repositories/merchants_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Belanja"),
        automaticallyImplyLeading: true,
      ),
      body: BlocProvider(
        create: (context) =>
            MerchantsBloc(MerchantsRepository())..add(LoadMerchantsEvent()),
        child: ShopView(),
      ),
    );
  }
}

class ShopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DestinationView(),
          MerchantGridView(),
        ],
      ),
    );
  }
}

class DestinationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            'Antar ke: ',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'STR 1 | Unit O1520C',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}

class MerchantGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MerchantsBloc, MerchantsState>(
      builder: (context, state) {
        if (state is MerchantsFetchSuccess) {
          return Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.77,
              children: [
                ...List.generate(
                    state.merchants.data.length,
                    (index) =>
                        MerchantCard(merchant: state.merchants.data[index]))
              ],
            ),
          );
        } else if (state is MerchantsFetchError) {
          return Center(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Koneksi internet terputus"),
                  SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () =>
                        context.read<MerchantsBloc>().add(LoadMerchantsEvent()),
                    child: Text("COBA LAGI"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
