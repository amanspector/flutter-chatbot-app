import 'package:chatbot_app/repository/gemini_repo.dart';
import 'package:chatbot_app/services/firebase_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  final FirebaseChatService service;
  final GeminiRepo repo;

  MessageProvider({required this.repo, required this.service});

  String? streamingMessageId;
  String streamingText = "";
  bool isSendingCooldown = false;
  bool isTyping = false;
  bool isStreaming = false;
  bool isStopped = false;
  bool isSkipped = false;
  String? currentChatId;
  int speedinms = 50;
  String? deletingChatId;

  Future<void> sendMessage(String text, String uid) async {
    if (isSendingCooldown) return;

    isSendingCooldown = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      isSendingCooldown = false;
      notifyListeners();
    });

    try {
      if (currentChatId == null) {
        currentChatId = await service.createChat(uid);
        notifyListeners();
      }

      isStreaming = true;
      isTyping = true;
      isStopped = false;
      isSkipped = false;
      streamingText = "";
      streamingMessageId = "temp";
      notifyListeners();

      await service.sendMessage(
        uid: uid,
        chatid: currentChatId!,
        content: text,
        isUser: true,
      );

      final reply = await repo.sendMessage(text);

      if (isStopped) {
        streamingText = "";
        streamingMessageId = null;
        isStreaming = false;
        notifyListeners();
        return;
      }

      String current = "";
      final words = reply.split(" ");

      for (int i = 0; i < words.length; i++) {
        if (isStopped) {
          streamingText = ""; // Clear FIRST
          streamingMessageId = null;
          isStreaming = false;
          isTyping = false;
          notifyListeners();
          // Save what we have so far
          if (current.isNotEmpty) {
            await service.sendMessage(
              uid: uid,
              chatid: currentChatId!,
              content: current,
              isUser: false,
            );
          }
          return;
        }

        if (isSkipped) {
          current = reply;
          streamingText = current;
          notifyListeners();
          break;
        }

        current += (i == 0) ? words[i] : " ${words[i]}";
        streamingText = current;
        notifyListeners();

        await Future.delayed(Duration(milliseconds: 10));

        if (isSkipped) {
          current = reply;
          streamingText = current;
          notifyListeners();
          break;
        }
      }

      if (!isStopped) {
        streamingText = "";
        streamingMessageId = null;
        isTyping = false;
        isStreaming = false;
        notifyListeners();
        await service.sendMessage(
          uid: uid,
          chatid: currentChatId!,
          content: current,
          isUser: false,
        );
        streamingText = "";
      }
    } catch (e) {
      print("Error in sendMessage: $e");

      if (currentChatId != null) {
        await service.sendMessage(
          uid: uid,
          chatid: currentChatId!,
          content: "Error: $e",
          isUser: false,
        );
      }

      streamingText = "";
      streamingMessageId = null;
      isTyping = false;
      isStreaming = false;
      notifyListeners();
    }
  }

  /// Stop message generation
  // Future<void> stopGeneration() async {
  //   repo.stopSending();
  //   isStopped = true;
  //   if (streamingMessageId != null && currentChatId != null) {
  //     final uid = FirebaseAuth.instance.currentUser?.uid;
  //     if (uid != null) {
  //       await service.deleteMessage(
  //         uid: uid,
  //         chatid: currentChatId!,
  //         messageId: streamingMessageId!,
  //       );
  //     }
  //   }
  //   isTyping = false;
  //   isStreaming = false;
  //   streamingText = "";
  //   notifyListeners();
  // }
  Future<void> stopGeneration() async {
    repo.stopSending();
    isStopped = true;
    isTyping = false;
    isStreaming = false;

    // streamingText = "";
    streamingMessageId = null;
    notifyListeners();
  }

  void skipAnimation() {
    isSkipped = true;

    notifyListeners();
  }

  void resetSpeed() {
    isSkipped = false;
    notifyListeners();
  }

  Future<void> createChat(String uid) async {
    currentChatId = await service.createChat(uid);
    notifyListeners();
  }

  void resetChat() {
    currentChatId = null;
    isTyping = false;
    isStreaming = false;
    streamingText = "";
    streamingMessageId = null;
    isStopped = false;
    notifyListeners();
  }

  /// Send message to Firebase
  Future<void> sendMessageToFirebase(
    String uid,
    String content, {
    bool isUser = true,
  }) async {
    if (currentChatId == null) {
      currentChatId = await service.createChat(uid);
      notifyListeners();
    }

    await service.sendMessage(
      uid: uid,
      chatid: currentChatId!,
      content: content,
      isUser: isUser,
    );
  }

  /// Get message stream from Firebase
  Stream<QuerySnapshot>? getMessageStream(String uid) {
    if (currentChatId == null) return null;
    return service.getmessage(uid, currentChatId!);
  }

  /// Get all chats for a user
  Stream<QuerySnapshot>? getChatList(String uid) {
    return service.getAllChats(uid);
  }

  /// Load a specific chat
  Future<void> loadChat(String uid, String chatId) async {
    currentChatId = chatId;
    streamingText = "";
    streamingMessageId = null;
    isStreaming = false;
    notifyListeners();
  }

  /// Delete a chat
  Future<void> deleteChat(String uid, String chatId) async {
    deletingChatId = chatId;
    notifyListeners();

    await service.deleteChat(uid, chatId);
    if (currentChatId == chatId) {
      resetChat();
    }

    deletingChatId = null;
    notifyListeners();
  }
}
