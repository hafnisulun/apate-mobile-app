import 'package:apate/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akun"),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Item(
                field: "Nama",
                value: "Hafni Syaeful Sulun",
              ),
              Item(
                field: "Email",
                value: "hafni.sulun@gmail.com",
              ),
              Item(
                field: "No. telp.",
                value: "+62 856-2489-0099",
              ),
              Item(
                field: "Jenis kelamin",
                value: "Laki-laki",
              ),
              Item(
                field: "Alamat",
                value:
                    "STR\nSentra Timur Residence\nTower Orange\nUnit O1520C\nPulo Gebang, Cakung\nJakarta Timur, 13950",
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 24.0),
                child: OutlineButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                      (_) => false,
                    );
                  },
                  child: Text("KELUAR"),
                  borderSide: BorderSide(color: Colors.red),
                  highlightedBorderColor: Colors.red,
                  textColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String field;
  final String value;

  Item({
    @required this.field,
    @required this.value,
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
