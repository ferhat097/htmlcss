import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/TablePageController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:foodmood/Screens/Common/TableDetail.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TablePage extends StatefulWidget {
  final String restaurantId;
  final bool isActiveTableOrder;
  const TablePage(
      {Key? key, required this.restaurantId, required this.isActiveTableOrder})
      : super(key: key);

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  initState() {
    tablePageController.listenTableinfo(widget.restaurantId);
    super.initState();
  }

  TablePageController tablePageController = Get.put(TablePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: defineWhiteBlack(),
        ),
        title: Text(
          "Masalar",
          style: GoogleFonts.quicksand(
            color: defineWhiteBlack(),
          ),
        ),
      ),
      body: GetBuilder<TablePageController>(
        builder: (controller) {
          if (controller.tables.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: [
                  if (!widget.isActiveTableOrder)
                    Text(
                      "Masadan sifariş aktiv olmadığı üçün masaların dolu vəya boş olması məlumatları düzgün deyil!",
                      style: GoogleFonts.quicksand(),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: controller.tables.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: Get.isDarkMode
                                ? [
                                    // Color(0xFFdee4ea), Color(0xFFe1e9f0)//ag
                                    // Color(0xFFe9e9e9), Color(0xFFf6f6f6)
                                    Color(0xFF28313b),
                                    Color(0xFF37404a) //qara
                                  ]
                                : [Color(0xFFdee4ea), Color(0xFFe1e9f0)],
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {
                              Get.bottomSheet(
                                  TableDetail(
                                    restaurantId: widget.restaurantId,
                                    tableNumber: controller.tables[index]
                                        .data()!["tableNumber"],
                                  ),
                                  isScrollControlled: true);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: controller.defineTableStatus(
                                      controller.tables[index].data()!["busy"],
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(controller
                                          .tables[index]
                                          .data()!["mainImage"]),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  controller.tables[index].data()!["tableType"],
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
