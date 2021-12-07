// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/BlockedUsersController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BlockedUsers extends StatefulWidget {
  final List userList;
  const BlockedUsers({Key? key, required this.userList}) : super(key: key);

  @override
  _BlockedUsersState createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  BlockedUsersController blockedUsersController = Get.put(
    BlockedUsersController(),
  );
  @override
  void initState() {
    if (widget.userList.isNotEmpty) {
      blockedUsersController.getUsers(widget.userList);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: GetBuilder<BlockedUsersController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.iconColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 5,
                  width: 40,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (controller.userList.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.userList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.network(
                                        controller.userList[index]["userPhoto"],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    controller.userList[index]["name"],
                                    style: GoogleFonts.quicksand(
                                      color: context.iconColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () async {
                                      await controller.unblock(
                                        controller.userList[index]["userId"],
                                      );
                                      Get.back();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        "Aç",
                                        style: GoogleFonts.encodeSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
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
                    },
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      "Blok olunmuş istifadəçi yoxdur",
                      style: GoogleFonts.quicksand(
                        color: context.iconColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
