import 'package:ecode_verifier/src/constants/size.dart';
import 'package:ecode_verifier/src/constants/text_string.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/preference_controller.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/signup_controller.dart';
import 'package:ecode_verifier/src/features/authentication/controllers/user_controller.dart';
import 'package:ecode_verifier/src/features/authentication/models/user_model.dart';
import 'package:ecode_verifier/src/features/authentication/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController(), permanent: true);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
      child: Form(
        key: controller.formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.userName,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                if (value.trim().length < 3) {
                  return 'Name must be at least 3 characters';
                }
                return null;
              },
              decoration: const InputDecoration(
                label: Text(user),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(
              height: formHeight - 20,
            ),
            TextFormField(
              controller: controller.email,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!GetUtils.isEmail(value.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: email,
                hintText: email,
              ),
            ),
            const SizedBox(
              height: formHeight - 20,
            ),
            Obx(
              () => TextFormField(
                controller: controller.password,
                obscureText: !controller.isPasswordVisible.value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key_outlined),
                  labelText: pass,
                  hintText: pass,
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.togglePasswordVisibility();
                    },
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: formHeight - 20,
            ),
            TextFormField(
              controller: controller.mobileNo,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your mobile number';
                }
                if (value.trim().length < 8) {
                  return 'Please enter a valid mobile number';
                }
                return null;
              },
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_android),
                  labelText: number,
                  hintText: number,
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: formHeight - 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (controller.formkey.currentState!.validate()) {
                            controller.isLoading.value = true;
                            try {
                              final credential =
                                  await controller.registerUser(
                                controller.email.text.trim(),
                                controller.password.text.trim(),
                              );

                              if (credential != null &&
                                  credential.user != null) {
                                final uid = credential.user!.uid;
                                final user = UserModal(
                                  id: uid,
                                  email: controller.email.text.trim(),
                                  user: controller.userName.text.trim(),
                                  mobileNo: controller.mobileNo.text.trim(),
                                  dietType: _safeQuestionValue(
                                    () => QuestionController
                                        .instance.dietType.value.name,
                                  ),
                                  allergyResponse: _safeQuestionValue(
                                    () => QuestionController.instance
                                        .hasAllergies.value.name,
                                  ),
                                  allergen: _safeQuestionValue(
                                    () => QuestionController
                                        .instance.allergen.value.name,
                                  ),
                                  nutritionFactResponse: _safeQuestionValue(
                                    () => QuestionController.instance
                                        .wantsNutritionFacts.value.name,
                                  ),
                                );
                                try {
                                  await controller.createUser(uid, user);
                                  UserController.instance.setUser(user);
                                  Get.offAll(() => const Home());
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    "Account created but failed to save profile data. Please contact support.",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        Colors.redAccent.withOpacity(0.1),
                                    colorText: Colors.red,
                                  );
                                }
                              }
                            } finally {
                              controller.isLoading.value = false;
                            }
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(signup.toUpperCase()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _safeQuestionValue(String Function() getter) {
    if (Get.isRegistered<QuestionController>()) {
      try {
        return getter();
      } catch (_) {
        return '';
      }
    }
    return '';
  }
}
