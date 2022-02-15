import 'package:apate/bloc/addresses/addresses_bloc.dart';
import 'package:apate/bloc/merchants_bloc.dart';
import 'package:apate/components/merchant_card.dart';
import 'package:apate/components/session_expired_dialog.dart';
import 'package:apate/data/repositories/addresses_repository.dart';
import 'package:apate/data/repositories/merchants_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Belanja"),
        automaticallyImplyLeading: true,
      ),
      body: ShopBody(),
    );
  }
}

class ShopBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddressesBloc(AddressesRepository())
              ..add(AddressesFetchEvent()),
          ),
          BlocProvider(
            create: (context) =>
                MerchantsBloc(MerchantsRepository())..add(LoadMerchantsEvent()),
          ),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Antar ke: ',
          style: Theme.of(context).textTheme.caption,
        ),
        BlocConsumer<AddressesBloc, AddressesState>(
          listener: (context, state) {
            if (state is AddressesFetchUnauthorized) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => SessionExpiredDialog(),
              );
            }
          },
          builder: (context, state) {
            if (state is AddressesFetchSuccess) {
              return Text(
                state.addresses[0].label + ', ' + state.addresses[0].details,
                style: Theme.of(context).textTheme.bodyText1,
              );
            } else if (state is AddressesFetchError) {
              return Text('Error');
            } else {
              return Text('Loading...');
            }
          },
        ),
      ],
    );
  }
}

class MerchantGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MerchantsBloc, MerchantsState>(
      listener: (context, state) {
        if (state is MerchantsFetchUnauthorized) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => SessionExpiredDialog(),
          );
        }
      },
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
