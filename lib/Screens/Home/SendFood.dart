// ignore: file_names
// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/SendFoodController.dart';
import 'package:foodmood/Screens/Login/LoginSplash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SendFood extends StatefulWidget {
  final Map<String, dynamic> food;
  const SendFood({Key? key, required this.food}) : super(key: key);

  @override
  _SendFoodState createState() => _SendFoodState();
}

class _SendFoodState extends State<SendFood> {
  SendFoodController sendFoodController = Get.put(SendFoodController());
  @override
  void initState() {
    if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
      sendFoodController.setMessages();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SendFoodController>(
      builder: (controller) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.iconColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 5,
                width: 40,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        "Yeməyin linkini paylaş",
                        style: GoogleFonts.encodeSans(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (!FirebaseAuth.instance.currentUser!.isAnonymous)
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            // controller: controller.searchController,
                            onChanged: (String value) {
                              controller.delayAction(value);
                            },
                            decoration: InputDecoration(
                              hintText: "İstifadəçi axtar",
                              hintStyle: GoogleFonts.encodeSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: !controller.isSearching
                              ? ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: controller.users.length,
                                  itemBuilder: (context, index) {
                                    return Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.theme.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: SizedBox(
                                                        height: 80,
                                                        width: 80,
                                                        child: Image.network(
                                                          controller.defineUserPhoto(
                                                              controller.users[
                                                                      index][
                                                                  "fromConversation"],
                                                              controller.users[
                                                                  index]),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          controller.defineUserName(
                                                              controller.users[
                                                                      index][
                                                                  "fromConversation"],
                                                              controller.users[
                                                                  index]),
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              IgnorePointer(
                                                ignoring:
                                                    controller.sendLoading,
                                                child: Container(
                                                  width: 80,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Material(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    elevation: 2,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      onTap: () async {
                                                        await controller
                                                            .sendFood(
                                                          controller
                                                              .users[index],
                                                          widget.food,
                                                          index,
                                                        );
                                                      },
                                                      child: Center(
                                                        child: index ==
                                                                    controller
                                                                        .sendedIndex &&
                                                                controller
                                                                    .sendLoading
                                                            ? const SizedBox(
                                                                width: 32,
                                                                height: 32,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            : Text(
                                                                "Göndər",
                                                                style: GoogleFonts
                                                                    .encodeSans(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Daha çoxu üçün:",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink),
                          ),
                          onPressed: () {
                            Get.to(() => const LoginSplash());
                          },
                          child: Text(
                            "Qeydiyyatdan keç vəya daxil ol",
                            style: GoogleFonts.encodeSans(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
