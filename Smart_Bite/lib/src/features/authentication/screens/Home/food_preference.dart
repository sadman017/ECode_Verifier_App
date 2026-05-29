import 'package:ecode_verifier/src/features/authentication/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodPreference extends StatelessWidget {
  const FoodPreference({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final user = UserController.instance.currentUser.value;
          if (user == null) {
            return const Center(child: Text('No preference data available.'));
          }
          return ListView(
            children: [
              _buildPreferenceCard(
                icon: Icons.restaurant_menu,
                title: 'Diet Type',
                value: user.dietType,
                color: Colors.green,
              ),
              _buildPreferenceCard(
                icon: Icons.health_and_safety,
                title: 'Has Allergies',
                value: user.allergyResponse,
                color: Colors.orange,
              ),
              _buildPreferenceCard(
                icon: Icons.set_meal,
                title: 'Allergen',
                value: user.allergen,
                color: Colors.red,
              ),
              _buildPreferenceCard(
                icon: Icons.local_dining,
                title: 'Show Nutrition Facts',
                value: user.nutritionFactResponse,
                color: Colors.blue,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPreferenceCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
