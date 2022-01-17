import 'package:apate/bloc/addresses/addresses_bloc.dart';
import 'package:apate/data/models/address.dart';
import 'package:apate/data/repositories/addresses_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                onTap: () => _addAddress(context),
                child: Icon(Icons.add),
              )),
        ],
      ),
      body: AddressesBody(),
    );
  }

  void _addAddress(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tambah alamat'),
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        this.addresses.length,
        (index) {
          return AddressView(address: addresses[index]);
        },
      ),
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
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 4,
            child: IconButton(
              onPressed: () => {},
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
