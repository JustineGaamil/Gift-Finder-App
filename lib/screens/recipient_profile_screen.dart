import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipient.dart';

class RecipientProfileScreen extends StatefulWidget {
  final Recipient? recipient;

  const RecipientProfileScreen({super.key, this.recipient});

  @override
  State<RecipientProfileScreen> createState() => _RecipientProfileScreenState();
}

class _RecipientProfileScreenState extends State<RecipientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _relationshipController;
  String _selectedGender = 'Male';
  List<String> _selectedInterests = [];

  final List<String> _availableInterests = [
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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipient?.name ?? '');
    _ageController = TextEditingController(
      text: widget.recipient?.age.toString() ?? '',
    );
    _relationshipController = TextEditingController(
      text: widget.recipient?.relationship ?? '',
    );
    if (widget.recipient != null) {
      _selectedGender = widget.recipient!.gender;
      _selectedInterests = List.from(widget.recipient!.interests);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _saveRecipient() {
    if (_formKey.currentState!.validate()) {
      final recipient = Recipient(
        id: widget.recipient?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        interests: _selectedInterests,
        relationship: _relationshipController.text,
      );

      final box = Hive.box<Recipient>('recipients');
      if (widget.recipient != null) {
        box.put(widget.recipient!.id, recipient);
      } else {
        box.put(recipient.id, recipient);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipient == null ? 'Add Recipient' : 'Edit Recipient'),
        centerTitle: true,
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
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: ['Male', 'Female', 'Other']
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
            TextFormField(
              controller: _relationshipController,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a relationship';
                }
                return null;
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
              children: _availableInterests.map((interest) {
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
            ElevatedButton(
              onPressed: _saveRecipient,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.recipient == null ? 'Add Recipient' : 'Save Changes',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 