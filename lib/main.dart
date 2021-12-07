import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodmood/Controllers/MessageDetailController.dart';
import 'package:foodmood/Screens/FoodMoodSocial/MessageDetail.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'FirebaseDynamicLinkController.dart';
import 'Screens/Common/MenuPage.dart';
import 'SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await initializeDateFormatting();

  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  FirebaseDynamicLinkController firebaseDynamicLinkController = Get.put(
    FirebaseDynamicLinkController(),
    permanent: true,
  );
  FirebaseDatabase firebasePresence = FirebaseDatabase(
    databaseURL: "https://foodmood-presence.firebaseio.com/",
  );
  @override
  initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
        firebasePresence
            .reference()
            .child("/${FirebaseAuth.instance.currentUser!.uid}")
            .update(
          <String, dynamic>{
            "online": true,
            "date": DateTime.now().millisecondsSinceEpoch
          },
        );
      }
    } else if (state == AppLifecycleState.paused) {
      firebasePresence
          .reference()
          .child("/${FirebaseAuth.instance.currentUser!.uid}")
          .update(
        <String, dynamic>{
          "online": false,
          "date": DateTime.now().millisecondsSinceEpoch
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        if (deepLink != null) {
          print("first");
          String deepLinkUrl = deepLink.toString();
          List<String> linkList = deepLinkUrl.split("?");
          if (linkList[0].endsWith("menu")) {
            print("okfirst");
            String restaurantId = linkList[1];
            print("ok3");
            List<String> resta = restaurantId.split("=");
            print("ok4");
            String resId = resta[1];
            print("ok5");
            resId.trim();
            String tableNumber = linkList[2];
            print("ok6");
            List<String> table = tableNumber.split("%3D");
            print("ok7");
            print(table);
            String number = table[1].trim();
            number.replaceAll(" ", "");
            int tabl = int.parse(number);
            print("ok8");
            Get.to(
              () => MenuPage(
                restaurantId: resId,
                fromQr: true,
                tableNumber: tabl,
              ),
            );
          }
        }
      },
      onError: (OnLinkErrorException e) async {
        print("deeplink error");
        print(e.message);
      },
    );
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message received from foreground");
      String generalType = message.data["generalType"];

      if (generalType == "message") {
        String? title = message.notification!.title;
        String? body = message.notification!.body;
        String from = message.data["userId"];
        if (!Get.isRegistered<MessageDetailController>()) {
          print("registered");
          Get.snackbar(
            title!,
            body!,
            onTap: (a) {
              Get.to(
                () => MessageDetail(
                  withConversation: false,
                  userId: from,
                  user: {},
                ),
              );
            },
          );
        } else {
          MessageDetailController messageDetailController = Get.find();
          String userId = messageDetailController.user!.id;
          if (from != userId) {
            Get.snackbar(
              title!,
              body!,
            );
          }
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage(todo);

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("object");
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodMood',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        backgroundColor: Colors.grey[200],
        primaryColor: Colors.grey[200],
      ),
      home: const SplashScreen(),
    );
  }
}

Future todo(RemoteMessage message) async {
  String generalType = message.data["generalType"];

  if (generalType == "message") {
    String from = message.data["userId"];
    Get.off(
      () => MessageDetail(
        withConversation: false,
        userId: from,
        user: const {},
      ),
    );
  }
}
