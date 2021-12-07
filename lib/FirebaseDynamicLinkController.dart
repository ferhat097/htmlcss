import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

import 'Screens/Common/MenuPage.dart';

class FirebaseDynamicLinkController extends GetxController {
  FirebaseDynamicLinks firebaseDynamicLinks = FirebaseDynamicLinks.instance;
  @override
  void onInit() async {
    //await onLink();
    await initialLink();
    super.onInit();
  }

  Future initialLink() async {
    await Future.delayed(Duration(seconds: 3));
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data?.link;
    final queryParams = deepLink!.queryParameters;
    print(deepLink);
    if (queryParams.length > 0) {
      var userName = queryParams['userId'];
    }
  }

  Future onLink() async {
    firebaseDynamicLinks.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        print(deepLink.toString());

        if (deepLink != null) {
          String deepLinkUrl = deepLink.toString();
          List<String> linkList = deepLinkUrl.split("?");
          if (linkList[0].endsWith("menu")) {
            String restaurantId = linkList[1];
            List<String> resta = restaurantId.split("=");
            String resId = resta[1];
            resId.trim();
            String tableNumber = linkList[2];
            List<String> table = tableNumber.split("=");
            int tabl = int.parse(table[1]);
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
  }
}
