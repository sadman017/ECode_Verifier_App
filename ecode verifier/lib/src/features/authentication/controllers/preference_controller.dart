import 'package:ecode_verifier/src/features/authentication/models/firestore_service.dart';
import 'package:ecode_verifier/src/features/authentication/screens/signup/signup.dart';
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
  int userIdCounter = 0;


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

  void finishQuestionnaire() {
    final userData = getUserData();
    final userId = generateUserId(); // Call a function to generate the user ID
    FirestoreService().saveUserData(userId, userData);
    Get.to( SignupPage(userId: userId));
  }

  String generateUserId() {
    userIdCounter++; // Increment the counter for each new user
    return 'user$userIdCounter';
  }
}
