import 'package:get/get.dart';

enum DietType { halalHaram, vegan, vegetarian }

enum AllergyResponse { yes, no }

enum Allergen { gluten, dairy, nuts, soy, none }

enum NutritionFactResponse { yes, no }

class QuestionController extends GetxController {
  RxInt currentPage = 0.obs;
  Rx<DietType> dietType = DietType.halalHaram.obs;
  Rx<AllergyResponse> hasAllergies = AllergyResponse.no.obs;
  Rx<Allergen> allergen = Allergen.none.obs;
  Rx<NutritionFactResponse> wantsNutritionFacts = NutritionFactResponse.yes.obs;

  void selectDietType(DietType value) => dietType.value = value;
  void selectHasAllergies(AllergyResponse value) => hasAllergies.value = value;
  void selectAllergen(Allergen value) => allergen.value = value;
  void selectWantsNutritionFacts(NutritionFactResponse value) => wantsNutritionFacts.value = value;

  void nextPage() {
    if (currentPage.value < 3) {
      currentPage.value++;
    }
  }

  Map<String, dynamic> getUserData() {
    return {
      'dietType': dietType.value.toString().split('.').last,
      'hasAllergies': hasAllergies.value.toString().split('.').last,
      'allergen': allergen.value.toString().split('.').last,
      'wantsNutritionFacts': wantsNutritionFacts.value.toString().split('.').last,
    };
  }
}
