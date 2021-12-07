// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Screens/Common/Order/OrderPage.dart';
import 'package:foodmood/Screens/Login/CompleteSignup.dart';
import 'package:foodmood/Screens/Login/LoginSplash.dart';
import 'package:foodmood/Screens/Main.dart';
import 'package:foodmood/Screens/NoInternetConnection.dart';
import 'package:foodmood/defaults.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:random_string/random_string.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  @override
  onInit() {
    listenInternetConnection();
    everyTenMinute();
    authStream = firebaseAuth.authStateChanges().listen((user) async {
      GeneralController generalController = Get.find();
      await generalController.getGeneral();
      await Future.delayed(const Duration(seconds: 3));
      //await getConnectivity();
      //listenRealConnectivity();
      if (user != null) {
        if (!user.isAnonymous) {
          await presenceUser();
        }
        await getStorage.write("userUid", firebaseAuth.currentUser!.uid);
        pleaseWait.value = false;
        Get.offAll(
          () => Main(
            isAnonym: user.isAnonymous,
          ),
          transition: Transition.size,
        );
      } else {
        await signInAnonymously();
      }
    });
    super.onInit();
  }

  @override
  onClose() {
    authStream.cancel();
    subscription?.cancel();
    timerForPresence?.cancel();
    //timer?.cancel();
    super.onClose();
  }

  Timer? timerForPresence;

  everyTenMinute() {
    FirebaseDatabase firebasePresence = FirebaseDatabase(
        databaseURL: "https://foodmood-presence.firebaseio.com/");
    timerForPresence = Timer.periodic(const Duration(minutes: 10), (timer) {
      firebasePresence.goOnline();
    });
  }

  bool activeInternet = true;
  StreamSubscription? subscription;
  listenInternetConnection() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      print("result $result");

      if (result != ConnectivityResult.none ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        bool active = await checkActiveInternet();
        if (active) {
          activeInternet = true;
          // Get.offAll(
          //   () => Main(
          //     isAnonym: FirebaseAuth.instance.currentUser!.isAnonymous,
          //   ),
          // );
          update(["internet"]);
        } else {
          activeInternet = false;
          print("connect");
          Get.offAll(() => const NoInternetConnection());
          update(["internet"]);
        }
      } else {
        activeInternet = false;
        print("connect");
        Get.offAll(() => const NoInternetConnection());
        update(["internet"]);
      }
    });
  }

  Future<bool> getConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      bool active = await checkActiveInternet();
      if (active) {
        activeInternet = true;
        update(["internet"]);
        return true;
      } else {
        Get.snackbar(
          "Internet bağlantısı yoxdur!",
          "Cihazınızın internetə bağlı olduğuna əmin olun.",
          backgroundColor: Colors.red.withOpacity(0.8),
          borderRadius: 5,
          dismissDirection: SnackDismissDirection.HORIZONTAL,
          snackStyle: SnackStyle.FLOATING,
          colorText: Colors.white,
        );
        activeInternet = false;
        update(["internet"]);
        return false;
      }
    } else {
      activeInternet = false;
      Get.snackbar(
        "Internet bağlantısı yoxdur!",
        "Cihazınızın internetə bağlı olduğuna əmin olun.",
        backgroundColor: Colors.red.withOpacity(0.8),
        borderRadius: 5,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        snackStyle: SnackStyle.FLOATING,
        colorText: Colors.white,
      );
      update(["internet"]);
      return false;
    }
  }

  Future<bool> checkActiveInternet() async {
    try {
      http.Response response = await http
          .get(Uri.parse("https://example.com"))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on TimeoutException catch (e) {
      return false;
    } on SocketException catch (e) {
      return false;
    } on Error catch (e) {
      return false;
    }
  }

  // Timer? timer;

  // listenRealConnectivity() {
  //   timer = Timer.periodic(
  //     const Duration(seconds: 15),
  //     (timer) async {
  //       print("listenreal connectivity");
  //       await getConnectivity();
  //     },
  //   );
  // }
  FirebaseDatabase firebasePresence = FirebaseDatabase(
      databaseURL: "https://foodmood-presence.firebaseio.com/");

  Future presenceUser() async {
    await firebasePresence
        .reference()
        .child("/${firebaseAuth.currentUser!.uid}")
        .update(<String, dynamic>{
      "online": true,
      "date": DateTime.now().millisecondsSinceEpoch
    });
    firebasePresence
        .reference()
        .child("/${firebaseAuth.currentUser!.uid}")
        .onDisconnect()
        .update(<String, dynamic>{
      "online": false,
      "date": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future signInAnonymously() async {
    await firebaseAuth.signInAnonymously();
  }

  FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  GetStorage getStorage = GetStorage();
  // Future<bool> checkPhoneNumber(String phoneNumber) async {
  //   String phone = "+994$phoneNumber";
  //   HttpsCallable callable =
  //       firebaseFunctions.httpsCallable('checkPhoneNumber');
  //   HttpsCallableResult results = await callable
  //       .call(<String, dynamic>{'phoneNumber': phone}).catchError((error) {
  //     print(error);
  //   });
  //   return results.data;
  // }
  TextEditingController nameController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();

  File? profilePhoto;
  Future<String> saveUserPhoto(String username) async {
    Reference reference = firebaseStorage.ref("Users/$userName");
    TaskSnapshot uploadTask = await reference.putFile(profilePhoto!);
    String url = await reference.getDownloadURL();
    return url;
  }

  Future getPhotoFromGallery() async {
    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    profilePhoto = File(pickedFile!.path);
    update(["changephoto"]);
  }

  Future getPhotoFromCamera() async {
    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.camera);
    profilePhoto = File(pickedFile!.path);
    update(["changephoto"]);
  }

  // Future saveFirestoreUserInfo(
  //   String userId,
  //   String userName,
  //   String name,
  //   String? userPhoto,
  //   int sex,
  // ) async {
  //   completeLoading = true;
  //   update(["complete"]);
  //   int age;
  //   if (birthday != null) {
  //     age = birthday!.millisecondsSinceEpoch;
  //   } else {
  //     age = DateTime.now().millisecondsSinceEpoch;
  //   }
  //   if (userPhoto == null) {
  //     userPhoto = defaultProfilePhoto;
  //   }
  //   if (profilePhoto != null) {
  //     userPhoto = await saveUserPhoto(userName);
  //   }
  //   String? token = await firebaseMessaging.getToken();
  //   HttpsCallable httpsCallable = firebaseFunctions.httpsCallable("createUser");
  //   await httpsCallable.call(
  //     <String, dynamic>{
  //       "userId": userId,
  //       "userName": userName,
  //       "name": name,
  //       "userPhoto": userPhoto,
  //       "token": token!,
  //       "sex": sex,
  //       "age": age
  //     },
  //   );
  //   completeLoading = false;
  //   update(["complete"]);
  // }
  // Future saveToken() async {
  //   String? token = await firebaseMessaging.getToken();
  //   HttpsCallable httpsCallable =
  //       firebaseFunctions.httpsCallable("saveWaiterToken");
  //   await httpsCallable.call(<String, dynamic>{
  //     "token": token,
  //     "waiterId": firebaseAuth.currentUser!.uid
  //   });
  // }

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  // FocusNode signinNumberFocus = FocusNode();
  // FocusNode signinCodeFocus = FocusNode();
  RxBool sent = false.obs;
  late String verifid;
  bool fromSignUp = true;
  RxBool pleaseWait = false.obs;
  late StreamSubscription authStream;

  RxBool loginEmailProblem = false.obs;
  RxBool loginPasswordProblem = false.obs;

// Google Sign in

  Future<bool> signInWithGoogle() async {
    authStream.pause();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      pleaseWait.value = true;
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        print("save toFirestroe");
        String name = userCredential.user!.displayName ?? "user";
        String trimmed = name.trim();
        String replaced = trimmed.replaceAll(" ", "");
        String userNamed = setUserName(replaced);
        String? token = await firebaseMessaging.getToken();
        String localeName =
            WidgetsBinding.instance!.window.locale.countryCode ?? "";
        HttpsCallable httpsCallable =
            firebaseFunctions.httpsCallable("createUser");
        await httpsCallable.call(<String, dynamic>{
          "userId": userCredential.user!.uid,
          "localeName": localeName,
          "userName": userNamed,
          "name": userCredential.user!.displayName ?? "user",
          "userPhoto": defaultProfilePhoto,
          "token": token!,
          "sex": 0,
          "age": 0,
        });
      } else {
        updateToken(userCredential.user!.uid);
      }
    } catch (e) {
      pleaseWait.value = false;
      authStream.resume();
      return false;
    }

    print("ok");

    authStream.resume();
    return true;
  }

  // Apple Sign in

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    authStream.pause();
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    try {
      pleaseWait.value = true;
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(oauthCredential);
      print("0");
      print(userCredential.additionalUserInfo!.isNewUser);
      print(userCredential.user!.displayName ?? "user");
      if (userCredential.additionalUserInfo!.isNewUser) {
        String name = userCredential.user!.displayName ?? "user";
        String trimmed = name.trim();
        String replaced = trimmed.replaceAll(" ", "");
        String userNamed = setUserName(replaced);
        //await userCredential.user!.updatePhotoURL(defaultProfilePhoto);
        String? token = await firebaseMessaging.getToken();
        String localeName =
            WidgetsBinding.instance!.window.locale.countryCode ?? "";
        print("0.1");
        HttpsCallable httpsCallable =
            firebaseFunctions.httpsCallable("createUser");
        print("1");
        print(userCredential.user!.uid);
        await httpsCallable.call(
          <String, dynamic>{
            "userId": userCredential.user!.uid,
            "localeName": localeName,
            "userName": userNamed,
            "name": userCredential.user!.displayName ?? "user",
            "userPhoto": defaultProfilePhoto,
            "token": token!,
            "sex": 0,
            "age": 0,
          },
        );
        print("2");
      } else {
        updateToken(userCredential.user!.uid);
      }
    } catch (e) {
      pleaseWait.value = false;
      authStream.resume();
      return false;
    }

    authStream.resume();
    return true;
  }

  // Sign in With Email

  bool registerLoading = false;
  String? errorMessage;

  Future<bool> signUpWithEmail(
    String email,
    String password,
    String name,
    String photoUrl,
  ) async {
    registerLoading = true;
    update(["register"]);
    authStream.pause();
    UserCredential? userCredential;
    try {
      pleaseWait.value = true;
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          errorMessage =
              "Bu e-mail adresi artıq qeydiyyatdan keçib. Giriş etmək üçün 'Daxil ol' səhifəsinə gedin!";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          errorMessage =
              "Şifrə yalnışdır. Şifrənizi yeniləmək üçün 'E-mail adresinə göndər' düyməsinə toxunun!";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          errorMessage =
              "Bu e-mail adresində qeydiyyatlı istifadəçi yoxdur! Qeydiyyatdan keçin!";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          errorMessage =
              "Sizin hesab FoodMood tərəfindən blok olunub. Daha ətraflı məlumat üçün info@foodmood.me adresinə yazın!";
          break;
        case "operation-not-allowed":
          errorMessage =
              "Giriş etmə limitini aşmısınız. Daha sonra təkrar yoxlayın!";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errorMessage = "E-mail adresi düzgün deyil!";
          break;
        default:
          errorMessage = "Çətinlik yaşandı! Daha sonra təkrar yoxlayın!";
          break;
      }
      authStream.resume();
      registerLoading = false;
      update(["register"]);
      pleaseWait.value = false;
      return false;
    }

    String userNamed = setUserName(name);
    await userCredential.user!.updateDisplayName(userNamed);
    await userCredential.user!.updatePhotoURL(defaultProfilePhoto);
    String? token = await firebaseMessaging.getToken();
    String localeName =
        WidgetsBinding.instance!.window.locale.countryCode ?? "";
    HttpsCallable httpsCallable = firebaseFunctions.httpsCallable("createUser");
    await httpsCallable.call(
      <String, dynamic>{
        "userId": userCredential.user!.uid,
        "localeName": localeName,
        "userName": userNamed,
        "name": name,
        "userPhoto": photoUrl,
        "token": token!,
        "sex": 0,
        "age": 0,
      },
    );
    authStream.resume();
    registerLoading = false;
    update(["register"]);
    return true;
  }

  bool loginLoading = false;

  Future<bool> signInWithEmail(String email, String password) async {
    pleaseWait.value = true;
    loginLoading = true;
    update(["login"]);
    UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          errorMessage =
              "Bu e-mail adresi artıq qeydiyyatdan keçib. Giriş etmək üçün 'Daxil ol' səhifəsinə gedin!";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          errorMessage =
              "Şifrə yalnışdır. Şifrənizi yeniləmək üçün 'E-mail adresinə göndər' düyməsinə toxunun!";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          errorMessage =
              "Bu e-mail adresində qeydiyyatlı istifadəçi yoxdur! Qeydiyyatdan keçin!";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          errorMessage =
              "Sizin hesab FoodMood tərəfindən blok olunub. Daha ətraflı məlumat üçün info@foodmood.me adresinə yazın!";
          break;
        case "operation-not-allowed":
          errorMessage =
              "Giriş etmə limitini aşmısınız. Daha sonra təkrar yoxlayın!";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errorMessage = "E-mail adresi düzgün deyil!";
          break;
        default:
          errorMessage = "Çətinlik yaşandı! Daha sonra təkrar yoxlayın!";
          break;
      }
      print(e.code);
      pleaseWait.value = false;
      loginLoading = false;
      update(["login"]);
      return false;
    }

    updateToken(userCredential.user!.uid);
    loginLoading = false;

    update(["login"]);
    return true;
  }

  Future lostPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Get.snackbar("Şifrəni sıfırlama linki göndərildi",
          "Zəhmət olmasa $email e-poçtunu yoxlayın");
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future updateToken(String userId) async {
    String? token = await firebaseMessaging.getToken();
    String localeName =
        WidgetsBinding.instance!.window.locale.countryCode ?? "";
    if (token != null) {
      await firebaseFirestore
          .collection("FoodMoodSocial")
          .doc(userId)
          .update({"token": token, "localeName": localeName});
    }
  }

  // Future saveUserToFirestore()async{

  // }
  //
  // Future verifyphonenumber(String code, bool newUser,
  //     {String? name, String? eMail}) async {
  //   fromSignUp = newUser;
  //   PhoneAuthCredential phoneAuthCredential =
  //       PhoneAuthProvider.credential(verificationId: verifid, smsCode: code);
  //   print("1");
  //   authStream.pause();
  //   pleaseWait.value = true;
  //   UserCredential userCredential =
  //       await firebaseAuth.signInWithCredential(phoneAuthCredential);
  //   await getStorage.write("userUid", userCredential.user!.uid);
  //   if (newUser) {
  //     await createAccountFirestore(userCredential.user!.uid,
  //         userCredential.user!.phoneNumber, name, eMail);
  //   }
  //   authStream.resume();
  //   Future.delayed(Duration(milliseconds: 500))
  //       .whenComplete(() => pleaseWait.value = false);
  // }

  // Future signInWithPhoneNumber(String phoneNumber) async {
  //   String phone = "+994$phoneNumber";
  //   print(phone);
  //   await firebaseAuth.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     timeout: Duration(seconds: 60),
  //     verificationCompleted: (PhoneAuthCredential authCredential) async {
  //       await firebaseAuth.signInWithCredential(authCredential);
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       return print(e);
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       sent.value = true;
  //       verifid = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  // }

  // Future<bool> createAccountFirestore(
  //     String? userId, String? phoneNumber, String? name, String? eMail) async {
  //   HttpsCallable callable =
  //       FirebaseFunctions.instance.httpsCallable('createAccount');
  //   HttpsCallableResult results = await callable.call(<String, dynamic>{
  //     'phoneNumber': phoneNumber,
  //     'userId': userId,
  //     'name': name,
  //     'email': eMail
  //   }).catchError((error) {
  //     print(error);
  //   });
  //   return results.data;
  // }

  bool loadingLogout = false;

  Future logout() async {
    loadingLogout = true;
    update(["logoutButton"]);
    await firebaseAuth.signOut();
    loadingLogout = false;
    update(["logoutButton"]);
  }

  //forRegister

  TextEditingController registerNameController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  RxBool nameProblem = false.obs;
  RxBool emailProblem = false.obs;
  RxBool passwordProblem = false.obs;

  Future checkUserName(String userName) async {
    progress = true;
    update();
    QuerySnapshot<Map<String, dynamic>> users = await firebaseFirestore
        .collection("Users")
        .where("userName", isEqualTo: userName)
        .get();
    if (users.docs.isNotEmpty) {
      progress = false;
      availableUserName = false;
      Get.snackbar("Bu istifadəçi adı möcvuddur", "");
      update();
    } else {
      progress = false;
      availableUserName = true;
      userName = userNameController.text;
      update();
    }
  }

  String userName = "";

  String setUserName(String name) {
    String randomNumber = randomNumeric(5);
    String newUsername = "$name$randomNumber";
    newUsername.trim();
    newUsername.replaceAll(" ", "");
    userName = newUsername;
    return userName;
  }

  TextEditingController userNameController = TextEditingController();
  bool availableUserName = true;
  bool progress = false;

  setFalse() {
    availableUserName = true;
    update();
  }

  ///accept privacy policy
  bool privacyPolicy = false;
  bool eula = false;

  void acceptPP(bool value) {
    privacyPolicy = value;
    update(["licenses"]);
  }

  void acceptEula(bool value) {
    eula = value;
    update(["licenses"]);
  }
}
