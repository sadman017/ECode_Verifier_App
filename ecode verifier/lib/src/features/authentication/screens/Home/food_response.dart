// class FootoResponse{
//     String? code;
//     Product product;
//     int? status;
//     String? statusVerbose;

//     FoodtoResponse({
//         required this.code,
//         required this.product,
//         required this.status,
//         required this.statusVerbose,
//     });

//     factory FoodtoResponse.fromJson(Map<String, dynamic> json) => FoodtoResponse(
//         code: json["code"],
//         product: Product.fromJson(json["product"]),
//         status: json["status"],
//         statusVerbose: json["status_verbose"],
//     );


// }

// class Product {
//     String? id;
    
//     List<String?>? additivesDebugTags;
//     int? additivesN;
//     List<String?>? additivesOriginalTags;
//     List<String?>? additivesTags;
//     String? allergens;
//     String? allergensFromIngredients;
//     String? allergensFromUser;
//     List<String?>? allergensHierarchy;
//     String? allergensLc;
//     List<String?>? allergensTags;
//     List<String?>? checkers;
//     List<String?>? checkersTags;
//     String? code;
//     List<String?>? codesTags;
//     String? productId;
//     List<Ingredient?>? ingredients;
//     IngredientsAnalysis? ingredientsAnalysis;
//     List<String?>? ingredientsAnalysisTags;
//     List<String?>? ingredientsDebug;
//     List<String?>? ingredientsHierarchy;
//     List<String?>? ingredientsIdsDebug;
//     String? ingredientsLc;
//     int? ingredientsN;
//     List<String?>? ingredientsNTags;
//     List<String?>? ingredientsOriginalTags;
//     List<String?>? ingredientsTags;
//     String? ingredientsText;
//     String? ingredientsTextDebug;
//     String? ingredientsTextEn;
//     String? ingredientsTextEnImported;
//     String? ingredientsTextWithAllergens;
//     String? ingredientsTextWithAllergensEn;
//     int? knownIngredientsN;
//     String? labels;
//     List<String?> labelsHierarchy;
//     String? labelsLc;
//     String? labelsOld;
//     List<String?>? labelsTags;
//     String? lang;
//     Languages languages;
//     LanguagesCodes languagesCodes;
//     List<String?>? languagesHierarchy;
//     List<String?>? languagesTags;
//     String? productName;
//     String? productNameEn;
//     String? productNameEnImported;
//     String? productQuantity;
//     Product({
//         required this.id,
//         required this.additivesDebugTags,
//         required this.additivesN,
//         required this.additivesOriginalTags,
       
//         required this.additivesTags,
//         required this.allergens,
//         required this.allergensFromIngredients,
//         required this.allergensFromUser,
//         required this.allergensHierarchy,
//         required this.allergensLc,
//         required this.allergensTags,
      
//         required this.checkers,
//         required this.checkersTags,
//         required this.code,
//         required this.codesTags,
//         required this.productId,
//         required this.ingredients,
//         required this.ingredientsAnalysis,
//         required this.ingredientsAnalysisTags,
//         required this.ingredientsDebug,
//         required this.ingredientsHierarchy,
//         required this.ingredientsIdsDebug,
//         required this.ingredientsLc,
//         required this.ingredientsN,
//         required this.ingredientsNTags,
//         required this.ingredientsOriginalTags,
//         required this.ingredientsTags,
//         required this.ingredientsText,
//         required this.ingredientsTextDebug,
//         required this.ingredientsTextEn,
//         required this.ingredientsTextEnImported,
//         required this.ingredientsTextWithAllergens,
//         required this.ingredientsTextWithAllergensEn,
//         required this.knownIngredientsN,
//         required this.labels,
//         required this.labelsHierarchy,
//         required this.labelsLc,
//         required this.labelsOld,
//         required this.labelsTags,
//         required this.lang,
//         required this.languages,
//         required this.languagesCodes,
//         required this.languagesHierarchy,
//         required this.languagesTags,
//         required this.productName,
//         required this.productNameEn,
//         required this.productNameEnImported,
//         required this.productQuantity,
//     });

//     factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["_id"],
//         additivesDebugTags: List<String?>.from(json["additives_debug_tags"]?.map((x) => x)),
//         additivesN: json["additives_n"],
//         additivesOriginalTags: List<String?>.from(json["additives_original_tags"]?.map((x) => x)),
//         additivesTags: List<String?>.from(json["additives_tags"]?.map((x) => x)),
//         allergens: json["allergens"],
//         allergensFromIngredients: json["allergens_from_ingredients"],
//         allergensFromUser: json["allergens_from_user"],
//         allergensHierarchy: List<String?>.from(json["allergens_hierarchy"]?.map((x) => x)),
//         allergensLc: json["allergens_lc"],
//         allergensTags: List<String?>.from(json["allergens_tags"]?.map((x) => x)),
//         checkers: List<String?>.from(json["checkers"]?.map((x) => x)),
//         checkersTags: List<String?>.from(json["checkers_tags"]?.map((x) => x)),
//         code: json["code"],
//         codesTags: List<String?>.from(json["codes_tags"]?.map((x) => x)),
//         productId: json["id"],
//         ingredients: List<Ingredient>.from(json["ingredients"]?.map((x) => Ingredient.fromJson(x))),
//         ingredientsAnalysis: IngredientsAnalysis.fromJson(json["ingredients_analysis"]),
//         ingredientsAnalysisTags: List<String?>.from(json["ingredients_analysis_tags"]?.map((x) => x)),
//         ingredientsDebug: List<String?>.from(json["ingredients_debug"]?.map((x) => x)),
//         ingredientsHierarchy: List<String?>.from(json["ingredients_hierarchy"]?.map((x) => x)),
//         ingredientsIdsDebug: List<String?>.from(json["ingredients_ids_debug"]?.map((x) => x)),
//         ingredientsLc: json["ingredients_lc"],
//         ingredientsN: json["ingredients_n"],
//         ingredientsNTags: List<String?>.from(json["ingredients_n_tags"]?.map((x) => x)),
//         ingredientsOriginalTags: List<String?>.from(json["ingredients_original_tags"]?.map((x) => x)),
//         ingredientsTags: List<String?>.from(json["ingredients_tags"]?.map((x) => x)),
//         ingredientsText: json["ingredients_text"],
//         ingredientsTextDebug: json["ingredients_text_debug"],
//         ingredientsTextEn: json["ingredients_text_en"],
//         ingredientsTextEnImported: json["ingredients_text_en_imported"],
//         ingredientsTextWithAllergens: json["ingredients_text_with_allergens"],
//         ingredientsTextWithAllergensEn: json["ingredients_text_with_allergens_en"],
//         knownIngredientsN: json["known_ingredients_n"],
//         labels: json["labels"],
//         labelsHierarchy: List<String?>.from(json["labels_hierarchy"]?.map((x) => x)),
//         labelsLc: json["labels_lc"],
//         labelsOld: json["labels_old"],
//         labelsTags: List<String?>.from(json["labels_tags"]?.map((x) => x)),
//         lang: json["lang"],
//         languages: Languages.fromJson(json["languages"]),
//         languagesCodes: LanguagesCodes.fromJson(json["languages_codes"]),
//         languagesHierarchy: List<String?>.from(json["languages_hierarchy"]?.map((x) => x)),
//         languagesTags: List<String?>.from(json["languages_tags"]?.map((x) => x)),
//         productName: json["product_name"],
//         productNameEn: json["product_name_en"],
//         productNameEnImported: json["product_name_en_imported"],
//         productQuantity: json["product_quantity"],
//     );


// }



// class Ingredient {
//     HasSubIngredients? hasSubIngredients;
//     String? id;
//     double? percentEstimate;
//     double? percentMax;
//     double? percentMin;
//     int? rank;
//     String? text;
//     HasSubIngredients? vegan;
//     HasSubIngredients? vegetarian;
//     String? ciqualFoodCode;
//     String? ciqualProxyFoodCode;
//     String? processing;

//     Ingredient({
//         this.hasSubIngredients,
//         required this.id,
//         required this.percentEstimate,
//         required this.percentMax,
//         required this.percentMin,
//         this.rank,
//         required this.text,
//         this.vegan,
//         this.vegetarian,
//         this.ciqualFoodCode,
//         this.ciqualProxyFoodCode,
//         this.processing,
//     });

//     factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
//         hasSubIngredients: hasSubIngredientsValues.map[json["has_sub_ingredients"]]!,
//         id: json["id"],
//         percentEstimate: json["percent_estimate"]?.toDouble(),
//         percentMax: json["percent_max"]?.toDouble(),
//         percentMin: json["percent_min"]?.toDouble(),
//         rank: json["rank"],
//         text: json["text"],
//         vegan: hasSubIngredientsValues.map[json["vegan"]]!,
//         vegetarian: hasSubIngredientsValues.map[json["vegetarian"]]!,
//         ciqualFoodCode: json["ciqual_food_code"],
//         ciqualProxyFoodCode: json["ciqual_proxy_food_code"],
//         processing: json["processing"],
//     );

//     Map<String, dynamic> toJson() => {
//         "has_sub_ingredients": hasSubIngredientsValues.reverse[hasSubIngredients],
//         "id": id,
//         "percent_estimate": percentEstimate,
//         "percent_max": percentMax,
//         "percent_min": percentMin,
//         "rank": rank,
//         "text": text,
//         "vegan": hasSubIngredientsValues.reverse[vegan],
//         "vegetarian": hasSubIngredientsValues.reverse[vegetarian],
//         "ciqual_food_code": ciqualFoodCode,
//         "ciqual_proxy_food_code": ciqualProxyFoodCode,
//         "processing": processing,
//     };
// }

// enum HasSubIngredients {
//     MAYBE,
//     YES
// }

// final hasSubIngredientsValues = EnumValues({
//     "maybe": HasSubIngredients.MAYBE,
//     "yes": HasSubIngredients.YES
// });

// class IngredientsAnalysis {
//     List<String?>? enPalmOilContentUnknown;
//     List<String?>? enVeganStatusUnknown;
//     List<String?>? enVegetarianStatusUnknown;

//     IngredientsAnalysis({
//         required this.enPalmOilContentUnknown,
//         required this.enVeganStatusUnknown,
//         required this.enVegetarianStatusUnknown,
//     });

//     factory IngredientsAnalysis.fromJson(Map<String, dynamic> json) => IngredientsAnalysis(
//         enPalmOilContentUnknown: List<String?>.from(json["en:palm-oil-content-unknown"]?.map((x) => x)),
//         enVeganStatusUnknown: List<String?>.from(json["en:vegan-status-unknown"]?.map((x) => x)),
//         enVegetarianStatusUnknown: List<String?>.from(json["en:vegetarian-status-unknown"]?.map((x) => x)),
//     );

// }

// class Languages {
//     int enEnglish;

//     Languages({
//         required this.enEnglish,
//     });

//     factory Languages.fromJson(Map<String, dynamic> json) => Languages(
//         enEnglish: json["en:english"],
//     );

//     Map<String, dynamic> toJson() => {
//         "en:english": enEnglish,
//     };
// }

// class LanguagesCodes {
//     int en;

//     LanguagesCodes({
//         required this.en,
//     });

//     factory LanguagesCodes.fromJson(Map<String, dynamic> json) => LanguagesCodes(
//         en: json["en"],
//     );

//     Map<String, dynamic> toJson() => {
//         "en": en,
//     };
// }

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         reverseMap = map.map((k, v) => MapEntry(v, k));
//         return reverseMap;
//     }
// }
