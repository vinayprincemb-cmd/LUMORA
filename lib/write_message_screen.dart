// write_message_screen.dart
// FINAL STABLE VERSION
// ✅ FUTURE MESSAGE NOTIFICATIONS FIXED
// ✅ SAFE TIME SCHEDULING
// ✅ FUTURE MESSAGE POPUP
// ✅ VIBRATION
// ✅ NO KEYBOARD ICON
// ✅ PREMIUM UI
// ✅ MOODS
// ✅ LESS WHITE SPACE
// ✅ PLAYSTORE READY

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

class WriteMessageScreen extends StatefulWidget {
  const WriteMessageScreen({super.key});

  @override
  State<WriteMessageScreen> createState() =>
      _WriteMessageScreenState();
}

class _WriteMessageScreenState
    extends State<WriteMessageScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController
      messageController =
      TextEditingController();

  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  String selectedMood = "Hopeful";

  bool showSavedPopup = false;

  late AnimationController
      animationController;

  late Animation<double>
      scaleAnimation;

  final List<Map<String, dynamic>>
      moods = [

    {
      "title": "Hopeful",
      "emoji": "🌤️",
      "quote":
          "Tomorrow still holds beautiful things 🌤️",
      "colors": [
        Color(0xFF6A8DFF),
        Color(0xFF9EAFFF),
      ],
    },

    {
      "title": "Motivational",
      "emoji": "⚡",
      "quote":
          "Discipline creates your future ⚡",
      "colors": [
        Color(0xFFFF8A65),
        Color(0xFFFFB74D),
      ],
    },

    {
      "title": "Romantic",
      "emoji": "💌",
      "quote":
          "Some feelings deserve forever 💌",
      "colors": [
        Color(0xFFFF5C8D),
        Color(0xFFFF9EB5),
      ],
    },

    {
      "title": "Healing",
      "emoji": "🌙",
      "quote":
          "Healing takes time 🌙",
      "colors": [
        Color(0xFF5C6BC0),
        Color(0xFF8E99F3),
      ],
    },

    {
      "title": "Future Success",
      "emoji": "🚀",
      "quote":
          "Your future self is waiting 🚀",
      "colors": [
        Color(0xFF7B1FFF),
        Color(0xFFB388FF),
      ],
    },
  ];

  @override
  void initState() {

    super.initState();

    animationController =
        AnimationController(

      vsync: this,

      duration:
          const Duration(
        milliseconds: 350,
      ),
    );

    scaleAnimation =
        CurvedAnimation(

      parent:
          animationController,

      curve:
          Curves.easeOutBack,
    );
  }

  @override
  void dispose() {

    animationController.dispose();

    messageController.dispose();

    super.dispose();
  }

  Map<String, dynamic> get moodData {

    return moods.firstWhere(
      (e) => e["title"] == selectedMood,
    );
  }

  // =====================================================
  // DATE PICKER
  // =====================================================

  Future<void> pickDate() async {

    final picked =
        await showDatePicker(

      context: context,

      initialDate:
          DateTime.now(),

      firstDate:
          DateTime.now(),

      lastDate:
          DateTime(2100),
    );

    if (picked != null) {

      setState(() {

        selectedDate = picked;
      });
    }
  }

  // =====================================================
  // TIME PICKER
  // =====================================================

  Future<void> pickTime() async {

    final picked =
        await showTimePicker(

      context: context,

      initialTime:
          TimeOfDay.now(),

      // NO KEYBOARD ICON

      initialEntryMode:
          TimePickerEntryMode
              .dialOnly,

      builder: (context, child) {

        return Theme(

          data: Theme.of(context)
              .copyWith(

            colorScheme:
                const ColorScheme.light(

              primary:
                  Color(0xFF7B1FFF),
            ),
          ),

          child: child!,
        );
      },
    );

    if (picked != null) {

      setState(() {

        selectedTime = picked;
      });
    }
  }

  // =====================================================
  // POPUP
  // =====================================================

  void showSuccessPopup() {

    setState(() {

      showSavedPopup = true;
    });

    animationController.forward(
      from: 0,
    );

    Future.delayed(

      const Duration(seconds: 2),

      () {

        if (mounted) {

          setState(() {

            showSavedPopup = false;
          });
        }
      },
    );
  }

  // =====================================================
  // SAVE MESSAGE
  // =====================================================

  Future<void> saveMessage() async {

    // EMPTY CHECK

    if (messageController.text
        .trim()
        .isEmpty) {

      HapticFeedback.mediumImpact();

      return;
    }

    // DATE TIME CHECK

    if (selectedDate == null ||
        selectedTime == null) {

      HapticFeedback.mediumImpact();

      return;
    }

    // =====================================================
    // SAFE TIME FIX
    // =====================================================

    final now = DateTime.now();

    final scheduledDateTime =
        DateTime(

      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,

      selectedTime!.hour,
      selectedTime!.minute,

      10,
    );

    final finalScheduledTime =
        scheduledDateTime.isBefore(

      now.add(
        const Duration(
          seconds: 30,
        ),
      ),

    )

            ? scheduledDateTime.add(
                const Duration(
                  minutes: 1,
                ),
              )

            : scheduledDateTime;

    print(
      "✅ FINAL TIME: $finalScheduledTime",
    );

    // =====================================================
    // SAVE STORAGE
    // =====================================================

    final prefs =
        await SharedPreferences
            .getInstance();

    final messages =
        prefs.getStringList(
              "future_messages",
            ) ??
            [];

    // =====================================================
    // SCHEDULE NOTIFICATION FIRST
    // =====================================================

    final notificationId =
        await NotificationService
            .getUniqueNotificationId();

    await NotificationService
        .scheduleMessage(

      id: notificationId,

      title:
          "Message from your past self 💌",

      body:
          messageController.text
              .trim(),

      scheduledDate:
          finalScheduledTime,

      mood: selectedMood,
    );

    // =====================================================
    // SAVE MESSAGE WITH NOTIFICATION ID
    // =====================================================

    final newMessage = {

      "text":
          messageController.text
              .trim(),

      "date":
          finalScheduledTime
              .toIso8601String(),

      "mood":
          selectedMood,

      "favorite": false,

      "notificationId":
          notificationId,
    };

    messages.add(
      jsonEncode(newMessage),
    );

    await prefs.setStringList(
      "future_messages",
      messages,
    );

    // =====================================================
    // VIBRATION
    // =====================================================

    HapticFeedback.heavyImpact();

    // =====================================================
    // POPUP
    // =====================================================

    showSuccessPopup();

    // =====================================================
    // WAIT
    // =====================================================

    await Future.delayed(

      const Duration(
        milliseconds: 1600,
      ),
    );

    if (mounted) {

      Navigator.pop(context);
    }
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {

    final List<Color> colors =
        List<Color>.from(
      moodData["colors"],
    );

    return Scaffold(

      backgroundColor:
          const Color(0xFFF6F0FF),

      body: Stack(

        children: [

          // BACKGROUND GLOW

          Positioned(

            top: -120,
            left: -100,

            child: Container(

              width: 260,
              height: 260,

              decoration:
                  BoxDecoration(

                shape:
                    BoxShape.circle,

                color: colors[0]
                    .withOpacity(0.12),
              ),
            ),
          ),

          Positioned(

            bottom: -140,
            right: -120,

            child: Container(

              width: 300,
              height: 300,

              decoration:
                  BoxDecoration(

                shape:
                    BoxShape.circle,

                color: colors[1]
                    .withOpacity(0.10),
              ),
            ),
          ),

          SafeArea(

            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // HEADER

                  Row(

                    children: [

                      GestureDetector(

                        onTap: () {

                          Navigator.pop(
                            context,
                          );
                        },

                        child: Container(

                          height: 60,
                          width: 60,

                          decoration:
                              BoxDecoration(

                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: const Icon(

                            Icons
                                .arrow_back_ios_new,

                            color:
                                Color(0xFF24124D),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(

                              "Write Future Message",

                              style: TextStyle(

                                fontSize: 26,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    Color(0xFF24124D),
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(

                              "Send emotions through time ✨",

                              style: TextStyle(

                                color:
                                    Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // EMOTIONAL CARD

                  Container(

                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(
                      26,
                    ),

                    decoration:
                        BoxDecoration(

                      gradient:
                          LinearGradient(
                        colors: colors,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        34,
                      ),
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(

                          moodData["emoji"],

                          style:
                              const TextStyle(
                            fontSize: 34,
                          ),
                        ),

                        const SizedBox(
                            height: 14),

                        const Text(

                          "Dear Future Me ✨",

                          style: TextStyle(

                            color:
                                Colors.white,

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 30,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        Text(

                          moodData["quote"],

                          style:
                              const TextStyle(

                            color:
                                Colors.white70,

                            fontSize: 16,

                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // MESSAGE BOX

                  Container(

                    padding:
                        const EdgeInsets.all(
                      22,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),

                    child: TextField(

                      controller:
                          messageController,

                      maxLines: 8,

                      decoration:
                          const InputDecoration(

                        border:
                            InputBorder.none,

                        hintText:
                            "Write your future memory...",
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // DATE TIME

                  Row(

                    children: [

                      Expanded(

                        child:
                            buildInfoCard(

                          title:
                              "Pick Date",

                          value:
                              selectedDate ==
                                      null

                                  ? "Future Day"

                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",

                          icon:
                              Icons.calendar_month,

                          colors:
                              colors,

                          onTap:
                              pickDate,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(

                        child:
                            buildInfoCard(

                          title:
                              "Pick Time",

                          value:
                              selectedTime ==
                                      null

                                  ? "Choose Time"

                                  : selectedTime!
                                      .format(
                                    context,
                                  ),

                          icon:
                              Icons.access_time,

                          colors:
                              colors,

                          onTap:
                              pickTime,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // SAVE BUTTON

                  GestureDetector(

                    onTap: saveMessage,

                    child: Container(

                      height: 70,

                      decoration:
                          BoxDecoration(

                        gradient:
                            LinearGradient(
                          colors: colors,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color: colors[0]
                                .withOpacity(
                              0.28,
                            ),

                            blurRadius: 24,

                            offset:
                                const Offset(
                              0,
                              14,
                            ),
                          ),
                        ],
                      ),

                      child: const Center(

                        child: Text(

                          "✨ Save Message",

                          style: TextStyle(

                            color:
                                Colors.white,

                            fontSize: 22,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // MOODS

                  const Text(

                    "Choose Mood ✨",

                    style: TextStyle(

                      fontSize: 24,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          Color(0xFF24124D),
                    ),
                  ),

                  const SizedBox(height: 16),

                  GridView.builder(

                    itemCount:
                        moods.length,

                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount: 2,

                      crossAxisSpacing: 14,

                      mainAxisSpacing: 14,

                      childAspectRatio: 2.2,
                    ),

                    itemBuilder:
                        (context, index) {

                      final mood =
                          moods[index];

                      final selected =
                          selectedMood ==
                              mood["title"];

                      return GestureDetector(

                        onTap: () {

                          setState(() {

                            selectedMood =
                                mood["title"];
                          });
                        },

                        child:
                            AnimatedContainer(

                          duration:
                              const Duration(
                            milliseconds: 250,
                          ),

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),

                          decoration:
                              BoxDecoration(

                            gradient:
                                selected

                                    ? LinearGradient(

                                        colors:
                                            List<Color>.from(
                                          mood["colors"],
                                        ),
                                      )

                                    : null,

                            color:
                                selected
                                    ? null
                                    : Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              24,
                            ),
                          ),

                          child: Row(

                            children: [

                              Text(
                                mood["emoji"],
                              ),

                              const SizedBox(
                                  width: 8),

                              Expanded(

                                child: Text(

                                  mood["title"],

                                  style: TextStyle(

                                    color:
                                        selected

                                            ? Colors.white

                                            : const Color(
                                                0xFF24124D,
                                              ),

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // SAVED POPUP

          if (showSavedPopup)

            Positioned(

              bottom: 24,
              left: 20,
              right: 20,

              child: ScaleTransition(

                scale:
                    scaleAnimation,

                child: Material(

                  color:
                      Colors.transparent,

                  child: Container(

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),

                    decoration:
                        BoxDecoration(

                      color:
                          const Color(
                        0xFF24124D,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                    ),

                    child: const Row(

                      children: [

                        Icon(

                          Icons.check_circle,

                          color:
                              Colors.white,
                        ),

                        SizedBox(width: 12),

                        Expanded(

                          child: Text(

                            "Future message saved ✨",

                            style: TextStyle(

                              color:
                                  Colors.white,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
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

  // =====================================================
  // INFO CARD
  // =====================================================

  Widget buildInfoCard({

    required String title,

    required String value,

    required IconData icon,

    required List<Color> colors,

    required VoidCallback onTap,

  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding:
            const EdgeInsets.all(
          18,
        ),

        decoration:
            BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            24,
          ),
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Icon(
              icon,
              color: colors[0],
            ),

            const SizedBox(height: 12),

            Text(

              title,

              style: const TextStyle(

                fontWeight:
                    FontWeight.bold,

                color:
                    Color(0xFF24124D),
              ),
            ),

            const SizedBox(height: 6),

            Text(value),
          ],
        ),
      ),
    );
  }
}