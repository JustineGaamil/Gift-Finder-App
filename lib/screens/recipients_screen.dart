import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipient.dart';
import '../models/gift_suggestion.dart';
import 'gift_suggestion_screen.dart';
import 'add_recipient_screen.dart';

class RecipientsScreen extends StatelessWidget {
  const RecipientsScreen({super.key});

  Future<void> _deleteRecipient(BuildContext context, Recipient recipient) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipient'),
        content: Text('Are you sure you want to delete ${recipient.name}? This will also delete all their gift suggestions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Delete all gift suggestions for this recipient
      final suggestionsBox = Hive.box<GiftSuggestion>('gift_suggestions');
      final suggestions = suggestionsBox.values
          .where((suggestion) => suggestion.recipientId == recipient.id)
          .toList();
      
      for (var suggestion in suggestions) {
        await suggestion.delete();
      }

      // Delete the recipient
      await recipient.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipients'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Recipient>('recipients').listenable(),
        builder: (context, Box<Recipient> box, _) {
          final recipients = box.values.toList();
          
          if (recipients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recipients yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a recipient to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddRecipientScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Recipient'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipients.length,
            itemBuilder: (context, index) {
              final recipient = recipients[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      recipient.name[0],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  title: Text(
                    recipient.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    '${recipient.age} years • ${recipient.relationship}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteRecipient(context, recipient),
                        color: Colors.red,
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftSuggestionScreen(
                          recipient: recipient,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecipientScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 