import 'package:apate/components/merchant_card.dart';
import 'package:apate/cubits/merchants_cubit.dart';
import 'package:apate/data/repositories/merchants_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Belanja"),
        automaticallyImplyLeading: true,
      ),
      body: BlocProvider(
        create: (context) => MerchantsCubit(MerchantsRepository()),
        child: MerchantGridView(),
      ),
    );
  }
}

class MerchantGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final merchantsCubit = context.bloc<MerchantsCubit>();
    merchantsCubit.getMerchants();
    return Container(
      child: BlocBuilder<MerchantsCubit, MerchantsState>(
        builder: (context, state) {
          if (state is MerchantsFetchSuccess) {
            return GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.77,
              children: [
                ...List.generate(
                    state.merchants.data.length,
                    (index) =>
                        MerchantCard(merchant: state.merchants.data[index]))
              ],
            );
          } else if (state is MerchantsFetchError) {
            return Center(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Koneksi internet terputus"),
                    SizedBox(height: 8.0),
                    FlatButton(
                      onPressed: () => merchantsCubit.getMerchants(),
                      color: Colors.green,
                      child: Text(
                        "COBA LAGI",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
