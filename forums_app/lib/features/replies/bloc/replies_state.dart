part of 'replies_bloc.dart';

abstract class RepliesState {}

class RepliesInitial extends RepliesState {}
class RepliesLoading extends RepliesState {}
class RepliesError extends RepliesState {
  final String message;
  RepliesError({required this.message});
}

class RepliesLoaded extends RepliesState {
  final List<Map<String, dynamic>> replies;
  RepliesLoaded({required this.replies});
}