import 'package:apate/bloc/account/account_bloc.dart';
import 'package:apate/components/apt_outlined_button.dart';
import 'package:apate/data/repositories/account_repository.dart';
import 'package:apate/screens/addresses_screen.dart';
import 'package:apate/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocProvider(
                  create: (context) => AccountBloc(AccountRepository())
                    ..add(AccountFetchEvent()),
                  child: AccountDetailsView(),
                ),
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
      children: <Widget>[
        BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is AccountFetchSuccess) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
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
                      value: state.account.phone ?? 'N/A',
                    ),
                    AccountFieldView(
                      field: 'Jenis kelamin',
                      value: state.account.gender ?? 'N/A',
                    ),
                  ],
                ),
              );
            } else if (state is AccountFetchError) {
              return Text('Error');
            } else {
              return Text('Loading...');
            }
          },
        ),
        AddressesButton(),
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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            field,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class AddressesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => pushNewScreen(
          context,
          screen: AddressesScreen(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Daftar Alamat',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Text(
                'Atur alamat pengiriman belanjaan',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: AptOutlinedButton(
        onPressed: () => _showLogoutDialog(context),
        text: 'KELUAR',
        color: Colors.red,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keluar dari Apate?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin keluar?'),
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
              onPressed: () => Auth.logOut(context),
            ),
          ],
        );
      },
    );
  }
}
