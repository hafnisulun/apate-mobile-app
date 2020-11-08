import 'package:apate/data/models/merchant.dart';
import 'package:apate/screens/merchant_screen.dart';
import 'package:flutter/material.dart';

class MerchantCard extends StatelessWidget {
  final double width;
  final Merchant merchant;

  const MerchantCard({
    this.width = 160,
    @required this.merchant,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MerchantScreen(merchant: merchant)),
        );
      },
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/no_image.png",
                      image: merchant.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          merchant.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
