import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/gift.dart';
import '../models/recipient.dart';
import '../models/gift_suggestion.dart';
import '../services/gift_service.dart';
import '../widgets/platform_image.dart';
import '../widgets/app_background.dart';
import 'gift_suggestions_screen.dart';

class GiftSuggestionScreen extends StatefulWidget {
  final Recipient recipient;

  const GiftSuggestionScreen({
    super.key,
    required this.recipient,
  });

  @override
  State<GiftSuggestionScreen> createState() => _GiftSuggestionScreenState();
}

class _GiftSuggestionScreenState extends State<GiftSuggestionScreen> {
  final _giftService = GiftService();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedOccasion = 'All';
  bool _showAvailableOnly = true;
  String _selectedAvailabilityType = 'All';
  RangeValues _priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    _minPriceController.text = _priceRange.start.toStringAsFixed(2);
    _maxPriceController.text = _priceRange.end.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  List<String> get _categories => [
        'All',
        'Tech',
        'Fashion',
        'Home Decor',
        'Books',
        'Sports',
      ];

  List<String> get _occasions => [
        'All',
        'Birthday',
        'Christmas',
        'Valentine\'s Day',
        'Graduation',
      ];

  List<String> get _availabilityTypes => [
        'All',
        'Online',
        'In-store',
      ];

  List<Gift> _getFilteredGifts() {
    var gifts = _giftService.getAllGifts();

    // First filter by interests if no category or occasion is selected
    if (_selectedCategory == 'All' && _selectedOccasion == 'All') {
      gifts = gifts.where((gift) {
        return gift.interests.any((interest) =>
            widget.recipient.interests.contains(interest));
      }).toList();
    } else {
      // If category or occasion is selected, filter by those instead of interests
      if (_selectedCategory != 'All') {
        gifts = gifts.where((gift) => gift.category == _selectedCategory).toList();
      }

      if (_selectedOccasion != 'All') {
        gifts = gifts
            .where((gift) => gift.occasions.contains(_selectedOccasion))
            .toList();
      }
    }

    // Filter by price range
    gifts = gifts
        .where((gift) => gift.price >= _priceRange.start && gift.price <= _priceRange.end)
        .toList();

    // Filter by availability
    if (_showAvailableOnly) {
      gifts = gifts.where((gift) => gift.isAvailable).toList();
    }

    // Filter by availability type
    if (_selectedAvailabilityType != 'All') {
      gifts = gifts
          .where((gift) => gift.availabilityType == _selectedAvailabilityType)
          .toList();
    }

    // Sort gifts by relevance
    if (_selectedCategory == 'All' && _selectedOccasion == 'All') {
      // Sort by matching interests when no category or occasion is selected
      gifts.sort((a, b) {
        final aMatches = a.interests
            .where((interest) => widget.recipient.interests.contains(interest))
            .length;
        final bMatches = b.interests
            .where((interest) => widget.recipient.interests.contains(interest))
            .length;
        return bMatches.compareTo(aMatches);
      });
    } else {
      // Sort by price when category or occasion is selected
      gifts.sort((a, b) => a.price.compareTo(b.price));
    }

    return gifts;
  }

  void _selectGift(Gift gift) {
    final suggestion = GiftSuggestion(
      recipientId: widget.recipient.id,
      giftId: gift.id,
      suggestedAt: DateTime.now(),
    );

    Hive.box<GiftSuggestion>('gift_suggestions').add(suggestion);

    // Navigate to suggestions screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GiftSuggestionsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gifts for ${widget.recipient.name}'),
        centerTitle: true,
      ),
      body: AppBackground(
        child: Column(
          children: [
            // Filters
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Category Filter
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Occasion Filter
                  DropdownButtonFormField<String>(
                    value: _selectedOccasion,
                    decoration: const InputDecoration(
                      labelText: 'Occasion',
                      border: OutlineInputBorder(),
                    ),
                    items: _occasions
                        .map((occasion) => DropdownMenuItem(
                              value: occasion,
                              child: Text(occasion),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOccasion = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Price Range Filter
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price Range',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        labels: RangeLabels(
                          '\$${_priceRange.start.round()}',
                          '\$${_priceRange.end.round()}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            _priceRange = values;
                            _minPriceController.text = values.start.toStringAsFixed(2);
                            _maxPriceController.text = values.end.toStringAsFixed(2);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${_priceRange.start.round()}'),
                          Text('\$${_priceRange.end.round()}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Availability Type
                  DropdownButtonFormField<String>(
                    value: _selectedAvailabilityType,
                    decoration: const InputDecoration(
                      labelText: 'Availability Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _availabilityTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAvailabilityType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  // Available Only Switch
                  SwitchListTile(
                    title: const Text('Show Available Only'),
                    value: _showAvailableOnly,
                    onChanged: (value) {
                      setState(() {
                        _showAvailableOnly = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Gift List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Gift>('gifts').listenable(),
                builder: (context, Box<Gift> box, _) {
                  final gifts = _getFilteredGifts();

                  if (gifts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No gifts found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: gifts.length,
                    itemBuilder: (context, index) {
                      final gift = gifts[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _selectGift(gift),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: PlatformImage(
                                  imagePath: gift.imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gift.name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${gift.price.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}