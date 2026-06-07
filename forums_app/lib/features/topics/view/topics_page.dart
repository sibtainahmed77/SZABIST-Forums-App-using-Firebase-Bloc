import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../replies/view/topic_detail_page.dart';
import '../bloc/topics_bloc.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});
  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TopicsBloc>().add(TopicsLoadRequested());
  }

  void _showCreateTopicDialog() {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Start New Topic'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Topic Title',
              border: OutlineInputBorder(),
            ),
            validator: (val) =>
                val == null || val.trim().isEmpty ? 'Title cannot be empty' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  context.read<TopicsBloc>().add(TopicsCreateRequested(
                        title: controller.text.trim(),
                        authorName: authState.email,
                        authorId: authState.userId,
                      ));
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szabist Forums'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(AuthSignOutRequested()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateTopicDialog,
        icon: const Icon(Icons.add),
        label: const Text('Start New Topic'),
      ),
      body: BlocBuilder<TopicsBloc, TopicsState>(
        builder: (context, state) {
          if (state is TopicsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TopicsError) {
            return Center(child: Text(state.message));
          }
          if (state is TopicsLoaded) {
            if (state.topics.isEmpty) {
              return const Center(child: Text('No topics yet. Start one!'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.topics.length,
              itemBuilder: (context, index) {
                final topic = state.topics[index];
                final createdAt = topic['createdAt'] as Timestamp?;
                final date = createdAt != null
                    ? DateFormat('d MMM yyyy').format(createdAt.toDate())
                    : 'Just now';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(topic['title'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('By ${topic['authorName']} • $date'),
                    trailing: Chip(
                      label: Text('${topic['replyCount'] ?? 0} replies'),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopicDetailPage(
                          topicId: topic['id'],
                          topicTitle: topic['title'],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}