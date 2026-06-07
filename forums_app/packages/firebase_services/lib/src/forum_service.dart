import 'package:cloud_firestore/cloud_firestore.dart';

class ForumService {
  final FirebaseFirestore _db;

  ForumService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  // ─── TOPICS ───────────────────────────────────────────────

  // Get all topics, newest first, as a real-time stream
  Stream<QuerySnapshot> getTopics() {
    return _db
        .collection('forums')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Create a new topic
  Future<void> createTopic({
    required String title,
    required String authorName,
    required String authorId,
  }) {
    return _db.collection('forums').add({
      'title': title,
      'authorName': authorName,
      'authorId': authorId,
      'createdAt': FieldValue.serverTimestamp(),
      'replyCount': 0,
    });
  }

  // ─── REPLIES ──────────────────────────────────────────────

  // Get all replies for a topic, oldest first
  Stream<QuerySnapshot> getReplies(String topicId) {
    return _db
        .collection('forums')
        .doc(topicId)
        .collection('replies')
        .orderBy('createdAt')
        .snapshots();
  }

  // Add a reply AND increment the topic's replyCount atomically
  Future<void> addReply({
    required String topicId,
    required String content,
    required String authorName,
    required String authorId,
  }) async {
    final batch = _db.batch();

    // Reference to the new reply document
    final replyRef = _db
        .collection('forums')
        .doc(topicId)
        .collection('replies')
        .doc(); // auto-generate id

    // Reference to the parent topic
    final topicRef = _db.collection('forums').doc(topicId);

    batch.set(replyRef, {
      'content': content,
      'authorName': authorName,
      'authorId': authorId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.update(topicRef, {
      'replyCount': FieldValue.increment(1),
    });

    await batch.commit();
  }
}