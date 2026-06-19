// splash_screen.dart
// ✅ PREMIUM TITLE SCREEN
// ✅ EMOTIONAL ATMOSPHERE
// ✅ ANIMATED GLOW
// ✅ AUTO NAVIGATION
// ✅ STABLE VERSION
// ✅ LUMORA BRANDING
// ✅ ENHANCED ANIMATIONS & TRANSITIONS

import 'dart:async';

import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController
      _fadeController;
  late AnimationController
      _logoController;
  late AnimationController
      _glowController;
  late AnimationController
      _textController;

  late Animation<double>
      fadeAnimation;
  late Animation<double>
      scaleAnimation;
  late Animation<double>
      rotateAnimation;
  late Animation<double>
      glowAnimation;
  late Animation<Offset>
      titleSlideAnimation;
  late Animation<double>
      subtitleFadeAnimation;
  late Animation<double>
      quoteFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Main fade & scale controller
    _fadeController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1600,
      ),
    );

    // Logo rotation controller
    _logoController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 4000,
      ),
    )..repeat();

    // Glow pulse controller
    _glowController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ),
    )..repeat(reverse: true);

    // Text stagger controller
    _textController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2200,
      ),
    );

    // Fade animation
    fadeAnimation =
        CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Scale animation with bounce
    scaleAnimation =
        Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.elasticOut,
      ),
    );

    // Continuous rotation
    rotateAnimation =
        Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.linear,
      ),
    );

    // Glow pulse
    glowAnimation =
        Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    // Title slide from left
    titleSlideAnimation =
        Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.4,
            curve: Curves.easeOut),
      ),
    );

    // Subtitle fade
    subtitleFadeAnimation =
        Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 0.6,
            curve: Curves.easeIn),
      ),
    );

    // Quote fade with delay
    quoteFadeAnimation =
        Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0,
            curve: Curves.easeIn),
      ),
    );

    _fadeController.forward();
    _textController.forward();

    Timer(
      const Duration(seconds: 4),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration:
                const Duration(
              milliseconds: 800,
            ),
            pageBuilder: (_,
                animation,
                secondaryAnimation) =>
                FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(
                    1,
                    0,
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
                    const OnboardingScreen(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _logoController.dispose();
    _glowController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F0FF),

      body: Stack(
        children: [
          // ANIMATED BACKGROUND GLOWS
          Positioned(
            top: -120,
            left: -100,
            child: AnimatedBuilder(
              animation: glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 280,
                  height: 280,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color: const Color(
                      0xFFB388FF,
                    ).withOpacity(
                      0.18 *
                          glowAnimation
                              .value,
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: -150,
            right: -120,
            child: AnimatedBuilder(
              animation: glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 340,
                  height: 340,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color: const Color(
                      0xFF5D2DE1,
                    ).withOpacity(
                      0.10 *
                          glowAnimation
                              .value,
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 240,
            right: -40,
            child: AnimatedBuilder(
              animation: glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 140,
                  height: 140,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color: Colors.white
                        .withOpacity(
                      0.25 *
                          glowAnimation
                              .value,
                    ),
                  ),
                );
              },
            ),
          ),

          // MAIN CONTENT
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity:
                    fadeAnimation,
                child: Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      // ANIMATED LOGO CONTAINER
                      ScaleTransition(
                        scale:
                            scaleAnimation,
                        child:
                            RotationTransition(
                          turns:
                              rotateAnimation,
                          child:
                              Container(
                            height: 150,
                            width: 150,
                            decoration:
                                BoxDecoration(
                              gradient:
                                  const LinearGradient(
                                begin: Alignment
                                    .topLeft,
                                end: Alignment
                                    .bottomRight,
                                colors: [
                                  Color(
                                    0xFF5D2DE1,
                                  ),
                                  Color(
                                    0xFFB388FF,
                                  ),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                40,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius:
                                      40,
                                  offset:
                                      const Offset(
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
                            child:
                                const Center(
                              child: Text(
                                "💜",
                                style:
                                    TextStyle(
                                  fontSize:
                                      64,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 42,
                      ),

                      // ANIMATED TITLE
                      SlideTransition(
                        position:
                            titleSlideAnimation,
                        child:
                            ScaleTransition(
                          scale:
                              scaleAnimation,
                          child:
                              const Text(
                            "LUMORA",
                            style:
                                TextStyle(
                              fontSize: 46,
                              fontWeight:
                                  FontWeight
                                      .w900,
                              letterSpacing:
                                  2,
                              color: Color(
                                0xFF24124D,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      // ANIMATED SUBTITLE
                      FadeTransition(
                        opacity:
                            subtitleFadeAnimation,
                        child:
                            ScaleTransition(
                          scale:
                              scaleAnimation,
                          child:
                              const Text(
                            "Messages Through Time ✨",
                            textAlign:
                                TextAlign
                                    .center,
                            style:
                                TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .w500,
                              color: Colors
                                  .black54,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 46,
                      ),

                      // ANIMATED QUOTE
                      FadeTransition(
                        opacity:
                            quoteFadeAnimation,
                        child:
                            ScaleTransition(
                          scale:
                              scaleAnimation,
                          child:
                              Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  26,
                              vertical:
                                  24,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .white
                                  .withOpacity(
                                0.7,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                28,
                              ),
                              border:
                                  Border.all(
                                color: Colors
                                    .deepPurple
                                    .withOpacity(
                                  0.1,
                                ),
                                width: 2,
                              ),
                            ),
                            child:
                                const Text(
                              "Some words are meant for the future version of you.",
                              textAlign:
                                  TextAlign
                                      .center,
                              style:
                                  TextStyle(
                                fontSize: 17,
                                height: 1.8,
                                fontStyle:
                                    FontStyle
                                        .italic,
                                color: Color(
                                  0xFF24124D,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 60,
                      ),

                      // ANIMATED LOADING INDICATOR
                      FadeTransition(
                        opacity:
                            quoteFadeAnimation,
                        child: _buildAnimatedLoader(),
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
  }

  // Custom animated loader
  Widget
      _buildAnimatedLoader() {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 8,
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              minHeight: 6,
              backgroundColor:
                  const Color(0xFFE6DAFF),
              valueColor:
                  const AlwaysStoppedAnimation(
                Color(0xFF5D2DE1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: List.generate(
            3,
            (index) {
              return AnimatedBuilder(
                animation:
                    _fadeController,
                builder:
                    (context, child) {
                  final delay =
                      index * 0.2;
                  final progress =
                      _fadeController
                          .value;
                  final opacity =
                      ((progress -
                              delay)
                          .clamp(0.0,
                              1.0))
                          .toDouble();

                  return Container(
                    margin:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 4,
                    ),
                    width: 10,
                    height: 10,
                    decoration:
                        BoxDecoration(
                      shape: BoxShape
                          .circle,
                      color: const Color(
                        0xFF5D2DE1,
                      ).withOpacity(
                        opacity,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
