import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/gift_suggestion.dart';
import '../widgets/platform_image.dart';

class GiftSuggestionsScreen extends StatelessWidget {
  const GiftSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Suggestions'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<GiftSuggestion>('gift_suggestions').listenable(),
        builder: (context, Box<GiftSuggestion> box, _) {
          final suggestions = box.values.toList()
            ..sort((a, b) => b.suggestedAt.compareTo(a.suggestedAt));

          if (suggestions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_giftcard_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No gift suggestions yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gift suggestions will appear here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              final recipient = suggestion.recipient;
              final gift = suggestion.gift;

              if (recipient == null || gift == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipient Info
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          recipient.name[0].toUpperCase(),
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
                        'Age: ${recipient.age} • Gender: ${recipient.gender}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Divider(height: 1),

                    // Gift Info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: PlatformImage(
                              imagePath: gift.imagePath,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gift.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  gift.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      '\$${gift.price.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        gift.category,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Mark as selected
                            },
                            icon: Icon(
                              suggestion.isSelected ? Icons.check_circle : Icons.check_circle_outline,
                              color: suggestion.isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            label: Text(
                              suggestion.isSelected ? 'Selected' : 'Select',
                              style: TextStyle(
                                color: suggestion.isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
} 