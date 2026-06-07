part of 'topics_bloc.dart';

abstract class TopicsEvent {}

class TopicsLoadRequested extends TopicsEvent {}

class TopicsCreateRequested extends TopicsEvent {
  final String title;
  final String authorName;
  final String authorId;
  TopicsCreateRequested({
    required this.title,
    required this.authorName,
    required this.authorId,
  });
}