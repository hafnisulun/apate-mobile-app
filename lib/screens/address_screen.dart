import 'package:apate/bloc/address/address_bloc.dart';
import 'package:apate/bloc/address_form/address_form_bloc.dart';
import 'package:apate/components/apt_flat_button.dart';
import 'package:apate/components/dialog_background.dart';
import 'package:apate/components/loading_dialog.dart';
import 'package:apate/data/models/address.dart';
import 'package:apate/data/models/cluster.dart';
import 'package:apate/data/models/residence.dart';
import 'package:apate/data/repositories/cluster_repository.dart';
import 'package:apate/data/repositories/residence_repository.dart';
import 'package:apate/data/responses/clusters_response.dart';
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
            final addressBloc = AddressBloc(ClusterRepository());
            if (address != null) {
              addressBloc.add(
                AddressResidenceFetchEvent(
                  residenceUuid: address!.residenceUuid,
                ),
              );
            }
            return addressBloc;
          },
        ),
      ],
      child: BlocListener<AddressFormBloc, AddressFormState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Alamat "${state.labelInput.value}" telah disimpan'),
              ),
            );
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AddressLabelInput(initialValue: address?.label),
                          BlocBuilder<AddressBloc, AddressState>(
                            builder: (context, state) {
                              if (state is AddressResidenceFetchSuccess) {
                                context
                                    .read<AddressBloc>()
                                    .add(AddressClusterFetchEvent(
                                      residence: state.residence,
                                      clusterUuid: address!.clusterUuid,
                                    ));
                                return AddressResidenceField(
                                  initialValue: state.residence,
                                );
                              } else if (state
                                  is AddressResidenceChangeSuccess) {
                                return AddressResidenceField(
                                  initialValue: state.residence,
                                );
                              } else if (state is AddressClusterFetch) {
                                return AddressResidenceField(
                                  initialValue: state.residence,
                                );
                              } else {
                                return AddressResidenceField();
                              }
                            },
                          ),
                          BlocBuilder<AddressBloc, AddressState>(
                            builder: (context, state) {
                              if (state is AddressClusterFetchSuccess) {
                                return AddressClusterField(
                                  residenceUuid: address?.residenceUuid,
                                  initialValue: state.cluster,
                                );
                              } else if (state
                                  is AddressResidenceChangeSuccess) {
                                return AddressClusterField(
                                  residenceUuid: state.residence.uuid,
                                );
                              } else {
                                return AddressClusterField();
                              }
                            },
                          ),
                          AddressDetailsInput(initialValue: address?.details),
                        ],
                      ),
                    ),
                  ),
                ),
                AddressSubmitButton(
                  uuid: address?.uuid,
                ),
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

class AddressLabelInput extends StatelessWidget {
  final String? initialValue;

  AddressLabelInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      context
          .read<AddressFormBloc>()
          .add(AddressFormLabelChangeEvent(label: initialValue!));
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Label alamat',
        ),
        initialValue: initialValue,
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
  final Residence? initialValue;

  AddressResidenceField({this.initialValue});

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      context.read<AddressFormBloc>().add(
          AddressFormResidenceChangeEvent(residenceUuid: initialValue!.uuid));
    }
    print('[AddressResidenceField] [build] initialValue: $initialValue');
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownSearch<Residence>(
        mode: Mode.MENU,
        showSelectedItems: true,
        selectedItem:
            initialValue ?? Residence(uuid: '', name: 'Pilih perumahan'),
        compareFn: (item, selectedItem) => item?.uuid == selectedItem?.uuid,
        dropdownSearchDecoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Perumahan',
          contentPadding: EdgeInsets.fromLTRB(12, 11, 0, 0),
        ),
        dropdownBuilder: _customDropdown,
        popupItemBuilder: _customPopupItem,
        onFind: (String? filter) async {
          ResidencesResponse? res = await ResidenceRepository().getResidences();
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
                .add(AddressResidenceChangeEvent(residence: residence));
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
  final String? residenceUuid;
  final Cluster? initialValue;

  AddressClusterField({
    this.residenceUuid,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    context
        .read<AddressFormBloc>()
        .add(AddressFormClusterChangeEvent(clusterUuid: initialValue?.uuid));
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          print('[AddressClusterField] [build] initialValue: $initialValue');
          return DropdownSearch<Cluster>(
            mode: Mode.MENU,
            showSelectedItems: true,
            selectedItem: initialValue != null
                ? initialValue
                : Cluster(uuid: '', name: 'Pilih cluster'),
            compareFn: (item, selectedItem) => item?.uuid == selectedItem?.uuid,
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Cluster',
              contentPadding: EdgeInsets.fromLTRB(12, 11, 0, 0),
            ),
            dropdownBuilder: _customDropdown,
            popupItemBuilder: _customPopupItem,
            onFind: (String? filter) async {
              if (residenceUuid == null) {
                return List.empty();
              }
              ClustersResponse? res =
                  await ClusterRepository().getClusters(residenceUuid!);
              if (res != null) {
                return res.data;
              }
              return List.empty();
            },
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

class AddressDetailsInput extends StatelessWidget {
  final String? initialValue;

  AddressDetailsInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      context
          .read<AddressFormBloc>()
          .add(AddressFormDetailsChangeEvent(details: initialValue!));
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Detail alamat',
        ),
        initialValue: initialValue,
        onChanged: (value) {
          context
              .read<AddressFormBloc>()
              .add(AddressFormDetailsChangeEvent(details: value));
        },
      ),
    );
  }
}

class AddressSubmitButton extends StatelessWidget {
  final String? uuid;

  AddressSubmitButton({this.uuid});

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
                        .add(AddressFormSubmitEvent(uuid: uuid))
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
          return DialogBackground();
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
    return BlocBuilder<AddressFormBloc, AddressFormState>(
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return Center(
            child: LoadingDialog(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
