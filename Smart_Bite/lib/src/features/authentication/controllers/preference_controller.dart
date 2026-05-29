import 'package:ecode_verifier/src/features/authentication/screens/signup/signup.dart';
import 'package:get/get.dart';

enum DietType { halalHaram, vegan, vegetarian }

enum AllergyResponse { yes, no }

enum Allergen { gluten, dairy, nuts, soy, none }

enum NutritionFactResponse { yes, no }

class QuestionController extends GetxController {
  static QuestionController get instance => Get.find();

  RxInt currentPage = 0.obs;
  Rx<DietType> dietType = DietType.halalHaram.obs;
  Rx<AllergyResponse> hasAllergies = AllergyResponse.no.obs;
  Rx<Allergen> allergen = Allergen.none.obs;
  Rx<NutritionFactResponse> wantsNutritionFacts = NutritionFactResponse.yes.obs;

  void selectDietType(DietType value) => dietType.value = value;
  void selectHasAllergies(AllergyResponse value) => hasAllergies.value = value;
  void selectAllergen(Allergen value) => allergen.value = value;
  void selectWantsNutritionFacts(NutritionFactResponse value) =>
      wantsNutritionFacts.value = value;

  void nextPage() {
    if (currentPage.value < 3) {
      currentPage.value++;
    }
  }

  Map<String, dynamic> getUserData() {
    return {
      'dietType': dietType.value.name,
      'hasAllergies': hasAllergies.value.name,
      'allergen': allergen.value.name,
      'wantsNutritionFacts': wantsNutritionFacts.value.name,
    };
  }

  void finishQuestionnaire() {
    Get.to(() => const SignupPage());
  }
}
