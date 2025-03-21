import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/gift.dart';
import '../services/image_service.dart';

class AddGiftScreen extends StatefulWidget {
  const AddGiftScreen({super.key});

  @override
  State<AddGiftScreen> createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Tech';
  List<String> _selectedOccasions = [];
  List<String> _selectedInterests = [];
  XFile? _selectedImage;
  bool _isAvailable = true;
  String _availabilityType = 'Online';

  final List<String> _categories = [
    'Tech',
    'Fashion',
    'Home Decor',
    'Books',
    'Sports',
  ];

  final List<String> _occasions = [
    'Birthday',
    'Christmas',
    'Valentine\'s Day',
    'Anniversary',
    'Graduation',
  ];

  final List<String> _interests = [
    'Tech',
    'Fashion',
    'Sports',
    'Books',
    'Art',
    'Cooking',
    'Travel',
    'Gaming',
    'Fitness',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final imagePath = await ImageService().pickAndSaveImage();
    if (imagePath != null) {
      setState(() {
        _selectedImage = XFile(imagePath);
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveGift() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final gift = Gift(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        category: _selectedCategory,
        occasions: _selectedOccasions,
        interests: _selectedInterests,
        imagePath: _selectedImage!.path,
        isAvailable: _isAvailable,
        availabilityType: _availabilityType,
      );

      final box = Hive.box<Gift>('gifts');
      await box.put(gift.id, gift);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildImagePreview() {
    if (_selectedImage == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to add image',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
    }

    if (kIsWeb) {
      // For web, use NetworkImage with the objectUrl
      return Image.network(
        _selectedImage!.path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          );
        },
      );
    } else {
      // For mobile/desktop, use File
      return Image.file(
        File(_selectedImage!.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gift'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image Selection
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildImagePreview(),
              ),
            ),
            const SizedBox(height: 16),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.card_giftcard),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Price Field
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
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

            // Occasions Selection
            const Text(
              'Occasions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _occasions.map((occasion) {
                return FilterChip(
                  label: Text(occasion),
                  selected: _selectedOccasions.contains(occasion),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedOccasions.add(occasion);
                      } else {
                        _selectedOccasions.remove(occasion);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Interests Selection
            const Text(
              'Interests',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _interests.map((interest) {
                return FilterChip(
                  label: Text(interest),
                  selected: _selectedInterests.contains(interest),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedInterests.add(interest);
                      } else {
                        _selectedInterests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Availability Switch
            SwitchListTile(
              title: const Text('Available'),
              value: _isAvailable,
              onChanged: (value) {
                setState(() {
                  _isAvailable = value;
                });
              },
            ),

            // Availability Type
            DropdownButtonFormField<String>(
              value: _availabilityType,
              decoration: const InputDecoration(
                labelText: 'Availability Type',
                prefixIcon: Icon(Icons.store),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Online', child: Text('Online')),
                DropdownMenuItem(value: 'In-store', child: Text('In-store')),
              ],
              onChanged: (value) {
                setState(() {
                  _availabilityType = value!;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveGift,
        icon: const Icon(Icons.save),
        label: const Text('Save Gift'),
      ),
    );
  }
} 