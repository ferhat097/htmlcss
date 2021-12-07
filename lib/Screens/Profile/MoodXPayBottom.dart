// ignore_for_file: file_names

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/ProfilePageController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodXPay extends StatefulWidget {
  const MoodXPay({Key? key}) : super(key: key);

  @override
  _MoodXPayState createState() => _MoodXPayState();
}

class _MoodXPayState extends State<MoodXPay> {
  ProfilePageController profilePageController = Get.find();
  GeneralController generalController = Get.find();
  String cardNumber = "";
  String name = "";
  int money = 0;
  bool loading = false;
  Future send() async {
    HttpsCallable httpsCallable =
        FirebaseFunctions.instance.httpsCallable("payRequest");
    await httpsCallable.call(<String, dynamic>{
      "userId": profilePageController.meSocial!["userId"],
      "userName": profilePageController.meSocial!["userName"] ?? "",
      "currentMoodxBalance": profilePageController.meSocial!["moodx"],
      "cardNumber": cardNumber,
      "cardHolder": name,
      "money": money,
      "moodx": generalController.financial["moodx"],
      "cash": generalController.financial["cash"],
      "minMoodxPay": generalController.financial["minMoodxPay"],
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Column(
        children: [
          Expanded(
            child: Column(
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
                // const SizedBox(
                //   height: 20,
                // ),
                CreditCardWidget(
                  onCreditCardWidgetChange: (a) {},
                  cardNumber: cardNumber,
                  expiryDate: "XX/XX",
                  cardHolderName: name,
                  cvvCode: "cvvCode",
                  showBackView: false,

                  //glassmorphismConfig: Glassmorphism.defaultConfig(),
                  //backgroundImage: 'assets/card_bg.png',
                  obscureCardNumber: false,
                  obscureCardCvv: false,
                  isHolderNameVisible: true,
                  height: 175,
                  textStyle: GoogleFonts.encodeSans(
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  isChipVisible: true,
                  isSwipeGestureEnabled: false,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        cardNumber = text;
                      });
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(16),
                    ],
                    decoration: InputDecoration(
                      hintText: "Kartın 16 rəqəmli şifrəsi",
                      hintStyle: GoogleFonts.encodeSans(
                        color: context.iconColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Məlumatların məxfiliyi FoodMood TM tərəfindən tam təmin olunur",
                    style: GoogleFonts.quicksand(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        name = text.toUpperCase();
                      });
                    },
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                    ],
                    decoration: InputDecoration(
                      hintText: "Kart sahibinin adı (istəyə bağlı)",
                      hintStyle: GoogleFonts.encodeSans(
                        color: context.iconColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Kartın sizə aid olduğunu dəqiqləşdirə bilməyimiz üçün kart sahibinin adını yazmağınız məsləhət görürük",
                    style: GoogleFonts.quicksand(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: TextField(
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        setState(() {
                          money = int.parse(text);
                        });
                      } else {
                        money = 0;
                      }
                    },
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: InputDecoration(
                      hintText: "Tələb olunan məbləğ",
                      hintStyle: GoogleFonts.encodeSans(
                        color: context.iconColor,
                      ),
                      suffixText: "AZN",
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Bu bölmə boş buraxıldıqda MoodX hesabınıza uyğun gələn maksimum ödəmə hesabınıza köçürüləcək",
                    style: GoogleFonts.quicksand(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Text(
              "1-3 gün ərzində tələb etdiyiniz məbləğ hesabınıza köçürüləcək",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                color: context.iconColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Material(
              color: Colors.green,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  await send();
                  setState(() {
                    loading = false;
                  });
                  Get.back();
                  Get.snackbar(
                    "Tələbiniz göndərildi!",
                    "1-3 gün ərzində məbləğ hesabınıza köçürüləcək",
                  );
                },
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Center(
                            child: Text(
                              "Tələbi göndər",
                              style: GoogleFonts.encodeSans(
                                color: Colors.white,
                                fontSize: 18,
                              ),
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
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
