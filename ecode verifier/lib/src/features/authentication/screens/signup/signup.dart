import 'package:ecode_verrifier/src/common_widgets/form/form_header.dart';
import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:ecode_verrifier/src/features/authentication/screens/signup/signup_footer.dart';
import 'package:ecode_verrifier/src/features/authentication/screens/signup/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferenceController extends GetxController {
  RxBool hasAllergies = RxBool(false);
  RxBool wantNutritionFacts = RxBool(false);
  RxList<String> selectedAllergens = <String>[].obs;
}

class Signup extends StatelessWidget{
   const Signup({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preference'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Which type of data do you want?"),
          ElevatedButton.icon(onPressed: () => Get.to(const SecondPage()), icon: const Icon(Icons.navigate_next),
          label: const Text('Next'),
           ),
        ],
      )
    );
  }
  

}
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Allergy Related Information')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Do you have Allergies?'),
          ElevatedButton.icon(
            onPressed: () {
              Get.find<PreferenceController>().hasAllergies.value = true;
              Get.to(const ThirdPage());
            },
            icon: const Icon(Icons.navigate_next),
            label: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Allergen Related Information')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Which of the following allergens affect you?'),
          ElevatedButton.icon(
            onPressed: () => Get.to(const FourthPage()),
            icon: const Icon(Icons.navigate_next),
            label: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

class FourthPage extends StatelessWidget {
  const FourthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Facts')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Do you want to see nutrition facts?'),
         
          ElevatedButton.icon(
            onPressed: () {
              
              Get.find<PreferenceController>().wantNutritionFacts.value = true;
              Get.to(const SignupPage());
             
            },
            icon: const Icon(Icons.navigate_next),
            label: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}

class SignupPage extends  StatelessWidget{
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHeaderWidget(size: size, image: 'welcomeScreen', title: 'signupTitle',),
                SignupForm(),
                const SignupFooterWidget(),
              ],
            ),
        )
        ),
    ),

    );
  }

}

class Preference {
  late String preferences;
  late List<String> choices;

  Preference(this.preferences,  this.choices);
}