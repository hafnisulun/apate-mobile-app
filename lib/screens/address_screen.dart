import 'package:apate/bloc/cluster/cluster_bloc.dart';
import 'package:apate/components/apt_flat_button.dart';
import 'package:apate/data/models/address.dart';
import 'package:apate/data/repositories/cluster_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressScreen extends StatelessWidget {
  final Address? address;

  AddressScreen({
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alamat'),
        automaticallyImplyLeading: true,
      ),
      body: AddressBody(address: address),
    );
  }
}

class AddressBody extends StatelessWidget {
  final Address? address;

  AddressBody({
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        ClusterBloc clusterBloc = ClusterBloc(ClusterRepository());
        if (address?.residenceUuid != null && address?.clusterUuid != null) {
          clusterBloc.add(ClusterFetchEvent(
            residenceUuid: address?.residenceUuid,
            clusterUuid: address?.clusterUuid,
          ));
        }
        return clusterBloc;
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<ClusterBloc, ClusterState>(
                  builder: (context, state) {
                    if (state is ClusterFetchSuccess) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AddressField(
                            labelText: 'Label alamat',
                            initialValue: address?.label,
                          ),
                          AddressField(
                            labelText: 'Perumahan',
                            initialValue: address?.cluster?.name,
                            enabled: false,
                          ),
                          AddressField(
                            labelText: 'Cluster',
                            initialValue: state.cluster.name,
                            enabled: false,
                          ),
                          AddressField(
                            labelText: 'Detail alamat',
                            initialValue: address?.details,
                          ),
                        ],
                      );
                    } else if (state is ClusterFetchError) {
                      return Text('Error');
                    } else if (state is ClusterFetchIdle) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AddressField(labelText: 'Label alamat'),
                          AddressField(labelText: 'Perumahan'),
                          AddressField(labelText: 'Cluster'),
                          AddressField(labelText: 'Detail alamat'),
                        ],
                      );
                    } else {
                      return Text('Loading...');
                    }
                  },
                ),
              ),
            ),
          ),
          AddressSubmitButton(),
        ],
      ),
    );
  }
}

class AddressField extends StatelessWidget {
  final String labelText;
  final String? initialValue;
  final bool? enabled;

  AddressField({
    required this.labelText,
    this.initialValue,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        initialValue: initialValue,
        enabled: enabled,
      ),
    );
  }
}

class AddressSubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: AptFlatButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Simpan alamat'),
                ),
              ),
          text: 'SIMPAN'),
    );
  }
}
