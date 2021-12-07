// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodmood/Controllers/ReportCommentController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportComment extends StatefulWidget {
  final int what; //1=restaurantcomment, 2 = foodcomment, 3 = userphoto
  final String reportedUserId; //
  final String id1; // if 1, id1=restaurantId, if 2 , id1=foodId,
  final String id2; // if 1, id2=commentId, if 2, id2 = commentId
  const ReportComment({
    Key? key,
    required this.what,
    required this.id1,
    required this.id2,
    required this.reportedUserId,
  }) : super(key: key);

  @override
  _ReportCommentState createState() => _ReportCommentState();
}

class _ReportCommentState extends State<ReportComment> {
  int sendStatus = 1;
  ReportCommentController reportCommentController =
      Get.put(ReportCommentController());
  @override
  void dispose() {
    Get.delete<ReportCommentController>();
    super.dispose();
  }

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
                      style: GoogleFonts.encodeSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Şikayət üçün aşağıdakılardan birini seçin. Şikayətinizə 24 saat ərzində baxılaraq sizə məlumat veriləcək. Daha ətraflı \"FoodMood TM\" Yardım Mərkəzinə bildirin.\n \"FoodMood\"-u seçdiyiniz üçün təşəkkür edirik",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
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
                              await reportCommentController.reportMessage(
                                "Təhqir və söyüş",
                                widget.reportedUserId,
                                widget.what,
                                widget.id1,
                                widget.id2,
                              );
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8,
                              ),
                              child: Text(
                                "Təhqir və söyüş",
                                style: GoogleFonts.encodeSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
                              await reportCommentController.reportMessage(
                                "Təhqir və söyüş",
                                widget.reportedUserId,
                                widget.what,
                                widget.id1,
                                widget.id2,
                              );
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8,
                              ),
                              child: Text(
                                "Uyğunsuz şəkil",
                                style: GoogleFonts.encodeSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
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
                              await reportCommentController.reportMessage(
                                "Təhqir və söyüş",
                                widget.reportedUserId,
                                widget.what,
                                widget.id1,
                                widget.id2,
                              );
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8,
                              ),
                              child: Text(
                                "Narkotik vasitələrin təbliği",
                                style: GoogleFonts.encodeSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
                              await reportCommentController.reportMessage(
                                "Təhqir və söyüş",
                                widget.reportedUserId,
                                widget.what,
                                widget.id1,
                                widget.id2,
                              );
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8,
                              ),
                              child: Text(
                                "Cinsi istismar",
                                style: GoogleFonts.encodeSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
                              await reportCommentController.reportMessage(
                                "Təhqir və söyüş",
                                widget.reportedUserId,
                                widget.what,
                                widget.id1,
                                widget.id2,
                              );
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8,
                              ),
                              child: Text(
                                "Dini istismar",
                                style: GoogleFonts.encodeSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
                              await reportCommentController.reportMessage(
                                "Təhqir və söyüş",
                                widget.reportedUserId,
                                widget.what,
                                widget.id1,
                                widget.id2,
                              );
                              setState(() {
                                sendStatus = 3;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8,
                              ),
                              child: Text(
                                "Digər \"FoodMood\" şərtlərinin pozulması",
                                style: GoogleFonts.encodeSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
