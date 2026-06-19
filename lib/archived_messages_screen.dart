// archived_messages_screen.dart
// FINAL STABLE PREMIUM VERSION
// ✅ NO SNACKBAR
// ✅ CUSTOM UNDO BAR
// ✅ UNDO AUTO HIDES IN 2 SECONDS
// ✅ SAFE DISMISSIBLE
// ✅ NO RED SCREEN
// ✅ RESTORE WORKS
// ✅ DELETE WORKS
// ✅ PREMIUM UI
// ✅ FULLY STABLE

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'message_detail_screen.dart';

class ArchivedMessagesScreen extends StatefulWidget {
  const ArchivedMessagesScreen({super.key});

  @override
  State<ArchivedMessagesScreen> createState() =>
      _ArchivedMessagesScreenState();
}

class _ArchivedMessagesScreenState
    extends State<ArchivedMessagesScreen> {

  List<Map<String, dynamic>> archivedMessages = [];

  bool showUndo = false;

  String undoText = "";

  VoidCallback? undoAction;

  Timer? undoTimer;

  @override
  void initState() {

    super.initState();

    loadArchivedMessages();
  }

  @override
  void dispose() {

    undoTimer?.cancel();

    super.dispose();
  }

  // =========================================================
  // LOAD
  // =========================================================

  Future<void> loadArchivedMessages() async {

    final prefs =
        await SharedPreferences.getInstance();

    final stored =
        prefs.getStringList(
              "archived_messages",
            ) ??
            [];

    List<Map<String, dynamic>> loaded = [];

    for (var item in stored) {

      try {

        final decoded =
            jsonDecode(item);

        if (decoded is Map<String, dynamic>) {

          loaded.add(decoded);
        }

      } catch (_) {}
    }

    if (mounted) {

      setState(() {

        archivedMessages = loaded;
      });
    }
  }

  // =========================================================
  // SAVE
  // =========================================================

  Future<void> saveArchivedMessages() async {

    final prefs =
        await SharedPreferences.getInstance();

    final encoded =
        archivedMessages.map((e) {

      return jsonEncode(e);

    }).toList();

    await prefs.setStringList(
      "archived_messages",
      encoded,
    );
  }

  // =========================================================
  // CUSTOM UNDO BAR
  // =========================================================

  void showUndoBar({

    required String text,

    required VoidCallback onUndo,

  }) {

    undoTimer?.cancel();

    setState(() {

      showUndo = true;

      undoText = text;

      undoAction = onUndo;
    });

    undoTimer = Timer(

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

  // =========================================================
  // RESTORE
  // =========================================================

  Future<void> unarchiveMessage(
    Map<String, dynamic> message,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final futureMessages =
        prefs.getStringList(
              "future_messages",
            ) ??
            [];

    final restored =
        Map<String, dynamic>.from(
      message,
    );

    restored["mood"] =
        restored["mood"] ?? "Hopeful";

    futureMessages.add(
      jsonEncode(restored),
    );

    await prefs.setStringList(
      "future_messages",
      futureMessages,
    );

    final removedIndex =
        archivedMessages.indexOf(message);

    setState(() {

      archivedMessages.remove(message);
    });

    await saveArchivedMessages();

    showUndoBar(

      text: "Memory restored 💜",

      onUndo: () async {

        final updatedFuture =
            prefs.getStringList(
                  "future_messages",
                ) ??
                [];

        updatedFuture.remove(
          jsonEncode(restored),
        );

        await prefs.setStringList(
          "future_messages",
          updatedFuture,
        );

        setState(() {

          archivedMessages.insert(
            removedIndex,
            message,
          );
        });

        await saveArchivedMessages();
      },
    );
  }

  // =========================================================
  // DELETE
  // =========================================================

  Future<void> deleteArchivedMessage(
    int index,
    Map<String, dynamic> message,
  ) async {

    final deleted =
        Map<String, dynamic>.from(
      message,
    );

    setState(() {

      archivedMessages.removeAt(index);
    });

    await saveArchivedMessages();

    showUndoBar(

      text: "Archived memory deleted 🗑️",

      onUndo: () async {

        setState(() {

          archivedMessages.insert(
            index,
            deleted,
          );
        });

        await saveArchivedMessages();
      },
    );
  }

  // =========================================================
  // DATE FORMAT
  // =========================================================

  String formatDate(String date) {

    try {

      return DateFormat(
        "dd MMM yyyy • hh:mm a",
      ).format(
        DateTime.parse(date),
      );

    } catch (_) {

      return "Unknown date";
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF6F1FF),

      body: Stack(

        children: [

          // =========================================================
          // BACKGROUND
          // =========================================================

          Positioned(

            top: -120,
            left: -100,

            child: Container(

              width: 280,
              height: 280,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color:
                    Colors.deepPurple
                        .withOpacity(0.08),
              ),
            ),
          ),

          Positioned(

            bottom: -160,
            right: -120,

            child: Container(

              width: 320,
              height: 320,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color:
                    Colors.purple
                        .withOpacity(0.05),
              ),
            ),
          ),

          // =========================================================
          // MAIN
          // =========================================================

          SafeArea(

            child: Padding(

              padding:
                  const EdgeInsets.all(22),

              child: Column(

                children: [

                  // =========================================================
                  // HEADER
                  // =========================================================

                  Row(

                    children: [

                      Container(

                        height: 72,
                        width: 72,

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),

                          boxShadow: [

                            BoxShadow(

                              blurRadius: 20,

                              offset:
                                  const Offset(
                                0,
                                10,
                              ),

                              color:
                                  Colors.black
                                      .withOpacity(
                                0.05,
                              ),
                            ),
                          ],
                        ),

                        child: IconButton(

                          onPressed: () {

                            Navigator.pop(
                              context,
                            );
                          },

                          icon: const Icon(

                            Icons.arrow_back_ios_new,

                            color:
                                Color(0xFF24124D),
                          ),
                        ),
                      ),

                      const SizedBox(width: 18),

                      const Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(

                              "Archived Memories 📦",

                              style: TextStyle(

                                fontSize: 30,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    Color(0xFF24124D),
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(

                              "Your protected memories through time 💜",

                              style: TextStyle(

                                fontSize: 15,

                                color:
                                    Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // =========================================================
                  // LIST
                  // =========================================================

                  Expanded(

                    child:
                        archivedMessages
                                .isEmpty

                            ? Center(

                                child: Column(

                                  mainAxisAlignment:
                                      MainAxisAlignment.center,

                                  children: [

                                    Container(

                                      height: 120,
                                      width: 120,

                                      decoration:
                                          BoxDecoration(

                                        gradient:
                                            LinearGradient(

                                          colors: [

                                            Colors.deepPurple
                                                .withOpacity(
                                              0.15,
                                            ),

                                            Colors.purple
                                                .withOpacity(
                                              0.05,
                                            ),
                                          ],
                                        ),

                                        shape:
                                            BoxShape.circle,
                                      ),

                                      child:
                                          const Center(

                                        child: Text(

                                          "📦",

                                          style:
                                              TextStyle(
                                            fontSize: 52,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 24,
                                    ),

                                    const Text(

                                      "No archived memories",

                                      style: TextStyle(

                                        fontSize: 26,

                                        fontWeight:
                                            FontWeight.bold,

                                        color:
                                            Color(
                                          0xFF24124D,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    const Text(

                                      "Archived messages will appear here 💜",

                                      textAlign:
                                          TextAlign.center,

                                      style: TextStyle(

                                        fontSize: 15,

                                        color:
                                            Colors.black54,

                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            : ListView.builder(

                                physics:
                                    const BouncingScrollPhysics(),

                                itemCount:
                                    archivedMessages.length,

                                itemBuilder:
                                    (context, index) {

                                  final msg =
                                      archivedMessages[index];

                                  final text =
                                      msg["text"] ?? "";

                                  final date =
                                      msg["date"] ?? "";

                                  return Padding(

                                    padding:
                                        const EdgeInsets.only(
                                      bottom: 20,
                                    ),

                                    child: Dismissible(

                                      key: ValueKey(
                                        "$date$index",
                                      ),

                                      direction:
                                          DismissDirection.endToStart,

                                      background: Container(

                                        alignment:
                                            Alignment.centerRight,

                                        padding:
                                            const EdgeInsets.only(
                                          right: 28,
                                        ),

                                        decoration:
                                            BoxDecoration(

                                          color:
                                              Colors.redAccent,

                                          borderRadius:
                                              BorderRadius.circular(
                                            32,
                                          ),
                                        ),

                                        child: const Icon(

                                          Icons.delete_rounded,

                                          color:
                                              Colors.white,

                                          size: 32,
                                        ),
                                      ),

                                      confirmDismiss:
                                          (_) async {

                                        await deleteArchivedMessage(
                                          index,
                                          msg,
                                        );

                                        return false;
                                      },

                                      child:
                                          GestureDetector(

                                        onTap: () {

                                          Navigator.push(

                                            context,

                                            MaterialPageRoute(

                                              builder: (_) =>
                                                  MessageDetailScreen(

                                                message: text,

                                                date: date,

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
                                            24,
                                          ),

                                          decoration:
                                              BoxDecoration(

                                            gradient:
                                                const LinearGradient(

                                              colors: [

                                                Colors.white,

                                                Color(
                                                  0xFFF8F2FF,
                                                ),
                                              ],
                                            ),

                                            borderRadius:
                                                BorderRadius.circular(
                                              32,
                                            ),

                                            boxShadow: [

                                              BoxShadow(

                                                blurRadius: 24,

                                                offset:
                                                    const Offset(
                                                  0,
                                                  12,
                                                ),

                                                color:
                                                    Colors.black
                                                        .withOpacity(
                                                  0.05,
                                                ),
                                              ),
                                            ],
                                          ),

                                          child: Row(

                                            children: [

                                              Container(

                                                height: 74,
                                                width: 74,

                                                decoration:
                                                    BoxDecoration(

                                                  gradient:
                                                      const LinearGradient(

                                                    colors: [

                                                      Color(
                                                        0xFF6A35FF,
                                                      ),

                                                      Color(
                                                        0xFFB58CFF,
                                                      ),
                                                    ],
                                                  ),

                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    24,
                                                  ),
                                                ),

                                                child:
                                                    const Icon(

                                                  Icons.archive_rounded,

                                                  color:
                                                      Colors.white,

                                                  size: 34,
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 18,
                                              ),

                                              Expanded(

                                                child: Column(

                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,

                                                  children: [

                                                    const Text(

                                                      "Archived Memory ✨",

                                                      style: TextStyle(

                                                        fontSize: 22,

                                                        fontWeight:
                                                            FontWeight.bold,

                                                        color:
                                                            Color(
                                                          0xFF24124D,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 8,
                                                    ),

                                                    Text(

                                                      formatDate(
                                                        date,
                                                      ),

                                                      style:
                                                          const TextStyle(

                                                        color:
                                                            Colors.black54,
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 14,
                                                    ),

                                                    Text(

                                                      text,

                                                      maxLines: 3,

                                                      overflow:
                                                          TextOverflow.ellipsis,

                                                      style:
                                                          const TextStyle(

                                                        fontSize: 16,

                                                        height: 1.6,

                                                        color:
                                                            Color(
                                                          0xFF2B2147,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 18,
                                                    ),

                                                    GestureDetector(

                                                      onTap: () {

                                                        unarchiveMessage(
                                                          msg,
                                                        );
                                                      },

                                                      child: Container(

                                                        padding:
                                                            const EdgeInsets.symmetric(

                                                          horizontal: 18,
                                                          vertical: 12,
                                                        ),

                                                        decoration:
                                                            BoxDecoration(

                                                          gradient:
                                                              const LinearGradient(

                                                            colors: [

                                                              Color(
                                                                0xFF6A35FF,
                                                              ),

                                                              Color(
                                                                0xFFB58CFF,
                                                              ),
                                                            ],
                                                          ),

                                                          borderRadius:
                                                              BorderRadius.circular(
                                                            18,
                                                          ),
                                                        ),

                                                        child:
                                                            const Text(

                                                          "Restore 💜",

                                                          style: TextStyle(

                                                            color:
                                                                Colors.white,

                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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

          // =========================================================
          // CUSTOM UNDO BAR
          // =========================================================

          if (showUndo)

            Positioned(

              bottom: 22,
              left: 22,
              right: 22,

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
}