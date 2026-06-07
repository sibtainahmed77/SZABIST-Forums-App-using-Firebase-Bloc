part of 'topics_bloc.dart';

abstract class TopicsState {}

class TopicsInitial extends TopicsState {}
class TopicsLoading extends TopicsState {}
class TopicsError extends TopicsState {
  final String message;
  TopicsError({required this.message});
}

class TopicsLoaded extends TopicsState {
  final List<Map<String, dynamic>> topics;
  TopicsLoaded({required this.topics});
}