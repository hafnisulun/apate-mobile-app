import 'dart:async';

import 'package:apate/bloc/addresses/addresses_bloc.dart';
import 'package:apate/components/session_expired_dialog.dart';
import 'package:apate/data/models/address.dart';
import 'package:apate/data/repositories/address_repository.dart';
import 'package:apate/screens/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AddressesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddressesBloc(AddressRepository())..add(AddressesFetchEvent()),
      child: BlocConsumer<AddressesBloc, AddressesState>(
        listener: (context, state) {
          if (state is AddressesDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Alamat "${state.address.label}" telah dihapus'),
              ),
            );
            context.read<AddressesBloc>().add(AddressesFetchEvent());
          } else if (state is AddressesUnauthorized) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => SessionExpiredDialog(),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Daftar Alamat'),
              automaticallyImplyLeading: true,
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        pushNewScreen(context, screen: AddressScreen())
                            .then((value) => onGoBack(context, value));
                      },
                      child: Icon(Icons.add),
                    )),
              ],
            ),
            body: AddressesBody(),
          );
        },
      ),
    );
  }

  FutureOr onGoBack(BuildContext context, dynamic value) {
    print('[AddressesScreen] [onGoBack] value: $value');
    if (value is FormzStatus && value.isSubmissionSuccess) {
      context.read<AddressesBloc>().add(AddressesFetchEvent());
    }
  }
}

class AddressesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlocBuilder<AddressesBloc, AddressesState>(
          builder: (context, state) {
            if (state is AddressesFetchSuccess) {
              return AddressesView(addresses: state.addresses);
            } else if (state is AddressesFetchError) {
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                alignment: Alignment.topCenter,
                child: Text('Error'),
              );
            } else {
              return Container();
            }
          },
        ),
        OpacityView(),
        LoadingView(),
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                  AddressView(address: addresses[index]),
              childCount: addresses.length,
            ),
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
            right: 40,
            top: 0,
            child: IconButton(
              onPressed: () => pushNewScreen(context,
                      screen: AddressScreen(address: address))
                  .then((value) => onGoBack(context, value)),
              icon: Icon(Icons.edit),
            ),
          ),
          Positioned(
            right: 4,
            top: 0,
            child: IconButton(
              onPressed: () => context
                  .read<AddressesBloc>()
                  .add(AddressesDeleteEvent(address: address)),
              icon: Icon(Icons.delete),
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

  FutureOr onGoBack(BuildContext context, dynamic value) {
    print('[AddressView] [onGoBack] value: $value');
    if (value is FormzStatus && value.isSubmissionSuccess) {
      context.read<AddressesBloc>().add(AddressesFetchEvent());
    }
  }
}

class OpacityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressesBloc, AddressesState>(
      builder: (context, state) {
        if (state is AddressesLoading) {
          return Opacity(
            opacity: 0.7,
            child: const ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressesBloc, AddressesState>(
      builder: (context, state) {
        if (state is AddressesLoading) {
          return Center(
            child: AlertDialog(
              content: new Row(
                children: [
                  CircularProgressIndicator(),
                  Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text("Loading...")),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
