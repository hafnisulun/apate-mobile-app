import 'package:apate/bloc/account/account_bloc.dart';
import 'package:apate/data/repositories/account_repository.dart';
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
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocProvider(
        create: (context) =>
            AccountBloc(AccountRepository())..add(AccountFetchEvent()),
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is AccountFetchSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Item(
                            field: 'Nama',
                            value: state.account.name,
                          ),
                          Item(
                            field: 'Email',
                            value: state.account.email,
                          ),
                          Item(
                            field: 'No. telp.',
                            value: state.account.phone,
                          ),
                          Item(
                            field: 'Jenis kelamin',
                            value: state.account.gender,
                          ),
                          Addresses(),
                        ],
                      ),
                    ),
                  ),
                  LogOutButton(),
                ],
              );
            } else if (state is AccountFetchError) {
              return Center(
                child: Text("Error"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String field;
  final String value;

  Item({
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

class Addresses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'Label STR4',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'Cluster STR',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'Details Unit H1023A',
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

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: OutlinedButton(
          onPressed: () => Auth.logout(context),
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
}
