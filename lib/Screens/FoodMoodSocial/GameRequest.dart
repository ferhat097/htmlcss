// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/GameRequestController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GameRequest extends StatefulWidget {
  const GameRequest({Key? key}) : super(key: key);

  @override
  _GameRequestState createState() => _GameRequestState();
}

class _GameRequestState extends State<GameRequest> {
  GameRequestController gameRequestController =
      Get.put(GameRequestController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameRequestController>(builder: (controller) {
      if (controller.games.isNotEmpty) {
        return Container(
          child: ListView.builder(
            itemCount: controller.games.length,
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  children: [Text("data")],
                ),
              );
            },
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Oyun təklifi yoxdur!",
              style: GoogleFonts.encodeSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Material(
                color: Colors.pink,
                elevation: 5,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    Get.snackbar(
                      "Tezliklə",
                      "Tezliklə FoodMood-un təklif etdiyi əyləncəli və qazandırıcı oyunları dostlarınızla və digər insanlarla oynaya biləcəksiniz!",
                      backgroundColor: Colors.pink,
                      borderRadius: 5,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(
                            "assets/crystal-ball.png",
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Təklif göndər",
                          style: GoogleFonts.encodeSans(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }
    });
  }
}
