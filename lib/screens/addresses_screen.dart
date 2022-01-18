import 'package:apate/bloc/addresses/addresses_bloc.dart';
import 'package:apate/data/models/address.dart';
import 'package:apate/data/repositories/addresses_repository.dart';
import 'package:apate/screens/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AddressesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Alamat'),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => pushNewScreen(context, screen: AddressScreen()),
                child: Icon(Icons.add),
              )),
        ],
      ),
      body: AddressesBody(),
    );
  }
}

class AddressesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: BlocProvider(
          create: (context) =>
              AddressesBloc(AddressesRepository())..add(AddressesFetchEvent()),
          child: BlocBuilder<AddressesBloc, AddressesState>(
            builder: (context, state) {
              if (state is AddressesFetchSuccess) {
                return AddressesView(addresses: state.addresses);
              } else if (state is AddressesFetchError) {
                return Text('Error');
              } else {
                return Text('Loading...');
              }
            },
          ),
        ),
      ),
    );
  }
}

class AddressesView extends StatelessWidget {
  final List<Address> addresses;

  AddressesView({
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
                AddressView(address: addresses[index]),
            childCount: addresses.length,
          ),
        ),
      ],
    );
  }
}

class AddressView extends StatelessWidget {
  final Address address;

  AddressView({
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 4,
            top: 0,
            child: IconButton(
              onPressed: () => pushNewScreen(context,
                  screen: AddressScreen(address: address)),
              icon: Icon(Icons.edit),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.address.label,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  this.address.details,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
