import 'package:apate/data/models/merchant.dart';
import 'package:apate/screens/merchant_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MerchantCard extends StatelessWidget {
  final double width;
  final Merchant merchant;

  const MerchantCard({
    this.width = 160,
    required this.merchant,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: MerchantScreen(merchant: merchant),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/no_image.png",
                image: merchant.image,
                imageErrorBuilder: (context, url, error) => Image.asset(
                  'assets/images/no_image.png',
                  fit: BoxFit.fill,
                ),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    merchant.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
