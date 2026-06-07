import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_services/firebase_services.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/replies_bloc.dart';

class TopicDetailPage extends StatefulWidget {
  final String topicId;
  final String topicTitle;

  const TopicDetailPage({
    super.key,
    required this.topicId,
    required this.topicTitle,
  });

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final _replyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<RepliesBloc>().add(
          RepliesLoadRequested(topicId: widget.topicId),
        );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _submitReply() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<RepliesBloc>().add(RepliesAddRequested(
              topicId: widget.topicId,
              content: _replyController.text.trim(),
              authorName: authState.email,
              authorId: authState.userId,
            ));
        _replyController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RepliesBloc(
        forumService: context.read<ForumService>(),
      )..add(RepliesLoadRequested(topicId: widget.topicId)),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.topicTitle)),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<RepliesBloc, RepliesState>(
                builder: (context, state) {
                  if (state is RepliesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is RepliesError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is RepliesLoaded) {
                    if (state.replies.isEmpty) {
                      return const Center(child: Text('No replies yet. Be first!'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.replies.length,
                      itemBuilder: (context, index) {
                        final reply = state.replies[index];
                        final createdAt = reply['createdAt'] as Timestamp?;
                        final date = createdAt != null
                            ? DateFormat('d MMM yyyy, h:mm a')
                                .format(createdAt.toDate())
                            : 'Just now';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      child: Icon(Icons.person, size: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(reply['authorName'] ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(date,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(reply['content'] ?? ''),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            // Reply input box at the bottom
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _replyController,
                        decoration: const InputDecoration(
                          hintText: 'Write a reply...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Reply cannot be empty'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _submitReply,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}