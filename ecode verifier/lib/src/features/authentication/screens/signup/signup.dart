import 'package:ecode_verifier/src/common_widgets/form/form_header.dart';
import 'package:ecode_verifier/src/constants/image_strings.dart';
import 'package:ecode_verifier/src/constants/size.dart';
import 'package:ecode_verifier/src/constants/text_string.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/preference_controller.dart';
import 'package:ecode_verifier/src/features/authentication/screens/signup/signup_footer.dart';
import 'package:ecode_verifier/src/features/authentication/screens/signup/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionPage extends StatelessWidget {
 final controller = Get.put(QuestionController());

   QuestionPage({super.key});

 @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Questions')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Obx(() {
            switch (controller.currentPage.value) {
              case 0:
               return Column(
                children: [
                  const Text('Which type of data do you want?'),
                  ...DietType.values.map((e) {
                    return ListTile(
                      title: Text(e.toString().split('.').last),
                      trailing: Radio(
                        value: e,
                        groupValue: controller.dietType.value,
                        onChanged: (DietType? value) {
                          controller.selectDietType(value!);
                        },
                      ),
                    );
                  }).toList(),
                ],
               );
              case 1:
               return Column(
                children: [
                  const Text('Do you have allergies?'),
                  ...AllergyResponse.values.map((e) {
                    return ListTile(
                      title: Text(e.toString().split('.').last),
                      trailing: Radio(
                        value: e,
                        groupValue: controller.hasAllergies.value,
                        onChanged: (AllergyResponse? value) {
                          controller.selectHasAllergies(value!);
                        },
                      ),
                    );
                  }).toList(),
                ],
               );
              case 2:
               return Column(
                children: [
                  const Text('Specify your allergen:'),
                  ...Allergen.values.map((e) {
                    return ListTile(
                      title: Text(e.toString().split('.').last),
                      trailing: Radio(
                        value: e,
                        groupValue: controller.allergen.value,
                        onChanged: (Allergen? value) {
                          controller.selectAllergen(value!);
                        },
                      ),
                    );
                  }).toList(),
                ],
               );
              case 3:
               return Column(
                children: [
                  const Text('Do you want to see the nutrition facts?'),
                  ...NutritionFactResponse.values.map((e) {
                    return ListTile(
                      title: Text(e.toString().split('.').last),
                      trailing: Radio(
                        value: e,
                        groupValue: controller.wantsNutritionFacts.value,
                        onChanged: (NutritionFactResponse? value) {
                          controller.selectWantsNutritionFacts(value!);
                        },
                      ),
                    );
                  }).toList(),
                ],
               );
              default:
               return const Text('Thank you for completing the survey!');
            }
          }),
          ElevatedButton(
            child: Text(controller.currentPage.value == 3 ? 'Finish' : 'Next'),
            onPressed: () {
              if (controller.currentPage.value == 3) {
                Get.to(const SignupPage());
              } else {
                controller.nextPage();
              }
            },
          ),
        ],
      ),
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
                FormHeaderWidget(size: size, image: welcomeScreen, title: signupTitle,),
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

