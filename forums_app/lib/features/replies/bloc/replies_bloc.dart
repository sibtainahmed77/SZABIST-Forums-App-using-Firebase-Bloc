import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_services/firebase_services.dart';

part 'replies_event.dart';
part 'replies_state.dart';

class RepliesBloc extends Bloc<RepliesEvent, RepliesState> {
  final ForumService _forumService;

  RepliesBloc({required ForumService forumService})
      : _forumService = forumService,
        super(RepliesInitial()) {
    on<RepliesLoadRequested>(_onLoad);
    on<RepliesAddRequested>(_onAdd);
  }

  Future<void> _onLoad(RepliesLoadRequested event, Emitter<RepliesState> emit) async {
    emit(RepliesLoading());
    await emit.forEach(
      _forumService.getReplies(event.topicId),
      onData: (snapshot) {
        final replies = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {'id': doc.id, ...data};
        }).toList();
        return RepliesLoaded(replies: replies);
      },
      onError: (_, __) => RepliesError(message: 'Failed to load replies.'),
    );
  }

  Future<void> _onAdd(RepliesAddRequested event, Emitter<RepliesState> emit) async {
    try {
      await _forumService.addReply(
        topicId: event.topicId,
        content: event.content,
        authorName: event.authorName,
        authorId: event.authorId,
      );
    } catch (e) {
      emit(RepliesError(message: 'Failed to post reply.'));
    }
  }
}