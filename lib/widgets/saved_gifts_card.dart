import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/gift_suggestion.dart';
import '../models/recipient.dart';
import '../models/gift.dart';
import '../widgets/platform_image.dart';
import '../screens/gift_suggestions_screen.dart';

class SavedGiftsCard extends StatelessWidget {
  const SavedGiftsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<GiftSuggestion>('gift_suggestions').listenable(),
      builder: (context, Box<GiftSuggestion> box, _) {
        final suggestions = box.values.toList()
          ..sort((a, b) => b.suggestedAt.compareTo(a.suggestedAt));

        if (suggestions.isEmpty) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.card_giftcard_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No gift suggestions yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gift suggestions will appear here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Gift Suggestions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length.clamp(0, 3), // Show only latest 3 suggestions
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    final recipient = suggestion.recipient;
                    final gift = suggestion.gift;

                    if (recipient == null || gift == null) return const SizedBox.shrink();

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gift.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'Suggested on ${suggestion.suggestedAt.toString().split(' ')[0]}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${gift.price.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: gift.isAvailable
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  gift.isAvailable ? 'Available' : 'Out of Stock',
                                  style: TextStyle(
                                    color: gift.isAvailable ? Colors.green : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index < suggestions.length - 1 && index < 2) const Divider(height: 1),
                      ],
                    );
                  },
                ),
                if (suggestions.length > 3)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GiftSuggestionsScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'View All ${suggestions.length} Suggestions',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
} 