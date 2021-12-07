// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodmood/Controllers/MessageDetailController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportMessageBottomSheet extends StatefulWidget {
  final String conversationId;
  final String reportedUserId;
  const ReportMessageBottomSheet(
      {Key? key, required this.conversationId, required this.reportedUserId})
      : super(key: key);

  @override
  _ReportMessageBottomSheetState createState() =>
      _ReportMessageBottomSheetState();
}

class _ReportMessageBottomSheetState extends State<ReportMessageBottomSheet> {
  MessageDetailController messageDetailController = Get.find();
  int sendStatus = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Builder(
          builder: (context) {
            if (sendStatus == 1) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Şikayət səbəbim",
                      style: GoogleFonts.quicksand(
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Şikayət üçün aşağıdakılardan birini seçin. Şikayətinizə 24 saat ərzində baxılaraq sizə məlumat veriləcək. Daha ətraflı \"FoodMood TM\" Yardım Mərkəzinə bildirin.\n \"FoodMood\"-u seçdiyiniz üçün təşəkkür edirik",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Container(
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
                            onTap: () async {
                              setState(() {
                                sendStatus = 2;
                              });
                              await messageDetailController.reportMessage(
                                  "Təhqir və söyüş",
                                  widget.reportedUserId,
                                  widget.conversationId);
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                "Təhqir və söyüş",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
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
                            onTap: () async {
                              setState(() {
                                sendStatus = 2;
                              });
                              await messageDetailController.reportMessage(
                                  "Uyğunsuz şəkil",
                                  widget.reportedUserId,
                                  widget.conversationId);
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                "Uyğunsuz şəkil",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Container(
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
                            onTap: () async {
                              setState(() {
                                sendStatus = 2;
                              });
                              await messageDetailController.reportMessage(
                                  "Narkotik vasitələrin təbliği",
                                  widget.reportedUserId,
                                  widget.conversationId);
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                "Narkotik vasitələrin təbliği",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
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
                            onTap: () async {
                              setState(() {
                                sendStatus = 2;
                              });
                              await messageDetailController.reportMessage(
                                  "Cinsi İstismar",
                                  widget.reportedUserId,
                                  widget.conversationId);
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                "Cinsi istismar",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Container(
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
                            onTap: () async {
                              setState(() {
                                sendStatus = 2;
                              });
                              await messageDetailController.reportMessage(
                                  "Dini İstismar",
                                  widget.reportedUserId,
                                  widget.conversationId);
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                "Dini istismar",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
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
                            onTap: () async {
                              setState(() {
                                sendStatus = 2;
                              });
                              await messageDetailController.reportMessage(
                                  "Digər \"FoodMood\" şərtlərinin pozulması",
                                  widget.reportedUserId,
                                  widget.conversationId);
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                "Digər \"FoodMood\" şərtlərinin pozulması",
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else if (sendStatus == 2) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Göndərilir",
                      style: GoogleFonts.quicksand(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: FaIcon(
                      FontAwesomeIcons.checkCircle,
                      size: 90,
                      color: Colors.green,
                    )),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Şikayətiniz göndərildi. 24 saat ərzində məlumat veriləcək. Bu yolda bizə dəstək olduğunuz üçün təşəkkür edirik!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
