import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/OrderController.dart';
import 'package:foodmood/Controllers/TableSocialController.dart';
import 'package:foodmood/Screens/Common/SendAway/SendAway.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../UserProfile.dart';

class UserSocialFeaturesBottomSheet extends StatefulWidget {
  final String userId;
  final String orderId;
  final int tableNumber;
  const UserSocialFeaturesBottomSheet(
      {Key? key,
      required this.userId,
      required this.orderId,
      required this.tableNumber})
      : super(key: key);

  @override
  _UserSocialFeaturesBottomSheetState createState() =>
      _UserSocialFeaturesBottomSheetState();
}

class _UserSocialFeaturesBottomSheetState
    extends State<UserSocialFeaturesBottomSheet> {
  TableSocialController tableSocialController = Get.find();
  OrderController orderController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    Get.to(
                        () => UserProfile(
                              userId: widget.userId,
                            ),
                        preventDuplicates: false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Profilini gör",
                        style: GoogleFonts.quicksand(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Mesaj yaz",
                        style: GoogleFonts.quicksand(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    print(widget.tableNumber);
                    print(widget.orderId);
                    print(widget.userId);
                    Get.to(
                      () => SendAway(
                        fromTable: true,
                        restaurantId:
                            orderController.order!.data()!["restaurantId"],
                        tableNumber: widget.tableNumber,
                        orderId: widget.orderId,
                        toUserId: widget.userId,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Ismarla",
                        style: GoogleFonts.quicksand(),
                      ),
                    ),
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
