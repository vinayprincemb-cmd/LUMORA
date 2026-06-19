// onboarding_screen.dart
// ✅ PREMIUM EMOTIONAL UI
// ✅ CONNECTED TO SPLASH SCREEN
// ✅ SKIP BUTTON
// ✅ SMOOTH PAGEVIEW
// ✅ ENTER HOME SCREEN
// ✅ NO EMPTY BACKGROUND
// ✅ STABLE VERSION
// ✅ ENHANCED ANIMATIONS & TRANSITIONS

import 'package:flutter/material.dart';

import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController
      _pageController =
      PageController();

  int currentPage = 0;

  late AnimationController
      _buttonController;
  late AnimationController
      _pageAnimController;

  final List<Map<String, String>>
      pages = [
    {
      "emoji": "💌",
      "title":
          "Write To Your Future Self",
      "subtitle":
          "Save emotions, dreams and thoughts beautifully through time.",
    },
    {
      "emoji": "🔒",
      "title":
          "Locked Emotional Vaults",
      "subtitle":
          "Your memories unlock exactly when your future self needs them.",
    },
    {
      "emoji": "✨",
      "title":
          "Reconnect With Your Growth",
      "subtitle":
          "Experience forgotten emotions and rediscover your journey.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _buttonController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );

    _pageAnimController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );

    _pageAnimController.forward();
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _pageAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage <
        pages.length - 1) {
      _pageController.nextPage(
        duration:
            const Duration(
          milliseconds: 500,
        ),
        curve: Curves.easeInOutCubic,
      );
      // Animate page transition
      _pageAnimController.reset();
      _pageAnimController.forward();
    } else {
      openHome();
    }
  }

  void openHome() {
    _buttonController
        .forward()
        .then((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration:
              const Duration(
            milliseconds: 900,
          ),
          pageBuilder: (_,
              animation,
              secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(
                  0,
                  1,
                ),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves
                      .easeOutCubic,
                ),
              ),
              child:
                  const HomeScreen(),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F0FF),

      body: Stack(
        children: [
          // PARALLAX BACKGROUND GLOWS
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              height: 320,
              width: 320,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color: Colors
                    .deepPurple
                    .withOpacity(
                  0.08,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -140,
            right: -120,
            child: Container(
              height: 360,
              width: 360,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color: Colors
                    .purple
                    .withOpacity(
                  0.05,
                ),
              ),
            ),
          ),

          Positioned(
            top: 250,
            right: -50,
            child: Container(
              height: 160,
              width: 160,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color: Colors.white
                    .withOpacity(
                  0.25,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                24,
              ),
              child: Column(
                children: [
                  // TOP BAR WITH ANIMATIONS
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      // Logo with fade-in
                      FadeTransition(
                        opacity:
                            _pageAnimController,
                        child:
                            const Text(
                          "LUMORA",
                          style:
                              TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight
                                    .w900,
                            color: Color(
                              0xFF24124D,
                            ),
                          ),
                        ),
                      ),

                      // Skip button with hover effect
                      ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.8,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent:
                                _pageAnimController,
                            curve: Curves
                                .easeOut,
                          ),
                        ),
                        child:
                            TextButton(
                          onPressed:
                              openHome,
                          child:
                              const Text(
                            "Skip",
                            style:
                                TextStyle(
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color:
                                  Color(
                                0xFF5D2DE1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // PAGE VIEW WITH CUSTOM TRANSITION
                  Expanded(
                    child:
                        PageView.builder(
                      controller:
                          _pageController,

                      itemCount:
                          pages.length,

                      onPageChanged:
                          (index) {
                        setState(() {
                          currentPage =
                              index;
                        });
                        _pageAnimController
                            .reset();
                        _pageAnimController
                            .forward();
                      },

                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        final page =
                            pages[index];

                        return FadeTransition(
                          opacity:
                              _pageAnimController,
                          child:
                              SlideTransition(
                            position: Tween<
                                Offset>(
                              begin:
                                  const Offset(
                                0.3,
                                0,
                              ),
                              end: Offset
                                  .zero,
                            ).animate(
                              CurvedAnimation(
                                parent:
                                    _pageAnimController,
                                curve: Curves
                                    .easeOutCubic,
                              ),
                            ),
                            child:
                                ScaleTransition(
                              scale: Tween<
                                  double>(
                                begin: 0.8,
                                end: 1.0,
                              ).animate(
                                CurvedAnimation(
                                  parent:
                                      _pageAnimController,
                                  curve: Curves
                                      .elasticOut,
                                ),
                              ),
                              child:
                                  Column(
                                children: [
                                  const Spacer(),

                                  // ANIMATED EMOJI CONTAINER
                                  _buildAnimatedEmojiContainer(
                                    page[
                                        "emoji"]!,
                                  ),

                                  const SizedBox(
                                    height:
                                        55,
                                  ),

                                  // ANIMATED TITLE
                                  _buildAnimatedTitle(
                                    page[
                                        "title"]!,
                                  ),

                                  const SizedBox(
                                    height:
                                        22,
                                  ),

                                  // ANIMATED SUBTITLE
                                  _buildAnimatedSubtitle(
                                    page[
                                        "subtitle"]!,
                                  ),

                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ANIMATED INDICATORS
                  _buildAnimatedIndicators(),

                  const SizedBox(
                    height: 34,
                  ),

                  // ANIMATED BUTTON
                  _buildAnimatedButton(),

                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget
      _buildAnimatedEmojiContainer(
    String emoji,
  ) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent:
              _pageAnimController,
          curve: const Interval(
            0.0,
            0.6,
            curve: Curves.elasticOut,
          ),
        ),
      ),
      child: RotationTransition(
        turns: Tween<double>(
          begin: -0.2,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent:
                _pageAnimController,
            curve: Curves.easeOut,
          ),
        ),
        child: Container(
          height: 180,
          width: 180,
          decoration:
              BoxDecoration(
            gradient:
                const LinearGradient(
              begin: Alignment.topLeft,
              end:
                  Alignment.bottomRight,
              colors: [
                Color(0xFF5D2DE1),
                Color(0xFFB388FF),
              ],
            ),
            borderRadius:
                BorderRadius.circular(
              46,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 40,
                offset: const Offset(
                  0,
                  18,
                ),
                color: Colors
                    .deepPurple
                    .withOpacity(
                  0.25,
                ),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 76,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget
      _buildAnimatedTitle(
    String title,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent:
              _pageAnimController,
          curve: const Interval(
            0.2,
            0.7,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent:
              _pageAnimController,
          curve: const Interval(
            0.2,
            0.7,
            curve: Curves.easeIn,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            height: 1.3,
            fontWeight:
                FontWeight.w900,
            color: Color(0xFF24124D),
          ),
        ),
      ),
    );
  }

  Widget
      _buildAnimatedSubtitle(
    String subtitle,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent:
              _pageAnimController,
          curve: const Interval(
            0.3,
            0.8,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent:
              _pageAnimController,
          curve: const Interval(
            0.3,
            0.8,
            curve: Curves.easeIn,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets
                  .symmetric(
            horizontal: 12,
          ),
          child: Text(
            subtitle,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              height: 1.8,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget
      _buildAnimatedIndicators() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        pages.length,
        (index) {
          final active =
              currentPage == index;

          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.7,
              end: active ? 1.2 : 1.0,
            ).animate(
              CurvedAnimation(
                parent:
                    _pageAnimController,
                curve: Curves.elasticOut,
              ),
            ),
            child: AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 400,
              ),
              margin:
                  const EdgeInsets.only(
                right: 8,
              ),
              width: active ? 28 : 10,
              height: 10,
              decoration:
                  BoxDecoration(
                color: active
                    ? const Color(
                        0xFF5D2DE1,
                      )
                    : Colors
                        .deepPurple
                        .withOpacity(
                        0.2,
                      ),
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          blurRadius:
                              12,
                          offset:
                              const Offset(
                            0,
                            6,
                          ),
                          color: Colors
                              .deepPurple
                              .withOpacity(
                            0.3,
                          ),
                        ),
                      ]
                    : [],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget
      _buildAnimatedButton() {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent:
              _pageAnimController,
          curve: const Interval(
            0.4,
            0.9,
            curve: Curves.elasticOut,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: nextPage,
          splashColor: Colors.white
              .withOpacity(0.3),
          highlightColor: Colors.white
              .withOpacity(0.1),
          borderRadius:
              BorderRadius.circular(
            28,
          ),
          child: Container(
            width:
                double.infinity,
            padding:
                const EdgeInsets
                    .symmetric(
              vertical: 20,
            ),
            decoration:
                BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xFF5D2DE1),
                  Color(0xFFB388FF),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(
                28,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 26,
                  offset:
                      const Offset(
                    0,
                    14,
                  ),
                  color: Colors
                      .deepPurple
                      .withOpacity(
                    0.22,
                  ),
                ),
              ],
            ),
            child: Center(
              child: AnimatedBuilder(
                animation:
                    _buttonController,
                builder:
                    (context, child) {
                  return Opacity(
                    opacity: 1.0 -
                        _buttonController
                            .value,
                    child: Text(
                      currentPage ==
                              pages
                                  .length -
                                  1
                          ? "Begin Journey ✨"
                          : "Continue",
                      style:
                          const TextStyle(
                        color: Colors
                            .white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight
                                .bold,
                        letterSpacing:
                            0.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
