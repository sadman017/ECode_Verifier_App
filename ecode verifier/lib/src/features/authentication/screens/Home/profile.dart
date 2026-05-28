import 'package:ecode_verifier/src/features/authentication/controllers/user_controller.dart';
import 'package:ecode_verifier/src/features/authentication/screens/Home/food_preference.dart';
import 'package:ecode_verifier/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            final user = UserController.instance.currentUser.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/images/download.jpeg'),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: const Text('Change Profile Picture'),
                ),
                const SizedBox(height: 30.0),
                const Text("Profile Information",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Gap(10),
                if (user != null) ...[
                  _buildInfoTile(Icons.person, "Name", user.user),
                  _buildInfoTile(Icons.email, "Email", user.email),
                  _buildInfoTile(Icons.phone, "Mobile", user.mobileNo),
                  _buildInfoTile(Icons.restaurant, "Diet Type", user.dietType),
                  _buildInfoTile(
                      Icons.health_and_safety, "Allergies", user.allergyResponse),
                  _buildInfoTile(
                      Icons.set_meal, "Allergen", user.allergen),
                  _buildInfoTile(Icons.local_dining, "Nutrition Facts",
                      user.nutritionFactResponse),
                ] else ...[
                  const Text("No user data available."),
                ],
                const Gap(20),
                ListTile(
                  leading: const Icon(Icons.fastfood, color: Colors.green),
                  title: Text("Food Preference",
                      style: Theme.of(context).textTheme.titleLarge),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.grey),
                  onTap: () {
                    Get.to(() => const FoodPreference());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.purple),
                  title: Text("App Settings",
                      style: Theme.of(context).textTheme.titleLarge),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.grey),
                ),
                ListTile(
                  leading: const Icon(Icons.contact_mail, color: Colors.orange),
                  title: Text("Contact Us",
                      style: Theme.of(context).textTheme.titleLarge),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.grey),
                ),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Logout',
                        middleText: 'Are you sure you want to log out?',
                        textConfirm: 'Logout',
                        textCancel: 'Cancel',
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.red,
                        onConfirm: () {
                          Get.back();
                          AuthenticationRepository.instance.logout();
                        },
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
