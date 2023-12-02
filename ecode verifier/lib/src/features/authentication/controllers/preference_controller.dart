// import 'package:ecode_verrifier/src/features/authentication/screens/signup/signup.dart';
// import 'package:get/get.dart';

// class PreferenceController extends GetxController{
//   var preferenceIndex = 0.obs;
//   var selectedChoice = "".obs;
//   List<Preference> preferences = [
//     Preference("Which type of data do you want?",["Halal-Haram", "Vegeterian", "Vegan", "All the above"]),
//     Preference("Do you have allergies?",["Yes", "No"]),
//     Preference("Which of the following allergen effects you?",["Gluten","Milk","Eggs","Nuts","Peanuts","Sesame seeds","Soybeans","Celery","Mustard","Fish","Lupin","Crustaceans","Molluscs","Sulphur dioxide and sulphite"]),
//     Preference("DO you prefer getting nutrition facts?", ["Yes","No"]),
//   ];

//   void selectChoice(String choice){
//     selectedChoice.value =choice;
//   }
//   void nextPreference(){
//     if(selectedChoice.isNotEmpty){
//       if(preferenceIndex.value< preferences.length-1){
//         preferenceIndex++;
//         selectedChoice.value = "";
//       }
//     }
//   }
  
// }