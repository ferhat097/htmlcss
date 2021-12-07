import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/TableDetailController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TableDetail extends StatefulWidget {
  final String restaurantId;
  final int tableNumber;
  const TableDetail(
      {Key? key, required this.restaurantId, required this.tableNumber})
      : super(key: key);

  @override
  _TableDetailState createState() => _TableDetailState();
}

class _TableDetailState extends State<TableDetail> {
  TableDetailController tableDetailController =
      Get.put(TableDetailController());
  @override
  void initState() {
    tableDetailController.listenTable(widget.restaurantId, widget.tableNumber);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<TableDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableDetailController>(
      builder: (controller) {
        if (controller.table != null) {
          List images = [];
          if (controller.table!.data()!["images"] != null) {
            images = controller.table!.data()!["images"];
          }
          return Container(
            decoration: BoxDecoration(
              color: defineMainBackgroundColor(),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      if (images.isNotEmpty)
                        CarouselSlider.builder(
                          itemCount: controller.table!.data()!["images"].length,
                          itemBuilder: (context, index, index2) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(color: Colors.red),
                              child: Image.network(
                                controller.table!.data()!["images"][index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          options: CarouselOptions(viewportFraction: 1),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Masanın şəkilləri əlavə olunmayıb",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ),
                        ),
                      if (images.isNotEmpty)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.red,
                          ),
                        )
                      else
                        SizedBox(),
                    ],
                  ),
                ),
                if (controller.table!.data()!["busy"])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: context.theme.primaryColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              color: Colors.red,
                            ),
                            Text(
                              "Masa doludur",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: context.theme.primaryColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: Colors.green,
                            ),
                            Text(
                              "Masa boşdur",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Deposit",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              controller.table!.data()!["isDeposit"]
                                  ? Text(
                                      "${controller.table!.data()!["deposit"].toString()} AZN",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "Deposit tələb olunmur",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Ön rezervsiya",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              controller.table!.data()!["preOrderRequired"]
                                  ? Text(
                                      "${controller.table!.data()!["preOrderTime"].toString()} saat",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "Ön rezervasiya tələb olunmur",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold),
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Rezerv et",
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
