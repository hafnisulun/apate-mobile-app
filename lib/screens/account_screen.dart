import 'package:apate/bloc/account/account_bloc.dart';
import 'package:apate/bloc/addresses/addresses_bloc.dart';
import 'package:apate/data/models/address.dart';
import 'package:apate/data/repositories/account_repository.dart';
import 'package:apate/data/repositories/addresses_repository.dart';
import 'package:apate/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun'),
        automaticallyImplyLeading: true,
      ),
      body: AccountBody(),
    );
  }
}

class AccountBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AccountBloc(AccountRepository())
                      ..add(AccountFetchEvent()),
                  ),
                  BlocProvider(
                    create: (context) => AddressesBloc(AddressesRepository())
                      ..add(AddressesFetchEvent()),
                  ),
                ],
                child: AccountDetailsView(),
              ),
            ),
          ),
          LogOutButton(),
        ],
      ),
    );
  }
}

class AccountDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is AccountFetchSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccountFieldView(
                    field: 'Nama',
                    value: state.account.name,
                  ),
                  AccountFieldView(
                    field: 'Email',
                    value: state.account.email,
                  ),
                  AccountFieldView(
                    field: 'No. telp.',
                    value: state.account.phone,
                  ),
                  AccountFieldView(
                    field: 'Jenis kelamin',
                    value: state.account.gender,
                  ),
                ],
              );
            } else {
              return Text("Loading...");
            }
          },
        ),
        BlocBuilder<AddressesBloc, AddressesState>(
          builder: (context, state) {
            if (state is AddressesFetchSuccess) {
              return AddressesView(
                addresses: state.addresses,
              );
            } else if (state is AddressesFetchError) {
              return Text("Error");
            } else {
              return Text("Loading...");
            }
          },
        ),
      ],
    );
  }
}

class AccountFieldView extends StatelessWidget {
  final String field;
  final String value;

  AccountFieldView({
    required this.field,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            field,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              height: 1.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
        ),
      ],
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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Alamat',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              height: 1.5,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            this.addresses.length,
            (index) {
              return AddressView(address: addresses[index]);
            },
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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              this.address.label,
              style: TextStyle(
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              this.address.details,
              style: TextStyle(
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: OutlinedButton(
          onPressed: () => _showAlertDialog(
              context, 'Keluar dari Apate?', 'Apakah Anda yakin ingin keluar?'),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'KELUAR',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.red),
            primary: Colors.red,
          ),
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
              child: Text("BATAL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("KELUAR"),
              onPressed: () => Auth.logout(context),
            ),
          ],
        );
      },
    );
  }
}
