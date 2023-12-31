import 'package:get/get.dart';

enum DietType { halalHaram, vegetarian, vegan }
enum AllergyResponse { yes, no }
enum Allergen { milk, fish, egg, gluten }
enum NutritionFactResponse { yes, no }

class QuestionController extends GetxController {
  static QuestionController get instance => Get.find();
 var dietType = DietType.halalHaram.obs;
 var hasAllergies = AllergyResponse.no.obs;
 var allergen = Allergen.milk.obs;
 var wantsNutritionFacts = NutritionFactResponse.no.obs;
 var currentPage = 0.obs;
 void selectDietType(DietType value) {
   dietType.value = value;
 }

 void selectHasAllergies(AllergyResponse value) {
   hasAllergies.value = value;
 }

 void selectAllergen(Allergen value) {
   allergen.value = value;
 }

 void selectWantsNutritionFacts(NutritionFactResponse value) {
   wantsNutritionFacts.value = value;
 }
  void nextPage() {
  currentPage.value++;
 }
}
