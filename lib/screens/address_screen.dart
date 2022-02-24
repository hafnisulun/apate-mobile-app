import 'package:apate/bloc/address/address_bloc.dart';
import 'package:apate/bloc/address_form/address_form_bloc.dart';
import 'package:apate/bloc/cluster/cluster_bloc.dart';
import 'package:apate/components/apt_flat_button.dart';
import 'package:apate/data/models/address.dart';
import 'package:apate/data/models/cluster.dart';
import 'package:apate/data/models/residence.dart';
import 'package:apate/data/repositories/cluster_repository.dart';
import 'package:apate/data/repositories/residences_repository.dart';
import 'package:apate/data/responses/residences_response.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return AddressFormBloc();
          },
        ),
        BlocProvider(
          create: (context) {
            return AddressBloc(ClusterRepository());
          },
        ),
        BlocProvider(
          create: (context) {
            ClusterBloc clusterBloc = ClusterBloc(ClusterRepository());
            if (address?.residenceUuid != null &&
                address?.clusterUuid != null) {
              clusterBloc.add(ClusterFetchEvent(
                residenceUuid: address?.residenceUuid,
                clusterUuid: address?.clusterUuid,
              ));
            }
            return clusterBloc;
          },
        ),
      ],
      child: BlocListener<AddressFormBloc, AddressFormState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).pop(state.status);
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: Stack(
          children: <Widget>[
            Column(
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
                                AddressLabelInput(),
                                AddressResidenceField(),
                                AddressClusterField(),
                                AddressDetailInput(),
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
            OpacityView(),
            LoadingView(),
          ],
        ),
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

class AddressLabelInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Label alamat',
        ),
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          context
              .read<AddressFormBloc>()
              .add(AddressFormLabelChangeEvent(label: value));
        },
      ),
    );
  }
}

class AddressResidenceField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownSearch<Residence>(
        mode: Mode.MENU,
        showSelectedItems: true,
        selectedItem: Residence(uuid: '', name: 'Pilih perumahan'),
        compareFn: (item, selectedItem) => item?.uuid == selectedItem?.uuid,
        dropdownSearchDecoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Perumahan',
          contentPadding: EdgeInsets.fromLTRB(12, 11, 0, 0),
        ),
        dropdownBuilder: _customDropdown,
        popupItemBuilder: _customPopupItem,
        onFind: (String? filter) async {
          ResidencesResponse? res =
              await ResidencesRepository().getResidences();
          if (res != null) {
            return res.data;
          }
          return List.empty();
        },
        onChanged: (Residence? residence) {
          if (residence != null) {
            context.read<AddressFormBloc>().add(
                AddressFormResidenceChangeEvent(residenceUuid: residence.uuid));
            context
                .read<AddressBloc>()
                .add(AddressClustersFetchEvent(residence: residence));
          }
        },
      ),
    );
  }

  Widget _customDropdown(BuildContext context, Residence? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item.name),
      ),
    );
  }

  Widget _customPopupItem(
      BuildContext context, Residence? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''),
      ),
    );
  }
}

class AddressClusterField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          return DropdownSearch<Cluster>(
            mode: Mode.MENU,
            items: state is AddressClustersFetchSuccess ? state.clusters : [],
            showSelectedItems: true,
            selectedItem: Cluster(uuid: '', name: 'Pilih cluster'),
            compareFn: (item, selectedItem) => item?.uuid == selectedItem?.uuid,
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Cluster',
              contentPadding: EdgeInsets.fromLTRB(12, 11, 0, 0),
            ),
            dropdownBuilder: _customDropdown,
            popupItemBuilder: _customPopupItem,
            onChanged: (Cluster? cluster) {
              if (cluster != null) {
                context.read<AddressFormBloc>().add(
                    AddressFormClusterChangeEvent(clusterUuid: cluster.uuid));
              }
            },
          );
        },
      ),
    );
  }

  Widget _customDropdown(BuildContext context, Cluster? item) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(item.name),
      ),
    );
  }

  Widget _customPopupItem(
      BuildContext context, Cluster? item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''),
      ),
    );
  }
}

class AddressDetailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Detail alamat',
        ),
        onChanged: (value) {
          context
              .read<AddressFormBloc>()
              .add(AddressFormDetailChangeEvent(detail: value));
        },
      ),
    );
  }
}

class AddressSubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressFormBloc, AddressFormState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: AptFlatButton(
                onPressed: state.status.isValidated
                    ? () => context
                        .read<AddressFormBloc>()
                        .add(AddressFormSubmitEvent())
                    : null,
                text: 'SIMPAN'),
          );
        });
  }
}

class OpacityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressFormBloc, AddressFormState>(
        builder: (context, state) {
      if (state.status.isSubmissionInProgress) {
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
    });
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressFormBloc, AddressFormState>(
        builder: (context, state) {
      if (state.status.isSubmissionInProgress) {
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
    });
  }
}
