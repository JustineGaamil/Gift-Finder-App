import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipient.dart';

class AddRecipientScreen extends StatefulWidget {
  const AddRecipientScreen({super.key});

  @override
  State<AddRecipientScreen> createState() => _AddRecipientScreenState();
}

class _AddRecipientScreenState extends State<AddRecipientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedRelationship = 'Family';
  String _selectedGender = 'Male';
  List<String> _selectedInterests = [];

  final List<String> _relationships = [
    'Family',
    'Friend',
    'Colleague',
    'Partner',
    'Other',
  ];

  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
  ];

  final List<String> _interests = [
    'Sports',
    'Books',
    'Tech',
    'Fashion',
    'Music',
    'Art',
    'Cooking',
    'Travel',
    'Gaming',
    'Fitness',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipient() async {
    if (_formKey.currentState!.validate()) {
      final recipient = Recipient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        relationship: _selectedRelationship,
        gender: _selectedGender,
        interests: _selectedInterests,
      );

      final box = Hive.box<Recipient>('recipients');
      await box.put(recipient.id, recipient);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipient'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
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
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an age';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                final age = int.parse(value);
                if (age < 0 || age > 120) {
                  return 'Please enter a valid age';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              items: _genders
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRelationship,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                prefixIcon: Icon(Icons.people_outline),
                border: OutlineInputBorder(),
              ),
              items: _relationships
                  .map((relationship) => DropdownMenuItem(
                        value: relationship,
                        child: Text(relationship),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRelationship = value!;
                });
              },
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saveRecipient,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Add Recipient'),
            ),
          ],
        ),
      ),
    );
  }
} 