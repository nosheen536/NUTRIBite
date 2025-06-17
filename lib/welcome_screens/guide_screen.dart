// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int _currentPage = 0;
//   late Timer _timer;

//   final List<Map<String, dynamic>> _pages = [
//     {
//       "type": "welcome",
//       "title": "Welcome to NutriBite!",
//       "subtitle1": "Healthy Eating, Made Real & Easy!",
//       "subtitle2": "Discover healthy meal plans tailored for you",
//       "image": "assets/images/strawberytoast.png",
//     },
//     {
//       "type": "normal",
//       "title": "Nutrition & Meal Guidance!",
//       "subtitle": "Learn. Eat. Transform!",
//       "bullets": [
//         "Get accurate nutritional insights on each recipe.",
//         "Read myth-busting articles on health & wellness.",
//         "Receive hydration reminders & progress tracking.",
//       ],
//       "animation": "assets/animations/guidescreenanimation.json",
//     },
//     {
//       "type": "dietPlan",
//       "title": "Say Goodbye to unrealistic diet plans!",
//       "subtitle1": "NUTRIBite helps you achieve your health goals",
//       "subtitle2": "Balanced, culturally relevant meal plans tailored for you",
//       //"buttonText": "Next",
//       "image": "assets/images/teapot.png",
//     },
//     {
//       "type": "dietPlan",
//       "title": "Structured Plans OR \nExplore Recipes – Your Choice!",
//       "subtitle1":
//           "Follow a goal-based meal plan (Weight Loss, Muscle Gain, Balanced Diet).",
//       "subtitle2": [
//         "Get ingredient substitutions & nutrition insights for better choices.",
//       ],
//       //"buttonText": "Next",
//       "image": "assets/images/veggies.png",
//     },
//     {
//       "type": "dietPlan",
//       "title": "Start Your Healthy Journey!",
//       "subtitle1": "Your Health, Your Way!",
//       "subtitle2":
//           "Join NutriBite and start eating healthier, tastier, and smarter—with real, balanced meal plans made for YOU.",
//       "buttonText": "Get Started",
//       "image": "assets/images/orangegreenplate.png",
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     //_currentPage = 0;
//     _startAutoScroll();
//   }

//   void _startAutoScroll() {
//     _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
//       if (_currentPage < _pages.length - 1) {
//         _currentPage++;
//         _controller.animateToPage(
//           _currentPage,
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.easeInOut,
//         );
//       } else {
//         _timer.cancel();
//         Navigator.pushReplacementNamed(context, '/signup');
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   Widget mediaWidget(
//     Map<String, dynamic> page,
//     double screenWidth,
//     double screenHeight,
//   ) {
//     if (page.containsKey("animation")) {
//       return Lottie.asset(
//         page["animation"],
//         width: screenWidth * 0.15,
//         height: screenHeight * 0.9,
//         fit: BoxFit.contain,
//       );
//     } else if (page.containsKey("image")) {
//       return Image.asset(
//         page["image"],
//         width: screenWidth * 0.8,
//         height: screenHeight * 0.4,
//         fit: BoxFit.cover,
//         filterQuality: FilterQuality.high,
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size screen = MediaQuery.of(context).size;

//     return Scaffold(
    
//       body: Container(
//         decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color.fromRGBO(245, 255, 235, 1),
//                     Color.fromRGBO(210, 235, 175, 1),
//                   ],
//                 ),
//               ),
//        child: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 controller: _controller,
//                 itemCount: _pages.length,
//                 onPageChanged: (index) => setState(() => _currentPage = index),
//                 itemBuilder: (context, index) {
//                   final page = _pages[index];

//                   if (page["type"] == "welcome") {
//                     return Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         Column(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: Container(color: const Color(0xFFE5F6E5)),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child: mediaWidget(
//                                 page,
//                                 screen.width,
//                                 screen.height,
//                               ),
//                             ),
//                           ],
//                         ),
//                         /*   BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
//                           child: Container(
//                             color: const Color.fromRGBO(217, 233, 193, 0.50),
//                           ),
//                         ),*/
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 children: [
//                                   const SizedBox(height: 80),
//                                   Text(
//                                     page["title"],
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       fontSize: 30,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 30),
//                                   Text(
//                                     page["subtitle1"],
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       fontSize: 23,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 25),
//                                   Text(
//                                     page["subtitle2"],
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   } else if (page["type"] == "normal") {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 24),
//                           Text(
//                             page["title"],
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             page["subtitle"],
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           ...List.generate(page["bullets"].length, (i) {
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 6),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     "• ",
//                                     style: TextStyle(fontSize: 24),
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                       page["bullets"][i],
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                           const SizedBox(height: 24),
//                           Expanded(
//                             child: mediaWidget(
//                               page,
//                               screen.width * 0.7,
//                               screen.height,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else if (page["type"] == "dietPlan") {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 40,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 page["title"],
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               Text(
//                                 page["subtitle1"],
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               if (page["subtitle2"] is List)
//                                 ...List.generate(page["subtitle2"].length, (i) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 6,
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           "• ",
//                                           style: TextStyle(fontSize: 20),
//                                         ),
//                                         Expanded(
//                                           child: Text(
//                                             page["subtitle2"][i],
//                                             style: const TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 })
//                               else
//                                 Text(
//                                   page["subtitle2"],
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           mediaWidget(page, screen.width * 0.7, screen.height),
//                           if (page.containsKey("buttonText"))
//                             ElevatedButton(
//                               onPressed: () {
//                                 if (_currentPage < _pages.length - 1) {
//                                   _controller.nextPage(
//                                     duration: const Duration(milliseconds: 600),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 } else {
//                                   Navigator.pushReplacementNamed(
//                                     context,
//                                     '/signup',
//                                   );
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color.fromRGBO(
//                                   186,
//                                   216,
//                                   135,
//                                   1,
//                                 ),
//                                 fixedSize: const Size(150, 50),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                               ),
//                               child: Text(
//                                 page["buttonText"] ?? "Next",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     );
//                   }

//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 24),
//               child: SmoothPageIndicator(
//                 controller: _controller,
//                 count: _pages.length,
//                 effect: const ExpandingDotsEffect(
//                   dotHeight: 10,
//                   dotWidth: 10,
//                   spacing: 8,
//                   activeDotColor: Colors.green,
//                   dotColor: Colors.black26,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       )
//     );
//   }
// }
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _pages = [
    {
      "type": "welcome",
      "title": "Welcome to NutriBite!",
      "subtitle1": "Healthy Eating, Made Real & Easy!",
      "subtitle2": "Discover healthy meal plans tailored for you",
      "image": "assets/images/strawberytoast.png",
    },
    {
      "type": "normal",
      "title": "Nutrition & Meal Guidance!",
      "subtitle": "Learn. Eat. Transform!",
      "bullets": [
        "Get accurate nutritional insights on each recipe.",
        "Read myth-busting articles on health & wellness.",
        "Receive hydration reminders & progress tracking.",
      ],
      "animation": "assets/animations/guidescreenanimation.json",
    },
    {
      "type": "dietPlan",
      "title": "Say Goodbye to unrealistic diet plans!",
      "subtitle1": "NUTRIBite helps you achieve your health goals",
      "subtitle2": "Balanced, culturally relevant meal plans tailored for you",
      "image": "assets/images/teapot.png",
    },
    {
      "type": "dietPlan",
      "title": "Structured Plans OR \nExplore Recipes – Your Choice!",
      "subtitle1":
          "Follow a goal-based meal plan (Weight Loss, Muscle Gain, Balanced Diet).",
      "subtitle2": [
        "Get ingredient substitutions & nutrition insights for better choices.",
      ],
      "image": "assets/images/veggies.png",
    },
    {
      "type": "dietPlan",
      "title": "Start Your Healthy Journey!",
      "subtitle1": "Your Health, Your Way!",
      "subtitle2":
          "Join NutriBite and start eating healthier, tastier, and smarter—with real, balanced meal plans made for YOU.",
      "buttonText": "Get Started",
      "image": "assets/images/orangegreenplate.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
        // DO NOT navigate to signup automatically anymore
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget mediaWidget(
    Map<String, dynamic> page,
    double screenWidth,
    double screenHeight,
  ) {
    if (page.containsKey("animation")) {
      return Lottie.asset(
        page["animation"],
        width: screenWidth * 0.90,
        height: screenHeight * 0.90,
        fit: BoxFit.contain,
      );
    } else if (page.containsKey("image")) {
      return Image.asset(
        page["image"],
        width: screenWidth * 0.8,
        height: screenHeight * 0.3,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(245, 255, 235, 1),
              Color.fromRGBO(210, 235, 175, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final page = _pages[index];

                    if (page["type"] == "welcome") {
                      return Container(
                       decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(245, 255, 235, 1),
              Color.fromRGBO(210, 235, 175, 1),
            ],
          ),
        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 80),
                              Text(
                                page["title"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                page["subtitle1"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Text(
                                page["subtitle2"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 80),
                              mediaWidget(page, screen.width, screen.height),
                            ],
                          ),
                        ),
                      );
                    } else if (page["type"] == "normal") {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            Text(
                              page["title"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              page["subtitle"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ...List.generate(page["bullets"].length, (i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• ", style: TextStyle(fontSize: 24)),
                                    Expanded(
                                      child: Text(
                                        page["bullets"][i],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 24),
                            Expanded(
                              child: mediaWidget(
                                page,
                                screen.width ,
                                screen.height,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (page["type"] == "dietPlan") {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  page["title"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  page["subtitle1"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (page["subtitle2"] is List)
                                  ...List.generate(page["subtitle2"].length, (i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("• ", style: TextStyle(fontSize: 20)),
                                          Expanded(
                                            child: Text(
                                              page["subtitle2"][i],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                else
                                  Text(
                                    page["subtitle2"],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            mediaWidget(page, screen.width *0.7, screen.height),
                            if (page.containsKey("buttonText"))
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/signup');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                                  fixedSize: const Size(150, 50),
                                   side: const BorderSide(color: Colors.black, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Text(
                                  page["buttonText"] ?? "Next",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 61, 61, 61),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8,
                    activeDotColor: Colors.green,
                    dotColor: Colors.black26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
