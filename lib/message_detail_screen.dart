// message_detail_screen.dart
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class MessageDetailScreen extends StatefulWidget {
  final String message;
  final String date;
  final String? mood;

  const MessageDetailScreen({
    super.key,
    required this.message,
    required this.date,
    this.mood,
  });

  @override
  State<MessageDetailScreen> createState() =>
      _MessageDetailScreenState();
}

class _MessageDetailScreenState
    extends State<MessageDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController
      _fadeController;

  late AnimationController
      _cardController;

  late Animation<double>
      _fadeAnimation;

  late Animation<double>
      _scaleAnimation;

  String displayedText = '';

  int currentIndex = 0;

  Timer? typingTimer;

  final List<Offset> particles = List.generate(
    18,
    (index) => Offset(
      (index * 23).toDouble(),
      (index * 41).toDouble(),
    ),
  );

  @override
  void initState() {
    super.initState();

    HapticFeedback.mediumImpact();

    _fadeController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    );

    _cardController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 900,
      ),
    );

    _fadeAnimation =
        CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _scaleAnimation =
        Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeController.forward();

    Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
      () {
        _cardController.forward();
      },
    );

    Future.delayed(
      const Duration(
        milliseconds: 900,
      ),
      () {
        startTypingAnimation();
      },
    );
  }

  void startTypingAnimation() {
    typingTimer = Timer.periodic(
      const Duration(
        milliseconds: 26,
      ),
      (timer) {
        if (currentIndex <
            widget.message.length) {
          setState(() {
            displayedText +=
                widget.message[
                    currentIndex];

            currentIndex++;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    typingTimer?.cancel();

    _fadeController.dispose();

    _cardController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(
      DateTime.parse(widget.date),
    );

    // Mood-based color logic
    Color backgroundColor = const Color(0xFFF5F0FF);
    Color glowColor1 = Colors.deepPurple.withOpacity(0.08);
    Color glowColor2 = Colors.purple.withOpacity(0.05);
    String? mood = widget.mood;
    if (mood != null) {
      switch (mood) {
        case "Hopeful":
          backgroundColor = const Color(0xFFEEF3FF);
          glowColor1 = const Color(0xFF6A8DFF).withOpacity(0.10);
          glowColor2 = const Color(0xFF9EAFFF).withOpacity(0.08);
          break;
        case "Motivational":
          backgroundColor = const Color(0xFFFFF3E0);
          glowColor1 = const Color(0xFFFF8A65).withOpacity(0.10);
          glowColor2 = const Color(0xFFFFB74D).withOpacity(0.08);
          break;
        case "Romantic":
          backgroundColor = const Color(0xFFFFF0F6);
          glowColor1 = const Color(0xFFFF5C8D).withOpacity(0.10);
          glowColor2 = const Color(0xFFFF9EB5).withOpacity(0.08);
          break;
        case "Healing":
          backgroundColor = const Color(0xFFEDEBFF);
          glowColor1 = const Color(0xFF5C6BC0).withOpacity(0.10);
          glowColor2 = const Color(0xFF8E99F3).withOpacity(0.08);
          break;
        case "Future Success":
          backgroundColor = const Color(0xFFF3F0FF);
          glowColor1 = const Color(0xFF7B1FFF).withOpacity(0.10);
          glowColor2 = const Color(0xFFB388FF).withOpacity(0.08);
          break;
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // BACKGROUND GLOW
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowColor1,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowColor2,
              ),
            ),
          ),
          // FLOATING PARTICLES
          ...particles.map(
            (particle) {
              return AnimatedPositioned(
                duration: Duration(
                  milliseconds: 4000 + particle.dx.toInt(),
                ),
                top: particle.dy + 80,
                left: particle.dx + 40,

                child: Container(
                  width: 8,
                  height: 8,

                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,

                    color:
                        Colors.white
                            .withOpacity(
                      0.5,
                    ),
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: FadeTransition(
              opacity:
                  _fadeAnimation,

              child: Padding(
                padding:
                    const EdgeInsets.all(
                  22,
                ),

                child: Column(
                  children: [
                    // HEADER

                    Row(
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),

                          child: IconButton(
                            onPressed: () {
                              // SAFE POP WITH ERROR HANDLING
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                // FALLBACK: If can't pop, navigate to home
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              }
                            },

                            icon:
                                const Icon(
                              Icons
                                  .arrow_back_ios_new_rounded,

                              color:
                                  Color(
                                0xFF241B44,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                18,
                            vertical:
                                12,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),

                          child:
                              const Row(
                            children: [
                              Text(
                                '✨',
                                style:
                                    TextStyle(
                                  fontSize:
                                      18,
                                ),
                              ),

                              SizedBox(
                                width: 8,
                              ),

                              Text(
                                'Memory Opened',
                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight.w700,

                                  color:
                                      Color(
                                    0xFF241B44,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    // HERO

                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.all(
                        26,
                      ),

                      decoration:
                          BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                              0xFF5D2DE1,
                            ),
                            Color(
                              0xFFB48CFF,
                            ),
                          ],
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          32,
                        ),

                        boxShadow: [
                          BoxShadow(
                            blurRadius:
                                28,

                            offset:
                                const Offset(
                              0,
                              14,
                            ),

                            color:
                                Colors
                                    .deepPurple
                                    .withOpacity(
                              0.22,
                            ),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const Text(
                            '💌',

                            style: TextStyle(
                              fontSize:
                                  40,
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          const Text(
                            'A message from your past self ✨',

                            style: TextStyle(
                              fontSize:
                                  30,

                              height:
                                  1.3,

                              fontWeight:
                                  FontWeight
                                      .w800,

                              color:
                                  Colors.white,
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Text(
                            formattedDate,

                            style:
                                const TextStyle(
                              fontSize:
                                  16,

                              color:
                                  Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    // MESSAGE CARD

                    Expanded(
                      child:
                          ScaleTransition(
                        scale:
                            _scaleAnimation,

                        child:
                            ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            34,
                          ),

                          child:
                              BackdropFilter(
                            filter:
                                ImageFilter.blur(
                              sigmaX: 12,
                              sigmaY: 12,
                            ),

                            child:
                                Container(
                              width:
                                  double.infinity,

                              padding:
                                  const EdgeInsets.all(
                                28,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors
                                        .white
                                        .withOpacity(
                                  0.72,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  34,
                                ),

                                border:
                                    Border.all(
                                  color:
                                      Colors
                                          .white
                                          .withOpacity(
                                    0.4,
                                  ),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    blurRadius:
                                        30,

                                    offset:
                                        const Offset(
                                      0,
                                      14,
                                    ),

                                    color:
                                        Colors.black
                                            .withOpacity(
                                      0.06,
                                    ),
                                  ),
                                ],
                              ),

                              child:
                                  SingleChildScrollView(
                                physics:
                                    const BouncingScrollPhysics(),

                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height:
                                              58,

                                          width:
                                              58,

                                          decoration:
                                              BoxDecoration(
                                            gradient:
                                                const LinearGradient(
                                              colors: [
                                                Color(
                                                  0xFF6A5BFF,
                                                ),
                                                Color(
                                                  0xFFB18CFF,
                                                ),
                                              ],
                                            ),

                                            borderRadius:
                                                BorderRadius.circular(
                                              18,
                                            ),
                                          ),

                                          child:
                                              const Icon(
                                            Icons
                                                .auto_awesome_rounded,

                                            color:
                                                Colors.white,
                                          ),
                                        ),

                                        const SizedBox(
                                          width:
                                              16,
                                        ),

                                        const Expanded(
                                          child:
                                              Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                'Future Memory',

                                                style:
                                                    TextStyle(
                                                  fontSize:
                                                      24,

                                                  fontWeight:
                                                      FontWeight.w800,

                                                  color:
                                                      Color(
                                                    0xFF241B44,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                height:
                                                    4,
                                              ),

                                              Text(
                                                'Unlocked beautifully 💜',

                                                style:
                                                    TextStyle(
                                                  color:
                                                      Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height:
                                          30,
                                    ),

                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(
                                        milliseconds:
                                            300,
                                      ),

                                      child:
                                          Text(
                                        displayedText,

                                        key: ValueKey(
                                          displayedText,
                                        ),

                                        style:
                                            const TextStyle(
                                          fontSize:
                                              22,

                                          height:
                                              1.9,

                                          letterSpacing:
                                              0.2,

                                          color:
                                              Color(
                                            0xFF2D234A,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height:
                                          28,
                                    ),

                                    if (displayedText
                                            .length ==
                                        widget.message
                                            .length)
                                      Center(
                                        child:
                                            Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal:
                                                20,

                                            vertical:
                                                14,
                                          ),

                                          decoration:
                                              BoxDecoration(
                                            gradient:
                                                const LinearGradient(
                                              colors: [
                                                Color(
                                                  0xFFEFE8FF,
                                                ),
                                                Color(
                                                  0xFFF8F3FF,
                                                ),
                                              ],
                                            ),

                                            borderRadius:
                                                BorderRadius.circular(
                                              20,
                                            ),
                                          ),

                                          child:
                                              const Row(
                                            mainAxisSize:
                                                MainAxisSize.min,

                                            children: [
                                              Text(
                                                '🌸',

                                                style:
                                                    TextStyle(
                                                  fontSize:
                                                      22,
                                                ),
                                              ),

                                              SizedBox(
                                                width:
                                                    10,
                                              ),

                                              Text(
                                                'Memory fully revealed',

                                                style:
                                                    TextStyle(
                                                  fontWeight:
                                                      FontWeight.w700,

                                                  color:
                                                      Color(
                                                    0xFF5D2DE1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    // FOOTER

                    Text(
                      'Some words become more powerful with time ✨',

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        fontSize: 15,

                        height: 1.6,

                        color:
                            Colors.black
                                .withOpacity(
                          0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}