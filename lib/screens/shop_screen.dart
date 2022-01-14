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
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                DestinationView(),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: MerchantGridView(),
        ),
      ],
    );
  }
}

class DestinationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'Antar ke: ',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Text(
          'STR 1 | Unit O1520C',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}

class MerchantGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MerchantsBloc, MerchantsState>(
      builder: (context, state) {
        if (state is MerchantsFetchSuccess) {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.77,
            ),
            delegate: SliverChildListDelegate(
              [
                ...List.generate(
                    state.merchants.data.length,
                    (index) =>
                        MerchantCard(merchant: state.merchants.data[index])),
              ],
            ),
          );
        } else if (state is MerchantsFetchError) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Koneksi internet terputus"),
                        SizedBox(height: 8.0),
                        TextButton(
                          onPressed: () => context
                              .read<MerchantsBloc>()
                              .add(LoadMerchantsEvent()),
                          child: Text("COBA LAGI"),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
