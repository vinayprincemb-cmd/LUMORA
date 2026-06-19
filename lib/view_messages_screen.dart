// view_messages_screen.dart
// FINAL PREMIUM STABLE VERSION
// ✅ MESSAGE DETAIL OPEN FIXED
// ✅ BETTER UI
// ✅ NO EXTRA WHITE SPACE
// ✅ ARCHIVE WORKS
// ✅ DELETE WORKS
// ✅ UNDO WORKS
// ✅ FAVORITES
// ✅ SEARCH
// ✅ MOODS
// ✅ LOCKED / UNLOCKED
// ✅ PREMIUM EMOTIONAL ATMOSPHERE

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'archived_messages_screen.dart';
import 'message_detail_screen.dart';

class ViewMessagesScreen extends StatefulWidget {
  const ViewMessagesScreen({super.key});

  @override
  State<ViewMessagesScreen> createState() =>
      _ViewMessagesScreenState();
}

class _ViewMessagesScreenState
    extends State<ViewMessagesScreen> {

  List<Map<String, dynamic>> messages = [];

  String filter = "All";

  String searchQuery = "";

  Timer? timer;

  bool showUndo = false;

  String undoText = "";

  VoidCallback? undoAction;

  @override
  void initState() {

    super.initState();

    loadMessages();

    timer = Timer.periodic(

      const Duration(seconds: 1),

      (_) {

        if (mounted) {

          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {

    timer?.cancel();

    super.dispose();
  }

  // =====================================================
  // UNDO BAR
  // =====================================================

  void showUndoBar({

    required String text,

    required VoidCallback onUndo,

  }) {

    setState(() {

      showUndo = true;

      undoText = text;

      undoAction = onUndo;
    });

    Future.delayed(

      const Duration(seconds: 2),

      () {

        if (mounted) {

          setState(() {

            showUndo = false;
          });
        }
      },
    );
  }

  // =====================================================
  // MOOD COLORS
  // =====================================================

  Color moodColor(String mood) {

    switch (mood) {

      case "Romantic":
        return Colors.pink;

      case "Healing":
        return Colors.indigo;

      case "Motivational":
        return Colors.orange;

      case "Future Success":
        return Colors.deepPurple;

      default:
        return Colors.blue;
    }
  }

  // =====================================================
  // LOAD
  // =====================================================

  Future<void> loadMessages() async {

    final prefs =
        await SharedPreferences.getInstance();

    final stored =
        prefs.getStringList(
              "future_messages",
            ) ??
            [];

    List<Map<String, dynamic>> loaded = [];

    for (var item in stored) {

      try {

        final decoded =
            jsonDecode(item);

        if (decoded is Map<String, dynamic>) {

          decoded.putIfAbsent(
            "favorite",
            () => false,
          );

          decoded.putIfAbsent(
            "mood",
            () => "Hopeful",
          );

          loaded.add(decoded);
        }

      } catch (_) {}
    }

    loaded.sort((a, b) {

      return DateTime.parse(
        a["date"],
      ).compareTo(
        DateTime.parse(
          b["date"],
        ),
      );
    });

    if (mounted) {

      setState(() {

        messages = loaded;
      });
    }
  }

  // =====================================================
  // SAVE
  // =====================================================

  Future<void> saveMessages() async {

    final prefs =
        await SharedPreferences.getInstance();

    final encoded =
        messages.map(
      (e) => jsonEncode(e),
    ).toList();

    await prefs.setStringList(
      "future_messages",
      encoded,
    );
  }

  // =====================================================
  // HELPERS
  // =====================================================

  bool isUnlocked(String date) {

    return DateTime.now().isAfter(
      DateTime.parse(date),
    );
  }

  String formatDate(String date) {

    return DateFormat(
      "dd MMM yyyy • hh:mm a",
    ).format(
      DateTime.parse(date),
    );
  }

  String timeLeft(String date) {

    final difference =
        DateTime.parse(date)
            .difference(
      DateTime.now(),
    );

    if (difference.inDays > 0) {

      return "${difference.inDays} day(s) left";
    }

    if (difference.inHours > 0) {

      return "${difference.inHours} hour(s) left";
    }

    if (difference.inMinutes > 0) {

      return "${difference.inMinutes} minute(s) left";
    }

    return "Almost ready ✨";
  }

  // =====================================================
  // FILTER
  // =====================================================

  List<Map<String, dynamic>>
      filteredMessages() {

    List<Map<String, dynamic>>
        filtered = messages;

    if (filter == "Locked") {

      filtered = filtered.where((e) {

        return !isUnlocked(
          e["date"],
        );
      }).toList();
    }

    if (filter == "Unlocked") {

      filtered = filtered.where((e) {

        return isUnlocked(
          e["date"],
        );
      }).toList();
    }

    if (filter == "Favorites") {

      filtered = filtered.where((e) {

        return e["favorite"] == true;
      }).toList();
    }

    if (searchQuery.isNotEmpty) {

      filtered = filtered.where((e) {

        return e["text"]
            .toString()
            .toLowerCase()
            .contains(
              searchQuery.toLowerCase(),
            );
      }).toList();
    }

    return filtered;
  }

  // =====================================================
  // FAVORITE
  // =====================================================

  Future<void> toggleFavorite(
    int index,
  ) async {

    setState(() {

      messages[index]["favorite"] =
          !(messages[index]["favorite"] ??
              false);
    });

    await saveMessages();
  }

  @override
  Widget build(BuildContext context) {

    final data =
        filteredMessages();

    return Scaffold(

      backgroundColor:
          const Color(0xFFF6F1FF),

      body: Stack(

        children: [

          // BACKGROUND

          Positioned(

            top: -120,
            left: -120,

            child: Container(

              height: 300,
              width: 300,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color:
                    Colors.deepPurple
                        .withOpacity(0.08),
              ),
            ),
          ),

          Positioned(

            bottom: -140,
            right: -140,

            child: Container(

              height: 340,
              width: 340,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color:
                    Colors.purple
                        .withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(

            child: Padding(

              padding:
                  const EdgeInsets.all(22),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // =====================================================
                  // HEADER
                  // =====================================================

                  Row(

                    children: [

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: const [

                            Text(

                              "Future Memories",

                              style: TextStyle(

                                fontSize: 32,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    Color(0xFF24124D),
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(

                              "Emotions waiting across time 💜",

                              style: TextStyle(

                                fontSize: 15,

                                color:
                                    Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(

                        onTap: () async {

                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  const ArchivedMessagesScreen(),
                            ),
                          );

                          loadMessages();
                        },

                        child: Container(

                          padding:
                              const EdgeInsets.symmetric(

                            horizontal: 16,
                            vertical: 14,
                          ),

                          decoration:
                              BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              22,
                            ),

                            boxShadow: [

                              BoxShadow(

                                color:
                                    Colors.black
                                        .withOpacity(0.04),

                                blurRadius: 12,

                                offset:
                                    const Offset(
                                  0,
                                  6,
                                ),
                              ),
                            ],
                          ),

                          child: const Icon(

                            Icons.archive_rounded,

                            color:
                                Color(0xFF6A35FF),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // =====================================================
                  // SEARCH
                  // =====================================================

                  Container(

                    height: 64,

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color:
                              Colors.black
                                  .withOpacity(0.03),

                          blurRadius: 16,

                          offset:
                              const Offset(
                            0,
                            8,
                          ),
                        ),
                      ],
                    ),

                    child: TextField(

                      onChanged: (value) {

                        setState(() {

                          searchQuery = value;
                        });
                      },

                      decoration:
                          const InputDecoration(

                        border: InputBorder.none,

                        icon: Icon(
                          Icons.search_rounded,
                        ),

                        hintText:
                            "Search memories...",
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =====================================================
                  // FILTERS
                  // =====================================================

                  SizedBox(

                    height: 48,

                    child: ListView(

                      scrollDirection:
                          Axis.horizontal,

                      children: [

                        buildFilter("All"),

                        buildFilter("Unlocked"),

                        buildFilter("Locked"),

                        buildFilter("Favorites"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =====================================================
                  // LIST
                  // =====================================================

                  Expanded(

                    child: data.isEmpty

                        ? const Center(

                            child: Text(

                              "No memories found 💜",

                              style: TextStyle(

                                fontSize: 24,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          )

                        : ListView.builder(

                            physics:
                                const BouncingScrollPhysics(),

                            itemCount:
                                data.length,

                            itemBuilder:
                                (context, index) {

                              final msg =
                                  data[index];

                              final unlocked =
                                  isUnlocked(
                                msg["date"],
                              );

                              final mood =
                                  msg["mood"] ??
                                      "Hopeful";

                              return Padding(

                                padding:
                                    const EdgeInsets.only(
                                  bottom: 18,
                                ),

                                child:
                                    Dismissible(

                                  key: UniqueKey(),

                                  background:
                                      buildSwipeBackground(
                                    true,
                                  ),

                                  secondaryBackground:
                                      buildSwipeBackground(
                                    false,
                                  ),

                                  confirmDismiss:
                                      (direction) async {

                                    final removed =
                                        Map<String, dynamic>.from(
                                      msg,
                                    );

                                    // ARCHIVE

                                    if (direction ==
                                        DismissDirection.startToEnd) {

                                      setState(() {

                                        messages.removeAt(index);
                                      });

                                      await saveMessages();

                                      final prefs =
                                          await SharedPreferences.getInstance();

                                      final archived =
                                          prefs.getStringList(
                                                "archived_messages",
                                              ) ??
                                              [];

                                      archived.add(
                                        jsonEncode(removed),
                                      );

                                      await prefs.setStringList(
                                        "archived_messages",
                                        archived,
                                      );

                                      showUndoBar(

                                        text:
                                            "Message archived 💜",

                                        onUndo: () async {

                                          setState(() {

                                            messages.insert(
                                              index,
                                              removed,
                                            );
                                          });

                                          final updated =
                                              prefs.getStringList(
                                                    "archived_messages",
                                                  ) ??
                                                  [];

                                          updated.remove(
                                            jsonEncode(removed),
                                          );

                                          await prefs.setStringList(
                                            "archived_messages",
                                            updated,
                                          );

                                          await saveMessages();
                                        },
                                      );

                                      return false;
                                    }

                                    // DELETE

                                    else {

                                      setState(() {

                                        messages.removeAt(index);
                                      });

                                      await saveMessages();

                                      showUndoBar(

                                        text:
                                            "Message deleted 🗑️",

                                        onUndo: () async {

                                          setState(() {

                                            messages.insert(
                                              index,
                                              removed,
                                            );
                                          });

                                          await saveMessages();
                                        },
                                      );

                                      return false;
                                    }
                                  },

                                  child:
                                      GestureDetector(

                                    onTap: () {

                                      // FIXED

                                      if (!unlocked) {

                                        showUndoBar(

                                          text:
                                              "This memory is still locked 🔒",

                                          onUndo: () {},
                                        );

                                        return;
                                      }

                                      Navigator.push(

                                        context,

                                        MaterialPageRoute(

                                          builder: (_) =>
                                              MessageDetailScreen(

                                            message:
                                                msg["text"] ??
                                                    "",

                                            date:
                                                msg["date"] ??
                                                    "",

                                            mood:
                                                msg["mood"] ??
                                                    'Hopeful',
                                          ),
                                        ),
                                      );
                                    },

                                    child: Container(

                                      padding:
                                          const EdgeInsets.all(
                                        20,
                                      ),

                                      decoration:
                                          BoxDecoration(

                                        color: Colors.white,

                                        borderRadius:
                                            BorderRadius.circular(
                                          30,
                                        ),

                                        boxShadow: [

                                          BoxShadow(

                                            color:
                                                Colors.black
                                                    .withOpacity(0.04),

                                            blurRadius:
                                                18,

                                            offset:
                                                const Offset(
                                              0,
                                              10,
                                            ),
                                          ),
                                        ],
                                      ),

                                      child: Row(

                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [

                                          // ICON

                                          Container(

                                            height: 64,
                                            width: 64,

                                            decoration:
                                                BoxDecoration(

                                              gradient:
                                                  LinearGradient(

                                                colors:

                                                    unlocked

                                                        ? [
                                                            Colors.green,
                                                            Colors.greenAccent,
                                                          ]

                                                        : [
                                                            const Color(0xFF6A35FF),
                                                            const Color(0xFFB388FF),
                                                          ],
                                              ),

                                              borderRadius:
                                                  BorderRadius.circular(
                                                22,
                                              ),
                                            ),

                                            child: Icon(

                                              unlocked

                                                  ? Icons.lock_open_rounded

                                                  : Icons.lock_rounded,

                                              color:
                                                  Colors.white,
                                            ),
                                          ),

                                          const SizedBox(width: 16),

                                          // CONTENT

                                          Expanded(

                                            child: Column(

                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

                                              children: [

                                                Text(

                                                  unlocked

                                                      ? msg["text"]

                                                      : "Locked Future Memory 🔒",

                                                  maxLines: 2,

                                                  overflow:
                                                      TextOverflow.ellipsis,

                                                  style:
                                                      const TextStyle(

                                                    fontSize: 17,

                                                    fontWeight:
                                                        FontWeight.bold,

                                                    color:
                                                        Color(0xFF24124D),

                                                    height: 1.4,
                                                  ),
                                                ),

                                                const SizedBox(height: 12),

                                                Text(

                                                  formatDate(
                                                    msg["date"],
                                                  ),

                                                  style:
                                                      const TextStyle(

                                                    color:
                                                        Colors.black54,

                                                    fontSize: 13,
                                                  ),
                                                ),

                                                const SizedBox(height: 14),

                                                Row(

                                                  children: [

                                                    Container(

                                                      padding:
                                                          const EdgeInsets.symmetric(

                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),

                                                      decoration:
                                                          BoxDecoration(

                                                        color:
                                                            moodColor(mood)
                                                                .withOpacity(0.12),

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          14,
                                                        ),
                                                      ),

                                                      child: Text(

                                                        mood,

                                                        style: TextStyle(

                                                          color:
                                                              moodColor(mood),

                                                          fontWeight:
                                                              FontWeight.bold,

                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(width: 10),

                                                    Expanded(

                                                      child: Text(

                                                        unlocked

                                                            ? "Tap to open 💜"

                                                            : timeLeft(
                                                                msg["date"],
                                                              ),

                                                        overflow:
                                                            TextOverflow.ellipsis,

                                                        style: TextStyle(

                                                          color:
                                                              unlocked

                                                                  ? Colors.green

                                                                  : const Color(
                                                                      0xFF6A35FF,
                                                                    ),

                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          // FAVORITE

                                          IconButton(

                                            onPressed: () {

                                              toggleFavorite(
                                                index,
                                              );
                                            },

                                            icon: Icon(

                                              msg["favorite"] == true

                                                  ? Icons.favorite_rounded

                                                  : Icons.favorite_border_rounded,

                                              color:
                                                  msg["favorite"] == true

                                                      ? Colors.pink

                                                      : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // CUSTOM UNDO BAR
          // =====================================================

          if (showUndo)

            Positioned(

              bottom: 20,
              left: 20,
              right: 20,

              child: Material(

                color: Colors.transparent,

                child: Container(

                  padding:
                      const EdgeInsets.symmetric(

                    horizontal: 20,
                    vertical: 16,
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

                    boxShadow: [

                      BoxShadow(

                        color:
                            Colors.black
                                .withOpacity(0.15),

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

                      Expanded(

                        child: Text(

                          undoText,

                          style:
                              const TextStyle(

                            color:
                                Colors.white,

                            fontSize: 15,
                          ),
                        ),
                      ),

                      GestureDetector(

                        onTap: () {

                          undoAction?.call();

                          setState(() {

                            showUndo = false;
                          });
                        },

                        child: const Text(

                          "UNDO",

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
        ],
      ),
    );
  }

  // =====================================================
  // FILTER BUTTON
  // =====================================================

  Widget buildFilter(
    String text,
  ) {

    final selected =
        filter == text;

    return GestureDetector(

      onTap: () {

        setState(() {

          filter = text;
        });
      },

      child: Container(

        margin:
            const EdgeInsets.only(
          right: 12,
        ),

        padding:
            const EdgeInsets.symmetric(

          horizontal: 22,
          vertical: 12,
        ),

        decoration:
            BoxDecoration(

          gradient:
              selected

                  ? const LinearGradient(

                      colors: [

                        Color(0xFF6A35FF),

                        Color(0xFFB388FF),
                      ],
                    )

                  : null,

          color:
              selected
                  ? null
                  : Colors.white,

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        child: Text(

          text,

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
    );
  }

  // =====================================================
  // SWIPE BACKGROUND
  // =====================================================

  Widget buildSwipeBackground(
    bool archive,
  ) {

    return Container(

      alignment:
          archive

              ? Alignment.centerLeft

              : Alignment.centerRight,

      padding:
          EdgeInsets.only(

        left: archive ? 25 : 0,

        right: archive ? 0 : 25,
      ),

      decoration: BoxDecoration(

        color:
            archive
                ? Colors.deepPurple
                : Colors.redAccent,

        borderRadius:
            BorderRadius.circular(
          30,
        ),
      ),

      child: Icon(

        archive

            ? Icons.archive_rounded

            : Icons.delete_rounded,

        color: Colors.white,

        size: 30,
      ),
    );
  }
}