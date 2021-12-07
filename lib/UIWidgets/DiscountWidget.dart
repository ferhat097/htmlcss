// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../FoodMoodLogo.dart';

// class DiscountWidget extends StatefulWidget {
//   final String coverPhoto;
//   final String restaurantName;
//   final int menuType;
//   final int durationType;
//   final int maxNumber;
//   const DiscountWidget(
//       {Key? key,
//       required this.coverPhoto,
//       required this.restaurantName,
//       required this.menuType,
//       required this.durationType, required this.maxNumber})
//       : super(key: key);

//   @override
//   _DiscountWidgetState createState() => _DiscountWidgetState();
// }

// class _DiscountWidgetState extends State<DiscountWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         image: DecorationImage(
//           fit: BoxFit.cover,
//           image: NetworkImage(
//             widget.coverPhoto,
//           ),
//         ),
//       ),
//       width: double.infinity,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(5),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
//           child: Material(
//             color: Colors.transparent,
//             borderRadius: BorderRadius.circular(5),
//             child: InkWell(
//               onTap: () {
//                 Get.to(
//                   () => DiscountDetail(
//                     discountId: controller.forYouDiscounts[index].id,
//                   ),
//                 );
//               },
//               child: Stack(
//                 //fit: StackFit.expand,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.white,
//                           Colors.white70,
//                           Colors.transparent
//                         ],
//                       ),
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 40, vertical: 10),
//                         child: foodMoodLogo(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Column(
//                           children: [
//                             Text(
//                               "${widget.restaurantName}'dən",
//                               style: GoogleFonts.quicksand(
//                                   fontWeight: FontWeight.bold,
//                                   // backgroundColor: Colors.red,
//                                   fontSize: 20,
//                                   color: Colors.black),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             widget.menuType == 1
//                                 ? Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     child: Text(
//                                       " bütün menyu'ya ",
//                                       style: GoogleFonts.quicksand(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                           color: Colors.white),
//                                     ),
//                                   )
//                                 : Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     child: Text(
//                                       "seçilmiş yeməklərə",
//                                       style: GoogleFonts.quicksand(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                             Text(
//                               "endirim",
//                               style: GoogleFonts.quicksand(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                   color: Colors.black),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   widget.durationType == 1
//                       ? Positioned(
//                           top: 10,
//                           right: 10,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               gradient: RadialGradient(
//                                 radius: 2,
//                                 colors: Get.isDarkMode
//                                     ? [
//                                         Colors.black38,
//                                         Colors.black26,
//                                         Colors.transparent
//                                       ]
//                                     : [
//                                         Colors.white70,
//                                         Colors.white60,
//                                         Colors.transparent
//                                       ],
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color: Get.isDarkMode
//                                         ? Colors.black
//                                         : Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Icon(Icons.person),
//                                 ),
//                                 Text(
//                                   " ${widget.maxNumber}",
//                                   style: GoogleFonts.quicksand(),
//                                 ),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Positioned(
//                           top: 10,
//                           right: 10,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               gradient: RadialGradient(
//                                 radius: 2,
//                                 colors: Get.isDarkMode
//                                     ? [
//                                         Colors.black38,
//                                         Colors.black26,
//                                         Colors.transparent
//                                       ]
//                                     : [
//                                         Colors.white70,
//                                         Colors.white60,
//                                         Colors.transparent
//                                       ],
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Container(
//                                   height: 25,
//                                   width: 25,
//                                   decoration: BoxDecoration(
//                                     color: Get.isDarkMode
//                                         ? Colors.black
//                                         : Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Icon(
//                                     Icons.date_range_rounded,
//                                     size: 15,
//                                   ),
//                                 ),
//                                 GetBuilder<HomeController>(
//                                   id: "endTime",
//                                   //assignId: true,
//                                   //global: false,
//                                   builder: (controller2) {
//                                     return Text(
//                                       controller.defineEndTime(),
//                                       style: GoogleFonts.quicksand(),
//                                     );
//                                   },
//                                 ),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Transform.rotate(
//                       angle: 5.8,
//                       child: Container(
//                         height: 100,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(200),
//                           gradient: RadialGradient(
//                             colors: [
//                               Colors.black54,
//                               Colors.black12,
//                               Colors.transparent,
//                             ],
//                           ),
//                         ),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Container(
//                               child: Image.asset("assets/discount.png",
//                                   scale: 7, color: Colors.red),
//                             ),
//                             Column(
//                               mainAxisSize: MainAxisSize.max,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "${controller.forYouDiscounts[index].data()!["discount"]}%",
//                                   style: GoogleFonts.quicksand(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 26,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
