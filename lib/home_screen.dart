// home_screen.dart
// ✅ ENHANCED WITH PROFESSIONAL ANIMATIONS
// ✅ BEAUTIFUL GRADIENTS & BACKGROUNDS
// ✅ SMOOTH PAGE TRANSITIONS
// ✅ ANIMATED ACTION CARDS
// ✅ TERMS & CONDITIONS + PRIVACY POLICY
// ✅ EMOTIONAL DESIGN

import 'dart:async';

import 'package:flutter/material.dart';

import 'write_message_screen.dart';
import 'view_messages_screen.dart';
import 'page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen>
    with TickerProviderStateMixin {
  final PageController _pageController =
      PageController();

  int currentPage = 0;

  Timer? sliderTimer;

  // Animation controllers
  late AnimationController _fadeInController;
  late AnimationController _slideInController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideInAnimation;

  final List<Map<String, String>>
      heroSlides = [
    {
      "emoji": "✨",
      "title":
          "Write messages for the person you are becoming",
      "subtitle":
          "Your emotions deserve to survive time beautifully.",
    },
    {
      "emoji": "💜",
      "title":
          "Send comfort to your future self",
      "subtitle":
          "Some words heal more deeply in the future.",
    },
    {
      "emoji": "🌙",
      "title":
          "Capture emotions before they fade",
      "subtitle":
          "Future memories begin with today’s feelings.",
    },
    {
      "emoji": "💌",
      "title":
          "Preserve memories emotionally",
      "subtitle":
          "A private vault for your future emotions.",
    },
  ];

  final List<Map<String, String>>
      faqList = [
    {
      "q":
          "What is Lumora?",
      "a":
          "Lumora lets you send emotional messages to your future self."
    },
    {
      "q":
          "Are messages private?",
      "a":
          "Yes. Your messages stay only on your device."
    },
    {
      "q":
          "Can I unlock messages later?",
      "a":
          "Yes. Messages unlock automatically on selected dates."
    },
    {
      "q":
          "Can I archive memories?",
      "a":
          "Yes. Swipe right to archive messages."
    },
    {
      "q":
          "Can I delete messages?",
      "a":
          "Yes. Swipe left to delete with undo support."
    },
    {
      "q":
          "Can I search memories?",
      "a":
          "Yes. Search by mood or message text."
    },
    {
      "q":
          "What are moods?",
      "a":
          "Moods personalize the emotional atmosphere of memories."
    },
    {
      "q":
          "Do notifications work?",
      "a":
          "Yes. Lumora reminds you when memories unlock."
    },
    {
      "q":
          "Can I favorite memories?",
      "a":
          "Yes. Save special moments to favorites."
    },
    {
      "q":
          "Is internet required?",
      "a":
          "No. Lumora works offline."
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeInController = AnimationController(
      duration: const Duration(
        milliseconds: 800,
      ),
      vsync: this,
    );

    _slideInController = AnimationController(
      duration: const Duration(
        milliseconds: 800,
      ),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeInController,
        curve: Curves.easeOut,
      ),
    );

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideInController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animations
    _fadeInController.forward();
    _slideInController.forward();

    startSlider();
  }

  void startSlider() {
    sliderTimer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (currentPage <
            heroSlides.length - 1) {
          currentPage++;
        } else {
          currentPage = 0;
        }

        _pageController.animateToPage(
          currentPage,
          duration:
              const Duration(
            milliseconds: 500,
          ),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    sliderTimer?.cancel();

    _pageController.dispose();
    _fadeInController.dispose();
    _slideInController.dispose();

    super.dispose();
  }

  void openMenuSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
      builder: (context) {
        return Container(
          height:
              MediaQuery.of(context)
                      .size
                      .height *
                  0.90,
          decoration:
              const BoxDecoration(
            color: Color(
              0xFFF7F2FF,
            ),
            borderRadius:
                BorderRadius.vertical(
              top:
                  Radius.circular(
                34,
              ),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: ListView(
              children: [
                Center(
                  child: Container(
                    width: 70,
                    height: 5,
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.grey,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 26),

                const Text(
                  "LUMORA 💜",
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight:
                        FontWeight
                            .w900,
                    color: Color(
                      0xFF24124D,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 12),

                const Text(
                  "A beautiful emotional vault for messages through time.",
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Colors.black54,
                    height: 1.6,
                  ),
                ),

                const SizedBox(
                    height: 34),

                buildSectionTitle(
                  "About App ✨",
                ),

                buildInfoCard(
                  "Lumora is a future messaging experience designed to preserve emotions through time.\n\nYou can write messages for your future self, unlock memories later, archive emotional moments, favorite special memories and create emotional capsules for different moods.\n\nThe app focuses on emotional anticipation, reflection and personal growth.\n\nEvery memory becomes more meaningful when experienced at the right moment.\n\nLumora is designed to feel calm, emotional and deeply personal.\n\nIt helps users reconnect with forgotten emotions and future dreams.\n\nMessages can stay locked for days, months or years.\n\nYour future self becomes part of the experience.\n\nEvery saved message becomes a time capsule.\n\nLumora transforms ordinary journaling into emotional storytelling.",
                ),

                const SizedBox(
                    height: 28),

                buildSectionTitle(
                  "FAQ 💭",
                ),

                ...faqList.map(
                  (faq) =>
                      buildFaqTile(
                    faq["q"]!,
                    faq["a"]!,
                  ),
                ),

                const SizedBox(
                    height: 28),

                buildSectionTitle(
                  "Contact Us ☎️",
                ),

                buildInfoCard(
                  "Developer: Vinay kumar pantam\n\nEmail:\nvinayprincemb@gmail.com\n\nPhone:\n+91 9010216131\n\nThank you for using Lumora 💜",
                ),

                const SizedBox(
                    height: 28),

                buildSectionTitle(
                  "Legal ⚖️",
                ),

                buildLegalTile(
                  "Terms & Conditions",
                  "📋",
                ),

                const SizedBox(
                    height: 12),

                buildLegalTile(
                  "Privacy Policy",
                  "🔒",
                ),

                const SizedBox(
                    height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 18,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight:
              FontWeight.w800,
          color:
              Color(0xFF24124D),
        ),
      ),
    );
  }

  Widget buildInfoCard(
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          28,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.8,
          color:
              Color(0xFF2B2147),
        ),
      ),
    );
  }

  Widget buildFaqTile(
    String question,
    String answer,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),
      child: ExpansionTile(
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            24,
          ),
        ),
        collapsedShape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            24,
          ),
        ),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
            color:
                Color(
              0xFF24124D,
            ),
          ),
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.all(
              18,
            ),
            child: Text(
              answer,
              style: const TextStyle(
                height: 1.6,
                color:
                    Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLegalTile(
    String title,
    String emoji,
  ) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
            backgroundColor:
                const Color(0xFFF7F2FF),
            title: Text(
              "$emoji $title",
              style:
                  const TextStyle(
                color:
                    Color(0xFF24124D),
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                title ==
                        "Terms & Conditions"
                    ? _getTermsContent()
                    : _getPrivacyContent(),
                style:
                    const TextStyle(
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(
                  context,
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Color(
                      0xFF662DFF,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color: const Color(
                  0xFF662DFF,
                )
                .withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w600,
                  color: Color(
                    0xFF24124D,
                  ),
                ),
              ),
            ),
            const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              color: Colors.black38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _getTermsContent() {
    return '''Terms & Conditions

1. Acceptance of Terms
By using Lumora, you agree to these terms and conditions.

2. User Responsibility
You are responsible for maintaining the confidentiality of your account and all activities that occur under your account.

3. Content
All messages and content you create remain your intellectual property. You grant Lumora the right to store and display your content within the app.

4. Data Storage
Messages are stored locally on your device. Lumora does not transmit or share your personal messages with third parties.

5. Service Availability
Lumora is provided on an "as is" basis without warranties. We reserve the right to modify or discontinue the service.

6. Limitations of Liability
Lumora shall not be liable for any indirect, incidental, special, or consequential damages.

7. Changes to Terms
We may update these terms at any time. Your continued use of the app constitutes acceptance.

8. Governing Law
These terms are governed by applicable laws and regulations.''';
  }

  String _getPrivacyContent() {
    return '''Privacy Policy

1. Information We Collect
Lumora collects minimal information:
- Messages you write (stored locally on your device)
- Device notifications preferences
- App usage analytics (optional)

2. Data Storage
All your messages are stored locally on your device. We do not store your messages on our servers.

3. Data Sharing
We do not sell, trade, or share your personal data with third parties.

4. Third-Party Services
Lumora uses Firebase for crash reporting and analytics. Visit Firebase Privacy Policy for details.

5. Security
We implement security measures to protect your data. However, no method of transmission is 100% secure.

6. Children's Privacy
Lumora is not intended for children under 13. We do not knowingly collect data from children.

7. Your Rights
You have the right to access, modify, or delete your messages from the app at any time.

8. Changes to Privacy Policy
We may update this policy. Changes are effective immediately upon posting.

9. Contact Us
For privacy concerns, contact: vinayprince.dev@gmail.com''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F1FF),

      body: SafeArea(
        child: Stack(
          children: [
            // BACKGROUND

            Positioned(
              top: -120,
              left: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,
                  color: const Color(
                    0xFFB78EFF,
                  ).withOpacity(0.15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF662DFF,
                      ).withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: -150,
              right: -120,
              child: Container(
                width: 340,
                height: 340,
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,
                  color: const Color(
                    0xFF6A35FF,
                  ).withOpacity(0.10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF9D6FFF,
                      ).withOpacity(0.08),
                      blurRadius: 50,
                      spreadRadius: 15,
                    ),
                  ],
                ),
              ),
            ),

            // TOP ACCENT ELEMENT
            Positioned(
              top: 100,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,
                  color: const Color(
                    0xFFD4B8FF,
                  ).withOpacity(0.08),
                ),
              ),
            ),

            FadeTransition(
              opacity:
                  _fadeInAnimation,
              child: SlideTransition(
                position:
                    _slideInAnimation,
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      // HEADER WITH ANIMATION
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  "LUMORA",
                                  style:
                                      TextStyle(
                                    fontSize:
                                        34,
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                    color:
                                        Color(
                                      0xFF24124D,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        4),
                                Text(
                                  "Messages Through Time ✨",
                                  style:
                                      TextStyle(
                                    fontSize:
                                        15,
                                    color:
                                        Colors
                                            .black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap:
                                openMenuSheet,
                            child:
                                AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds:
                                    300,
                              ),
                              padding:
                                  const EdgeInsets.all(
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                      0.08,
                                    ),
                                    blurRadius:
                                        12,
                                    offset:
                                        const Offset(
                                      0,
                                      4,
                                    ),
                                  ),
                                ],
                              ),
                              child:
                                  const Icon(
                                Icons
                                    .more_vert_rounded,
                                color:
                                    Color(
                                  0xFF24124D,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 22),

                      // HERO SLIDER WITH ENHANCED ANIMATION
                      SizedBox(
                        height: 280,
                        child:
                            PageView.builder(
                          controller:
                              _pageController,
                          itemCount:
                              heroSlides.length,
                          onPageChanged:
                              (index) {
                            setState(() {
                              currentPage =
                                  index;
                            });
                          },
                          itemBuilder: (context,
                              index) {
                            final slide =
                                heroSlides[
                                    index];

                            return AnimatedBuilder(
                              animation:
                                  _pageController,
                              builder: (
                                context,
                                child,
                              ) {
                                double
                                    value =
                                    1.0;
                                if (_pageController
                                    .position
                                    .haveDimensions) {
                                  value = (_pageController
                                      .page! -
                                      index)
                                      .abs();
                                  value = (1 -
                                      (value
                                          .clamp(
                                    0.0,
                                    1.0)));
                                }

                                return Transform
                                    .scale(
                                  scale: 0.9 +
                                      (value *
                                          0.1),
                                  child: Opacity(
                                    opacity: 0.8 +
                                        (value *
                                            0.2),
                                    child:
                                        child!,
                                  ),
                                );
                              },
                              child:
                                  Container(
                                margin:
                                    const EdgeInsets.only(
                                  right:
                                      10,
                                ),
                                padding:
                                    const EdgeInsets.all(
                                  28,
                                ),
                                decoration:
                                    BoxDecoration(
                                  gradient:
                                      LinearGradient(
                                    colors: [
                                      const Color(
                                        0xFF662DFF,
                                      ).withOpacity(
                                        0.95,
                                      ),
                                      const Color(
                                        0xFFB58CFF,
                                      ).withOpacity(
                                        0.95,
                                      ),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    36,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF662DFF,
                                      ).withOpacity(
                                        0.25,
                                      ),
                                      blurRadius:
                                          20,
                                      offset:
                                          const Offset(
                                        0,
                                        10,
                                      ),
                                    ),
                                  ],
                                ),
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      slide[
                                          "emoji"]!,
                                      style:
                                          const TextStyle(
                                        fontSize:
                                            44,
                                      ),
                                    ),

                                    const Spacer(),

                                    Text(
                                      slide[
                                          "title"]!,
                                      style:
                                          const TextStyle(
                                        fontSize:
                                            24,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        color:
                                            Colors
                                                .white,
                                        height:
                                            1.4,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            12),

                                    Text(
                                      slide[
                                          "subtitle"]!,
                                      style:
                                          TextStyle(
                                        fontSize:
                                            15,
                                        color:
                                            Colors
                                                .white
                                                .withOpacity(
                                          0.9,
                                        ),
                                        height:
                                            1.6,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            18),

                                    Row(
                                      children:
                                          List.generate(
                                        heroSlides
                                            .length,
                                        (
                                          dotIndex,
                                        ) {
                                          return AnimatedContainer(
                                            duration:
                                                const Duration(
                                              milliseconds:
                                                  300,
                                            ),
                                            margin:
                                                const EdgeInsets.only(
                                              right:
                                                  8,
                                            ),
                                            width: currentPage ==
                                                    dotIndex
                                                ? 28
                                                : 10,
                                            height:
                                                10,
                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  Colors
                                                      .white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                  const SizedBox(
                      height: 28),

                  // ACTION CARDS WITH ANIMATION
                  _buildAnimatedActionCard(
                    icon:
                        Icons.edit_rounded,
                    title:
                        "Write Future Message",
                    subtitle:
                        "Send emotions beautifully through time.",
                    onTap: () {
                      Navigator.push(
                        context,
                        FadeSlideRoute(
                          page:
                              const WriteMessageScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                      height: 16),

                  _buildAnimatedActionCard(
                    icon: Icons
                        .lock_clock_rounded,
                    title:
                        "View Future Messages",
                    subtitle:
                        "See locked and unlocked memories.",
                    onTap: () {
                      Navigator.push(
                        context,
                        FadeSlideRoute(
                          page:
                              ViewMessagesScreen(),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  Center(
                    child: Text(
                      "“The words you write today may comfort you tomorrow.” 💜",
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle:
                            FontStyle.italic,
                        color:
                            Colors.black54
                                .withOpacity(
                          0.8,
                        ),
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 10),
                ],
              ),
            ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(
          24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            34,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.06),
              blurRadius: 20,
              offset:
                  const Offset(
                0,
                10,
              ),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Color(
                      0xFF662DFF,
                    ),
                    Color(
                      0xFFB58CFF,
                    ),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(
                  28,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF662DFF,
                    ).withOpacity(0.3),
                    blurRadius: 15,
                    offset:
                        const Offset(
                      0,
                      5,
                    ),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 42,
              ),
            ),

            const SizedBox(
                width: 22),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight
                              .bold,
                      color:
                          Color(
                        0xFF24124D,
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 6),

                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      fontSize: 15,
                      color:
                          Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              color:
                  Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}