// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodmood/Controllers/GeneralController.dart';
import 'package:foodmood/Controllers/SearchController.dart';
import 'package:foodmood/DarkModeController.dart';
import 'package:foodmood/Screens/Common/FoodDetail.dart';
import 'package:foodmood/Screens/Common/RestaurantPage/RestaurantPage.dart';
import 'package:foodmood/Screens/Search/DirectionBottomSheet.dart';
import 'package:foodmood/Screens/Search/FilterFeatures.dart';
import 'package:foodmood/Screens/Search/OpenMap/OpenMap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SearchController searchController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: GetBuilder<SearchController>(
                builder: (controller) {
                  return IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.isDarkMode
                                  ? Colors.black54
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              onTap: () {
                                controller.setNearToFalse();
                              },
                              controller: searchController.searchController,
                              onChanged: (String value) async {
                                if (value.isEmpty) {
                                  searchController.setWidgettoSearch(false);
                                } else {
                                  searchController.searching.value = true;
                                  searchController.setWidgettoSearch(true);
                                  if (searchController.searchDelay != null) {
                                    searchController.searchDelay?.cancel();
                                  }
                                  searchController.searchDelayFunction(
                                      searchController.searchController.text);
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: searchController.isSearch
                                    ? Material(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                        color: context.theme.primaryColor,
                                        child: InkWell(
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                          onTap: () {
                                            searchController.searchController
                                                .clear();
                                            searchController
                                                .setWidgettoSearch(false);
                                            FocusScope.of(context).unfocus();
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            color: context.iconColor,
                                            size: 28,
                                          ),
                                        ),
                                      )
                                    : Material(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                        color:
                                            searchController.restaurantFeatures
                                                ? Colors.green
                                                : context.theme.primaryColor,
                                        child: InkWell(
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            Get.bottomSheet(
                                              const FilterFeatures(),
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                              backgroundColor:
                                                  defineMainBackgroundColor(),
                                            );
                                          },
                                          child: Icon(
                                            Icons.filter_list_rounded,
                                            color: context.isDarkMode
                                                ? Colors.white
                                                : searchController
                                                        .restaurantFeatures
                                                    ? Colors.white
                                                    : Colors.black,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                hintText: "Axtar",
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(left: 10, top: 15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          height: double.infinity,
                          child: Material(
                            borderRadius: BorderRadius.circular(60),
                            color: searchController.restaurantFeatures
                                ? Colors.green
                                : context.theme.primaryColor,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(60),
                              onTap: () async {
                                bool status =
                                    await searchController.permissionLocation();
                                if (status) {
                                  Get.to(
                                    () => const OpenMap(
                                      isRestaurant: false,
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(
                                  Icons.maps_home_work_outlined,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : searchController.restaurantFeatures
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
              child: Divider(),
            ),
            GetBuilder<GeneralController>(
              id: "generaladControll",
              builder: (controller) {
                if (controller.adControll.isNotEmpty) {
                  if (controller.adControll["isSearchBanner"]) {
                    return FutureBuilder<AdWidget>(
                      future: searchController.loadAds(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: snap.data!,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  if (!searchController.isSearch && !searchController.near) {
                    await searchController.getRestaurant();
                  }
                },
                child: SingleChildScrollView(
                  controller: searchController.controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetBuilder<SearchController>(
                        builder: (controller) {
                          if (controller.isSearch) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  IgnorePointer(
                                    ignoring: controller.loadingSearchIndex ||
                                        controller.searchIndex == "Restaurants",
                                    child: FilterChip(
                                      avatar: controller.loadingSearchIndex &&
                                              controller.searchIndex ==
                                                  "Restaurants"
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            )
                                          : SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Image.asset(
                                                "assets/restaurant.png",
                                              ),
                                            ),
                                      checkmarkColor: Colors.white,
                                      selectedColor: Colors.green[500],
                                      selected: searchController.searchIndex ==
                                          "Restaurants",
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      backgroundColor:
                                          context.theme.primaryColor,
                                      label: Row(
                                        children: [
                                          // SizedBox(
                                          //   width: 25,
                                          //   height: 25,
                                          //   child: Image.asset(
                                          //     "assets/restaurant.png",
                                          //   ),
                                          // ),
                                          // const SizedBox(
                                          //   width: 5,
                                          // ),
                                          Text(
                                            "Restoranlar",
                                            style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              fontWeight: searchController
                                                          .searchIndex ==
                                                      "Restaurants"
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: searchController
                                                          .searchIndex ==
                                                      "Restaurants"
                                                  ? Colors.white
                                                  : context.iconColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onSelected: (bool status) {
                                        searchController.searching.value = true;
                                        controller
                                            .setSearchIndex("Restaurants");
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  IgnorePointer(
                                    ignoring: controller.loadingSearchIndex ||
                                        controller.searchIndex == "Foods",
                                    child: FilterChip(
                                      avatar: controller.loadingSearchIndex &&
                                              controller.searchIndex == "Foods"
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            )
                                          : SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Image.asset(
                                                "assets/burger.png",
                                              ),
                                            ),
                                      checkmarkColor: Colors.white,
                                      selectedColor: Colors.green[500],
                                      selected: searchController.searchIndex ==
                                          "Foods",
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      backgroundColor:
                                          context.theme.primaryColor,
                                      label: Row(
                                        children: [
                                          // SizedBox(
                                          //   width: 25,
                                          //   height: 25,
                                          //   child: Image.asset(
                                          //     "assets/burger.png",
                                          //   ),
                                          // ),
                                          // const SizedBox(
                                          //   width: 5,
                                          // ),
                                          Text(
                                            "Yeməklər",
                                            style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              fontWeight: searchController
                                                          .searchIndex ==
                                                      "Foods"
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: searchController
                                                          .searchIndex ==
                                                      "Foods"
                                                  ? Colors.white
                                                  : context.iconColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onSelected: (bool status) {
                                        searchController.searching.value = true;
                                        controller.setSearchIndex("Foods");
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  FilterChip(
                                    avatar: controller.loadingSearchIndex &&
                                            controller.searchIndex == "Users"
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Image.asset(
                                                "assets/default-profile-picture.jpeg",
                                              ),
                                            ),
                                          ),
                                    checkmarkColor: Colors.white,
                                    selectedColor: Colors.green[500],
                                    selected: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    backgroundColor: context.theme.primaryColor,
                                    label: Row(
                                      children: [
                                        // ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.circular(25),
                                        //   child: SizedBox(
                                        //     width: 25,
                                        //     height: 25,
                                        //     child: Image.asset(
                                        //       "assets/default-profile-picture.jpeg",
                                        //     ),
                                        //   ),
                                        // ),
                                        // const SizedBox(
                                        //   width: 5,
                                        // ),
                                        Text(
                                          "İstifadəçilər",
                                          style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: context.iconColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onSelected: (bool status) {},
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    IgnorePointer(
                                      ignoring:
                                          controller.loadingGetNearRestaurant ||
                                              controller.loadingRestaurantType,
                                      child: FilterChip(
                                        avatar: controller
                                                .loadingGetNearRestaurant
                                            ? const CircularProgressIndicator(
                                                color: Colors.black,
                                                strokeWidth: 3,
                                              )
                                            : SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Icon(
                                                  Icons.my_location,
                                                  color: searchController.near
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                              ),
                                        showCheckmark: false,
                                        selectedColor: Colors.green,
                                        selected: searchController.near,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        backgroundColor: Colors.green[100],
                                        label: Row(
                                          children: [
                                            // Icon(
                                            //   Icons.my_location,
                                            //   color: searchController.near
                                            //       ? Colors.red
                                            //       : Colors.black,
                                            // ),
                                            // const SizedBox(
                                            //   width: 5,
                                            // ),
                                            Text(
                                              "Yaxındakılar",
                                              style: GoogleFonts.encodeSans(
                                                color: searchController.near
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight:
                                                    searchController.near
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onSelected: (bool status) async {
                                          await searchController
                                              .setNear(status);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                      height: 30,
                                      child: VerticalDivider(),
                                    ),
                                    IgnorePointer(
                                      ignoring: controller
                                              .loadingGetNearRestaurant ||
                                          controller.loadingRestaurantType ||
                                          controller.facilityType == 1,
                                      child: FilterChip(
                                        avatar: controller
                                                    .loadingRestaurantType &&
                                                controller.facilityType == 1
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )
                                            : SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Image.asset(
                                                  "assets/restaurant.png",
                                                ),
                                              ),
                                        selectedColor: Colors.green[500],
                                        checkmarkColor:
                                            searchController.facilityType == 1
                                                ? Colors.white
                                                : context.iconColor,
                                        selected:
                                            searchController.facilityType == 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        backgroundColor:
                                            context.theme.backgroundColor,
                                        label: Row(
                                          children: [
                                            // SizedBox(
                                            //   height: 25,
                                            //   width: 25,
                                            //   child: Image.asset(
                                            //     "assets/restaurant.png",
                                            //   ),
                                            // ),
                                            // const SizedBox(
                                            //   width: 5,
                                            // ),
                                            Text(
                                              "Restoranlar",
                                              style: GoogleFonts.quicksand(
                                                fontSize: 16,
                                                fontWeight: searchController
                                                            .facilityType ==
                                                        1
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: searchController
                                                            .facilityType ==
                                                        1
                                                    ? Colors.white
                                                    : context.iconColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onSelected: (bool status) {
                                          if (status) {
                                            searchController
                                                .filterRestaurantType(1);
                                          } else {
                                            searchController
                                                .filterRestaurantType(0);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    IgnorePointer(
                                      ignoring: controller
                                              .loadingGetNearRestaurant ||
                                          controller.loadingRestaurantType ||
                                          controller.facilityType == 3,
                                      child: FilterChip(
                                        avatar: controller
                                                    .loadingRestaurantType &&
                                                controller.facilityType == 3
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )
                                            : SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Image.asset(
                                                  "assets/hotel.png",
                                                ),
                                              ),
                                        selectedColor: Colors.green[500],
                                        checkmarkColor:
                                            searchController.facilityType == 3
                                                ? Colors.white
                                                : context.iconColor,
                                        selected:
                                            searchController.facilityType == 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        backgroundColor:
                                            context.theme.backgroundColor,
                                        label: Row(
                                          children: [
                                            // SizedBox(
                                            //   height: 25,
                                            //   width: 25,
                                            //   child: Image.asset(
                                            //     "assets/hotel.png",
                                            //   ),
                                            // ),
                                            // const SizedBox(
                                            //   width: 5,
                                            // ),
                                            Text(
                                              "Hotellər",
                                              style: GoogleFonts.quicksand(
                                                fontSize: 16,
                                                fontWeight: searchController
                                                            .facilityType ==
                                                        3
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: searchController
                                                            .facilityType ==
                                                        3
                                                    ? Colors.white
                                                    : context.iconColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onSelected: (bool status) {
                                          if (status) {
                                            searchController
                                                .filterRestaurantType(3);
                                          } else {
                                            searchController
                                                .filterRestaurantType(0);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    IgnorePointer(
                                      ignoring: controller
                                              .loadingGetNearRestaurant ||
                                          controller.loadingRestaurantType ||
                                          controller.facilityType == 2,
                                      child: FilterChip(
                                        avatar: controller
                                                    .loadingRestaurantType &&
                                                controller.facilityType == 2
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )
                                            : SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Image.asset(
                                                  "assets/burger.png",
                                                ),
                                              ),
                                        selectedColor: Colors.green[500],
                                        checkmarkColor:
                                            searchController.facilityType == 2
                                                ? Colors.white
                                                : context.iconColor,
                                        selected:
                                            searchController.facilityType == 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        backgroundColor:
                                            context.theme.backgroundColor,
                                        label: Row(
                                          children: [
                                            // SizedBox(
                                            //   height: 25,
                                            //   width: 25,
                                            //   child: Image.asset(
                                            //     "assets/burger.png",
                                            //   ),
                                            // ),
                                            // const SizedBox(
                                            //   width: 5,
                                            // ),
                                            Text(
                                              "FastFood",
                                              style: GoogleFonts.quicksand(
                                                fontSize: 16,
                                                fontWeight: searchController
                                                            .facilityType ==
                                                        2
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: searchController
                                                            .facilityType ==
                                                        2
                                                    ? Colors.white
                                                    : context.iconColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onSelected: (bool status) {
                                          if (status) {
                                            searchController
                                                .filterRestaurantType(2);
                                          } else {
                                            searchController
                                                .filterRestaurantType(0);
                                          }
                                        },
                                      ),
                                    ),
                                    const VerticalDivider(),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      // if (searchController.adWidget != null)
                      //   SizedBox(
                      //     height: 600,
                      //     width: 300,
                      //     child: searchController.adWidget!,
                      //   ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      GetBuilder<SearchController>(
                        builder: (controller) {
                          if (controller.restaurants.isNotEmpty) {
                            if (searchController.isSearch) {
                              return Obx(
                                () {
                                  if (searchController.searching.isTrue) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          LottieBuilder.asset(
                                            "assets/searchinganimation.json",
                                          ),
                                          Text(
                                            "Axtarılır...",
                                            style: GoogleFonts.quicksand(
                                              fontSize: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    if (searchController.searchResults !=
                                        null) {
                                      if (searchController
                                          .searchResults!.empty) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            //mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                "assets/nosearchresultblack.png",
                                                scale: 4,
                                                color: context.iconColor,
                                              ),
                                              Text(
                                                "Nəticə tapılmadı",
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 30),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        if (controller.searchResults!.index ==
                                            "Restaurants") {
                                          return Column(
                                            children: [
                                              // Text(
                                              //   "Axtarış Nəticəsi",
                                              //   style: GoogleFonts.quicksand(
                                              //       fontSize: 22,
                                              //       fontWeight: FontWeight.bold),
                                              // ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 2,
                                                ),
                                                child: GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: controller
                                                      .searchResults!
                                                      .hits
                                                      .length,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 2,
                                                  ),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: context.theme
                                                            .backgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          onTap: () {
                                                            Get.to(
                                                              () =>
                                                                  RestaurantPage(
                                                                restaurantId: controller
                                                                    .searchResults!
                                                                    .hits[index]
                                                                    .data["restaurantId"],
                                                              ),
                                                              preventDuplicates:
                                                                  false,
                                                              transition:
                                                                  Transition
                                                                      .size,
                                                            );
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Stack(
                                                                  fit: StackFit
                                                                      .expand,
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(5),
                                                                        topRight:
                                                                            Radius.circular(5),
                                                                      ),
                                                                      child: controller
                                                                          .defineRestaurantImage(
                                                                        controller
                                                                            .searchResults!
                                                                            .hits[index]
                                                                            .data["restaurantImage"],
                                                                        context,
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 10,
                                                                      left: 10,
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        child: controller
                                                                            .defineType(
                                                                          controller
                                                                              .searchResults!
                                                                              .hits[index]
                                                                              .data["facilityType"],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 5,
                                                                      right: 5,
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        child:
                                                                            InkWell(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          onTap:
                                                                              () {
                                                                            Get.bottomSheet(
                                                                              DirectionBottom(
                                                                                latLng: controller.searchResults!.hits[index].data["location"],
                                                                                restaurant: controller.searchResults!.hits[index].data,
                                                                              ),
                                                                              isScrollControlled: true,
                                                                              backgroundColor: context.theme.canvasColor,
                                                                              shape: const RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(20),
                                                                                  topRight: Radius.circular(20),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: context.theme.primaryColor.withOpacity(0.8),
                                                                              borderRadius: BorderRadius.circular(50),
                                                                            ),
                                                                            child:
                                                                                const Padding(
                                                                              padding: EdgeInsets.symmetric(
                                                                                horizontal: 6,
                                                                                vertical: 6,
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.near_me,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: controller.defineOpenedStatus(
                                                                              controller.searchResults!.hits[index].data["openTime"],
                                                                              controller.searchResults!.hits[index].data["closeTime"],
                                                                              controller.searchResults!.hits[index].data["is247"] ?? false,
                                                                            )
                                                                                ? Colors.green
                                                                                : Colors.red,
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                          ),
                                                                          height:
                                                                              10,
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            controller.searchResults!.hits[index].data["restaurantName"],
                                                                            overflow:
                                                                                TextOverflow.visible,
                                                                            maxLines:
                                                                                2,
                                                                            style:
                                                                                GoogleFonts.quicksand(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        } else if (controller
                                                .searchResults!.index ==
                                            "Foods") {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: controller
                                                  .searchResults!.hits.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      5,
                                                    ),
                                                    color: context
                                                        .theme.primaryColor,
                                                  ),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                                  child: Column(
                                                    children: [
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          onTap: () {
                                                            Get.bottomSheet(
                                                              FoodDetail(
                                                                foodId: controller
                                                                    .searchResults!
                                                                    .hits[index]
                                                                    .data[index]!["foodId"],
                                                              ),
                                                              isScrollControlled:
                                                                  true,
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          5),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          5),
                                                                ),
                                                                child: SizedBox(
                                                                  width: 100,
                                                                  height: 100,
                                                                  child: Image
                                                                      .network(
                                                                    controller
                                                                            .searchResults!
                                                                            .hits[index]
                                                                            .data["foodImage"] ??
                                                                        "",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  constraints:
                                                                      const BoxConstraints(
                                                                          maxWidth:
                                                                              150),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        controller.searchResults!.hits[index].data["name"] ??
                                                                            "",
                                                                        style: GoogleFonts.quicksand(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      if (controller
                                                                              .searchResults!
                                                                              .hits[index]
                                                                              .data["isDiscount"] ??
                                                                          false)
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "${controller.searchResults!.hits[index].data["price"] ?? 0} AZN",
                                                                              style: GoogleFonts.quicksand(
                                                                                fontSize: 18,
                                                                                decoration: TextDecoration.lineThrough,
                                                                                color: context.isDarkMode ? Colors.white60 : Colors.black54,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(
                                                                              "${controller.searchResults!.hits[index].data["discountPrice"] ?? 0} AZN",
                                                                              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 18, color: context.iconColor),
                                                                            )
                                                                          ],
                                                                        )
                                                                      else
                                                                        Text(
                                                                          "${controller.searchResults!.hits[index].data["price"] ?? 0} AZN",
                                                                          style: GoogleFonts.quicksand(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 18),
                                                                        )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          // gradient: LinearGradient(
                                                          //     begin: Alignment
                                                          //         .topCenter,
                                                          //     end: Alignment
                                                          //         .bottomCenter,
                                                          //     colors: [
                                                          //       context.isDarkMode
                                                          //           ? Colors
                                                          //               .white70
                                                          //           : Colors
                                                          //               .black87,
                                                          //       context.theme
                                                          //           .primaryColor,
                                                          //     ]),
                                                          color: context
                                                                  .isDarkMode
                                                              ? Colors.black26
                                                              : Colors.white30,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                        width: double.infinity,
                                                        height: 80,
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                          child: InkWell(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            onTap: () {
                                                              Get.to(
                                                                () =>
                                                                    RestaurantPage(
                                                                  restaurantId: controller
                                                                      .searchResults!
                                                                      .hits[
                                                                          index]
                                                                      .data["restaurantId"],
                                                                ),
                                                                transition:
                                                                    Transition
                                                                        .size,
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 10,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(60),
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                60,
                                                                            width:
                                                                                60,
                                                                            child:
                                                                                Image.network(
                                                                              controller.searchResults!.hits[index].data["restaurantImage"],
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          controller
                                                                              .searchResults!
                                                                              .hits[index]
                                                                              .data["restaurantName"],
                                                                          style:
                                                                              GoogleFonts.encodeSans(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                context.iconColor,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .touch_app,
                                                                    color: context
                                                                        .iconColor,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        } else {
                                          return const SizedBox(); //yet nothing, future add usersWidget
                                        }
                                      }
                                    } else {
                                      return const SizedBox();
                                    }
                                  }
                                },
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: StaggeredGridView.countBuilder(
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  crossAxisCount: 2,
                                  padding: EdgeInsets.zero,
                                  itemCount: controller.restaurants.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  staggeredTileBuilder: (int index) =>
                                      controller.restaurants[index]["ads"] ||
                                              index % 3 == 0
                                          ? const StaggeredTile.count(2, 1.8)
                                          : const StaggeredTile.count(1, 1),
                                  itemBuilder: (context, index) {
                                    if (controller.restaurants[index]["ads"]) {
                                      return controller.restaurants[index]
                                          ["widget"];
                                    } else {
                                      return Container(
                                        height: 400,
                                        width: 400,
                                        decoration: BoxDecoration(
                                          color: context.theme.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            onTap: () {
                                              Get.to(
                                                () => RestaurantPage(
                                                  restaurantId: controller
                                                          .restaurants[index]
                                                      ["restaurantId"],
                                                ),
                                                preventDuplicates: false,
                                                transition: Transition.size,
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  0),
                                                          topRight:
                                                              Radius.circular(
                                                                  0),
                                                        ),
                                                        child: controller
                                                            .defineRestaurantImage(
                                                          controller.restaurants[
                                                                  index][
                                                              "restaurantImage"],
                                                          context,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 10,
                                                        left: 10,
                                                        child: SizedBox(
                                                          height: 25,
                                                          width: 25,
                                                          child: controller
                                                              .defineType(
                                                            controller.restaurants[
                                                                        index][
                                                                    "facilityType"] ??
                                                                1,
                                                          ),
                                                        ),
                                                      ),
                                                      if (controller.near)
                                                        Positioned(
                                                          top: 5,
                                                          right: 5,
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              onTap: () {
                                                                GeoPoint geoPoint = GeoPoint(
                                                                    controller.restaurants[index]
                                                                            ["location"]
                                                                        [
                                                                        "_latitude"],
                                                                    controller.restaurants[
                                                                                index]
                                                                            [
                                                                            "location"]
                                                                        [
                                                                        "_longitude"]);
                                                                Get.bottomSheet(
                                                                  DirectionBottom(
                                                                    latLng:
                                                                        geoPoint,
                                                                    restaurant:
                                                                        controller
                                                                            .restaurants[index],
                                                                  ),
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      context
                                                                          .theme
                                                                          .canvasColor,
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: context
                                                                      .theme
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 6,
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "${(controller.restaurants[index]["distance"] / 1000).toStringAsFixed(1)} km",
                                                                        style: GoogleFonts
                                                                            .quicksand(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .near_me,
                                                                        color: Colors
                                                                            .red,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      else
                                                        Positioned(
                                                          top: 5,
                                                          right: 5,
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              onTap: () {
                                                                bool fromPins =
                                                                    controller.restaurants[index]
                                                                            [
                                                                            "fromPins"] ??
                                                                        false;
                                                                GeoPoint
                                                                    geoPoint;
                                                                if (fromPins) {
                                                                  geoPoint = GeoPoint(
                                                                      controller.restaurants[index]
                                                                              [
                                                                              "location"]
                                                                          [
                                                                          "_latitude"],
                                                                      controller
                                                                              .restaurants[index]["location"]
                                                                          [
                                                                          "_longitude"]);
                                                                } else {
                                                                  geoPoint = controller
                                                                              .restaurants[
                                                                          index]
                                                                      [
                                                                      "location"];
                                                                }
                                                                Get.bottomSheet(
                                                                  DirectionBottom(
                                                                    latLng:
                                                                        geoPoint,
                                                                    restaurant:
                                                                        controller
                                                                            .restaurants[index],
                                                                  ),
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      context
                                                                          .theme
                                                                          .canvasColor,
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: context
                                                                      .theme
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                ),
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical: 6,
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .near_me,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: controller
                                                                      .defineOpenedStatus(
                                                                controller.restaurants[
                                                                        index][
                                                                    "openTime"],
                                                                controller.restaurants[
                                                                        index][
                                                                    "closeTime"],
                                                                controller.restaurants[
                                                                            index]
                                                                        [
                                                                        "is247"] ??
                                                                    false,
                                                              )
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                10,
                                                              ),
                                                            ),
                                                            height: 10,
                                                            width: 10,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              controller.restaurants[
                                                                      index][
                                                                  "restaurantName"],
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              maxLines: 2,
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            }
                          } else {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/nosearchresultblack.png",
                                    scale: 4,
                                    color: context.iconColor,
                                  ),
                                  Text(
                                    "Nəticə tapılmadı",
                                    style: GoogleFonts.quicksand(fontSize: 30),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // if (!searchController.isSearch && !searchController.near)
            GetBuilder<SearchController>(
              id: "loadingMore",
              builder: (controller) {
                if (controller.loadingMore) {
                  return Container(
                    height: 60,
                    width: double.infinity,
                    color: context.theme.primaryColor,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: context.iconColor,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Yeni Restoranlar yüklənir",
                            style: GoogleFonts.encodeSans(),
                          )
                        ]),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
