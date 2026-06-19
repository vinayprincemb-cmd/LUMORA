// notification_service.dart
// FINAL WORKING VERSION
// ✅ FUTURE MESSAGE NOTIFICATIONS
// ✅ DAILY MOTIVATION QUOTES
// ✅ MESSAGE DETAIL SCREEN
// ✅ PLAYSTORE READY
// ✅ ANDROID 13+ SUPPORT
// ✅ FIXED FUTURE MESSAGE ISSUE
// ✅ FIXED CHANNELS
// ✅ FIXED EXACT ALARM ISSUES

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'message_detail_screen.dart';

// =====================================================
// GLOBAL NAVIGATOR KEY
// =====================================================

final GlobalKey<NavigatorState>
    navigatorKey =
    GlobalKey<NavigatorState>();

class NotificationService {

  static final FlutterLocalNotificationsPlugin
      notifications =
      FlutterLocalNotificationsPlugin();

  // =====================================================
  // MOTIVATION QUOTES
  // =====================================================

  static final List<String>
      motivationQuotes = [

    "Your future self is quietly cheering for you 💜",

    "The effort you make today becomes tomorrow’s confidence ✨",

    "Even slow progress is still progress 🌱",

    "You survived every difficult moment so far 🌤️",

    "One day you'll look back and feel proud of yourself 🌸",

    "Keep building the life your younger self dreamed about ⭐",

    "Your story is still unfolding beautifully 💫",

    "Tiny steps still move you forward 🌿",

    "You are becoming stronger in ways you can’t yet see 🌙",

    "Every future memory starts with today 💌",

    "The person you want to become is already growing inside you 🌈",

    "Healing and growth take time — keep going 💜",

    "Your dreams haven’t forgotten you ✨",

    "Some beautiful things take patience 🌸",

    "Your future self still believes in you 💫",

    "Growth begins outside comfort 🚀",
  ];

  // =====================================================
  // INIT
  // =====================================================

  static Future<void> init() async {

    tz.initializeTimeZones();

    // ANDROID SETTINGS

    const AndroidInitializationSettings
        androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
        settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(

      settings,

      onDidReceiveNotificationResponse:
          (NotificationResponse details) async {

        if (details.payload != null &&
            details.payload!.isNotEmpty) {

          try {

            final data =
                jsonDecode(
              details.payload!,
            );

            // WAIT FOR NAVIGATION TO BE READY

            await Future.delayed(
              const Duration(
                milliseconds: 500,
              ),
            );

            // NAVIGATE TO DETAIL SCREEN
            // Use push instead of pushAndRemoveUntil
            // Back button will naturally return to home

            if (navigatorKey
                .currentState !=
                null) {

              navigatorKey.currentState!
                  .push(

                MaterialPageRoute(

                  builder: (_) =>
                      MessageDetailScreen(

                    message:
                        data['message'] ??
                            '',

                    date:
                        data['date'] ?? '',

                    mood:
                        data['mood'] ??
                            'Hopeful',
                  ),
                ),
              );
            }

          } catch (e) {

            debugPrint(
              "❌ Error handling notification: $e",
            );
          }
        }
      },
    );

    await createChannels();

    await requestPermission();

    // RESTORE SCHEDULED MESSAGES ON APP RESTART

    await restoreScheduledMessages();

    // START DAILY MOTIVATIONS

    await scheduleDailyMotivations();
  }

  // =====================================================
  // CREATE CHANNELS
  // =====================================================

  static Future<void>
      createChannels() async {

    final androidPlugin =
        notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    // FUTURE MESSAGE CHANNEL

    await androidPlugin
        ?.createNotificationChannel(

      const AndroidNotificationChannel(

        'future_messages',

        'Future Messages',

        description:
            'Future message reminders',

        importance:
            Importance.max,
      ),
    );

    // DAILY MOTIVATION CHANNEL

    await androidPlugin
        ?.createNotificationChannel(

      const AndroidNotificationChannel(

        'daily_motivation',

        'Daily Motivation',

        description:
            'Daily motivational reminders',

        importance:
            Importance.high,
      ),
    );

    // INSTANT MOTIVATION CHANNEL

    await androidPlugin
        ?.createNotificationChannel(

      const AndroidNotificationChannel(

        'instant_motivation',

        'Instant Motivation',

        description:
            'Instant motivation notifications',

        importance:
            Importance.high,
      ),
    );
  }

  // =====================================================
  // RESTORE SCHEDULED MESSAGES
  // =====================================================

  static Future<void>
      restoreScheduledMessages() async {

    try {

      final prefs =
          await SharedPreferences
              .getInstance();

      final messages =
          prefs.getStringList(
                "future_messages",
              ) ??
              [];

      debugPrint(
        "🔄 Restoring ${messages.length} scheduled messages",
      );

      // GET PENDING NOTIFICATIONS

      final pending =
          await notifications
              .pendingNotificationRequests();

      final pendingIds =
          pending.map((p) => p.id).toSet();

      final now = DateTime.now();

      final List<String>
          validMessages = [];

      for (int i = 0;
          i < messages.length;
          i++) {

        try {

          final messageData =
              jsonDecode(
            messages[i],
          );

          final DateTime
              scheduledDateTime =
              DateTime.parse(
            messageData['date'],
          );

          final int
              notificationId =
              messageData[
                  'notificationId'] ??
                  (1000 + i);

          // ONLY RESCHEDULE IF FUTURE

          if (scheduledDateTime.isAfter(

            now.add(
              const Duration(
                seconds: 10,
              ),
            ),

          )) {

            // SKIP IF ALREADY PENDING

            if (pendingIds.contains(
              notificationId,
            )) {

              debugPrint(
                "⏭️ Notification $notificationId already scheduled",
              );

              validMessages.add(
                messages[i],
              );

              continue;
            }

            await scheduleMessage(

              id: notificationId,

              title:
                  "Message from your past self 💌",

              body:
                  messageData['text'] ??
                      '',

              scheduledDate:
                  scheduledDateTime,

              mood:
                  messageData['mood'] ??
                      'Hopeful',
            );

            validMessages.add(
              messages[i],
            );

            debugPrint(
              "✅ Restored message with ID $notificationId",
            );

          } else {

            debugPrint(
              "⏭️ Skipped expired message $i",
            );
          }

        } catch (e) {

          debugPrint(
            "❌ Error restoring message: $e",
          );
        }
      }

      // CLEANUP EXPIRED MESSAGES

      await prefs.setStringList(
        "future_messages",
        validMessages,
      );

    } catch (e) {

      debugPrint(
        "❌ Error in restoreScheduledMessages: $e",
      );
    }
  }

  // =====================================================
  // REQUEST PERMISSION
  // =====================================================

  static Future<void>
      requestPermission() async {

    await Permission.notification
        .request();

    // IMPORTANT FOR ANDROID 13+

    await Permission.scheduleExactAlarm
        .request();
  }

  // =====================================================
  // GET UNIQUE NOTIFICATION ID
  // =====================================================

  static Future<int>
      getUniqueNotificationId() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    int currentId =
        prefs.getInt(
              "notification_id_counter",
            ) ??
            1000;

    currentId++;

    await prefs.setInt(
      "notification_id_counter",
      currentId,
    );

    return currentId;
  }

  // =====================================================
  // FUTURE MESSAGE
  // =====================================================

  static Future<void>
      scheduleMessage({

    required int id,

    required String title,

    required String body,

    required DateTime scheduledDate,

    String mood = 'Hopeful',

  }) async {

    try {

      final now = DateTime.now();

      debugPrint(
        "📅 Attempting to schedule at: $scheduledDate",
      );

      debugPrint(
        "📅 Current time: $now",
      );

      // SAFETY BUFFER - At least 10 seconds

      if (scheduledDate.isBefore(

        now.add(
          const Duration(
            seconds: 10,
          ),
        ),

      )) {

        debugPrint(
          "❌ Time already passed or too soon: $scheduledDate",
        );

        return;
      }

      // CONVERT TO TIMEZONE

      final tz.TZDateTime
          tzScheduledDate =
          tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      debugPrint(
        "✅ Timezone converted to: $tzScheduledDate",
      );

      debugPrint(
        "✅ Scheduling future notification with ID: $id",
      );

      // SCHEDULE NOTIFICATION

      await notifications.zonedSchedule(

        id,

        title,

        body,

        tzScheduledDate,

        const NotificationDetails(

          android:
              AndroidNotificationDetails(

            'future_messages',

            'Future Messages',

            channelDescription:
                'Future message reminders',

            importance:
                Importance.max,

            priority:
                Priority.high,

            playSound: true,

            enableVibration: true,

            visibility:
                NotificationVisibility.public,

            ongoing: false,
          ),
        ),

        // CRITICAL FOR EXACT ALARM

        androidScheduleMode:
            AndroidScheduleMode
                .alarmClock,

        // DO NOT REPEAT

        matchDateTimeComponents:
            null,

        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation
                .absoluteTime,

        payload: jsonEncode({

          'message': body,

          'date':
              scheduledDate.toIso8601String(),

          'mood': mood,
        }),
      );

      // VERIFY SCHEDULING

      final pending =
          await notifications
              .pendingNotificationRequests();

      debugPrint(
        "✅ SUCCESS: Notification scheduled! Pending: ${pending.length}",
      );

      final exists = pending.any(
        (p) => p.id == id,
      );

      if (exists) {

        debugPrint(
          "✅ VERIFIED: Notification ID $id is in pending queue",
        );

      } else {

        debugPrint(
          "⚠️ WARNING: Notification ID $id not found in pending queue",
        );
      }

    } catch (e) {

      debugPrint(
        "❌ CRITICAL ERROR scheduling notification: $e",
      );

      debugPrint(
        "❌ Stack trace: ${StackTrace.current}",
      );
    }
  }

  // =====================================================
  // DAILY MOTIVATIONS
  // =====================================================

  static Future<void>
      scheduleDailyMotivations() async {

    // REMOVE OLD ONES

    for (int i = 200; i <= 203; i++) {

      await notifications.cancel(i);
    }

    // 4 TIMES DAILY
    // 9 AM
    // 1 PM
    // 6 PM
    // 9 PM

    final List<int> hours = [
      9,
      13,
      18,
      21,
    ];

    for (int i = 0;
        i < hours.length;
        i++) {

      final now = DateTime.now();

      DateTime scheduledTime =
          DateTime(

        now.year,
        now.month,
        now.day,

        hours[i],
        0,
      );

      // MOVE TO NEXT DAY IF PASSED

      if (scheduledTime.isBefore(
        now,
      )) {

        scheduledTime =
            scheduledTime.add(
          const Duration(days: 1),
        );
      }

      final randomQuote =
          motivationQuotes[
              Random().nextInt(
        motivationQuotes.length,
      )];

      await notifications.zonedSchedule(

        200 + i,

        'Future Self Reminder ✨',

        randomQuote,

        tz.TZDateTime.from(
          scheduledTime,
          tz.local,
        ),

        const NotificationDetails(

          android:
              AndroidNotificationDetails(

            'daily_motivation',

            'Daily Motivation',

            channelDescription:
                'Motivational reminders',

            importance:
                Importance.high,

            priority:
                Priority.high,

            playSound: true,

            enableVibration: true,
          ),
        ),

        androidScheduleMode:
            AndroidScheduleMode
                .alarmClock,

        matchDateTimeComponents:
            DateTimeComponents.time,

        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation
                .absoluteTime,
      );
    }
  }

  // =====================================================
  // TEST NOTIFICATION
  // =====================================================

  static Future<void>
      showInstantMotivation() async {

    final randomQuote =
        motivationQuotes[
            Random().nextInt(
      motivationQuotes.length,
    )];

    await notifications.show(

      999,

      'Future Self Reminder ✨',

      randomQuote,

      const NotificationDetails(

        android:
            AndroidNotificationDetails(

          'instant_motivation',

          'Instant Motivation',

          importance:
              Importance.high,

          priority:
              Priority.high,
        ),
      ),
    );
  }

  // =====================================================
  // CANCEL NOTIFICATION
  // =====================================================

  static Future<void>
      cancelNotification(
    int id,
  ) async {

    await notifications.cancel(id);
  }
}