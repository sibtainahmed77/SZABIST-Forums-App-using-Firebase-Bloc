import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_services/firebase_services.dart';

part 'topics_event.dart';
part 'topics_state.dart';

class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  final ForumService _forumService;

  TopicsBloc({required ForumService forumService})
      : _forumService = forumService,
        super(TopicsInitial()) {
    on<TopicsLoadRequested>(_onLoad);
    on<TopicsCreateRequested>(_onCreate);
  }

  Future<void> _onLoad(TopicsLoadRequested event, Emitter<TopicsState> emit) async {
    emit(TopicsLoading());
    try {
      await emit.forEach(
        _forumService.getTopics(),
        onData: (snapshot) {
          final topics = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {'id': doc.id, ...data};
          }).toList();
          return TopicsLoaded(topics: topics);
        },
        onError: (_, __) => TopicsError(message: 'Failed to load topics.'),
      );
    } catch (e) {
      emit(TopicsError(message: 'Failed to load topics.'));
    }
  }

  Future<void> _onCreate(TopicsCreateRequested event, Emitter<TopicsState> emit) async {
    try {
      await _forumService.createTopic(
        title: event.title,
        authorName: event.authorName,
        authorId: event.authorId,
      );
      // Stream will auto-update the UI, no need to reload manually
    } catch (e) {
      emit(TopicsError(message: 'Failed to create topic.'));
    }
  }
}