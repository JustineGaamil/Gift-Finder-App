import 'package:flutter/material.dart';
import 'package:giftfinderorig/services/hive_services.dart';
import '../services/filter_service.dart';
import '../models/gift.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedOccasion = "Christmas";
  double minPrice = 0;
  double maxPrice = 100;
  List<Gift> filteredGifts = [];

  void applyFilters() async {
    List<Gift> allGifts = await HiveService.getGifts();
    setState(() {
      filteredGifts = filterGifts(allGifts, selectedOccasion, minPrice, maxPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filter Gifts')),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedOccasion,
            items: ['Christmas', 'Valentine\'s', 'Halloween']
                .map((occasion) => DropdownMenuItem(value: occasion, child: Text(occasion)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedOccasion = value!;
              });
            },
          ),
          Slider(
            value: minPrice,
            min: 0,
            max: 500,
            divisions: 10,
            label: '\$$minPrice',
            onChanged: (value) {
              setState(() {
                minPrice = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: applyFilters,
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
