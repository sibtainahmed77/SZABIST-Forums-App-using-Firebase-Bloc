part of 'replies_bloc.dart';

abstract class RepliesEvent {}

class RepliesLoadRequested extends RepliesEvent {
  final String topicId;
  RepliesLoadRequested({required this.topicId});
}

class RepliesAddRequested extends RepliesEvent {
  final String topicId;
  final String content;
  final String authorName;
  final String authorId;
  RepliesAddRequested({
    required this.topicId,
    required this.content,
    required this.authorName,
    required this.authorId,
  });
}