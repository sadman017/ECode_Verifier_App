


class FoodResponse {
    String? code;
    Product? product;
    int? status;
    String? statusVerbose;

    FoodResponse({
        this.code,
        this.product,
        this.status,
        this.statusVerbose,
    });

    factory FoodResponse.fromJson(Map<String, dynamic> json) => FoodResponse(
        code: json["code"],
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
        status: json["status"],
        statusVerbose: json["status_verbose"],
    );

}

class Product {
  
    List<dynamic>? additivesDebugTags;
    int? additivesN;
    int? additivesOldN;
    List<String>? additivesOriginalTags;
    List<String>? additivesTags;
    String? allergens;
    String? allergensFromIngredients;
    String? allergensFromUser;
    String? allergensLc;
    List<String>? allergensTags;
   
    List<Ingredient>? ingredients;
    String? ingredientsTextEn;
    IngredientsAnalysis? ingredientsAnalysis;
    List<String>? ingredientsAnalysisTags;
    String? lang;
    Languages? languages;
    LanguagesCodes? languagesCodes;
    List<String>? languagesHierarchy;
    List<String>? languagesTags;
    String? labels;
    List<String?>? labelsTags;
    Product({
        this.additivesDebugTags,
        this.additivesN,
        this.additivesOldN,
        this.additivesOriginalTags,
        this.additivesTags,
        this.allergens,
        this.allergensFromIngredients,
        this.allergensFromUser,
        this.allergensLc,
        this.allergensTags,

        this.ingredients,
        this.ingredientsAnalysis,
        this.ingredientsAnalysisTags,
        this.ingredientsTextEn,
        this.lang,
        this.languages,
        this.languagesCodes,
        this.languagesHierarchy,
        this.languagesTags,
        this.labels,
        this.labelsTags
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        additivesDebugTags: json["additives_debug_tags"] == null ? [] : List<dynamic>.from(json["additives_debug_tags"]!.map((x) => x)),
        additivesN: json["additives_n"],
        additivesOldN: json["additives_old_n"],
        additivesOriginalTags: json["additives_original_tags"] == null ? [] : List<String>.from(json["additives_original_tags"]!.map((x) => x)),
        additivesTags: json["additives_tags"] == null ? [] : List<String>.from(json["additives_tags"]!.map((x) => x)),
        allergens: json["allergens"],
        allergensFromIngredients: json["allergens_from_ingredients"],
        allergensFromUser: json["allergens_from_user"],
        allergensLc: json["allergens_lc"],
        allergensTags: json["allergens_tags"] == null ? [] : List<String>.from(json["allergens_tags"]!.map((x) => x)),
        ingredients: json["ingredients"] == null ? [] : List<Ingredient>.from(json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
        ingredientsAnalysis: json["ingredients_analysis"] == null ? null : IngredientsAnalysis.fromJson(json["ingredients_analysis"]),
        ingredientsAnalysisTags: json["ingredients_analysis_tags"] == null ? [] : List<String>.from(json["ingredients_analysis_tags"]!.map((x) => x)),
        ingredientsTextEn: json["ingredients_text"],
        lang: json["lang"],
        languages: json["languages"] == null ? null : Languages.fromJson(json["languages"]),
        languagesCodes: json["languages_codes"] == null ? null : LanguagesCodes.fromJson(json["languages_codes"]),
        languagesHierarchy: json["languages_hierarchy"] == null ? [] : List<String>.from(json["languages_hierarchy"]!.map((x) => x)),
        languagesTags: json["languages_tags"] == null ? [] : List<String>.from(json["languages_tags"]!.map((x) => x)),
        labels: json["labels"],
        labelsTags: json["labels_tags"] == null ? [] : List<String>.from(json["labels_tags"]!.map((x) => x)),
        
    );

}

class CategoriesProperties {
    CategoriesProperties();

    factory CategoriesProperties.fromJson(Map<String, dynamic> json) => CategoriesProperties(
    );

    Map<String, dynamic> toJson() => {
    };
}


class Ingredient {
    HasSubIngredients? hasSubIngredients;
    String? id;
    double? percentEstimate;
    String? percentMax;
    String? percentMin;
    int? rank;
    String? text;
    HasSubIngredients? vegan;
    HasSubIngredients? vegetarian;
    String? ciqualFoodCode;
    String? ciqualProxyFoodCode;
    String? processing;

    Ingredient({
        this.hasSubIngredients,
        this.id,
        this.percentEstimate,
        this.percentMax,
        this.percentMin,
        this.rank,
        this.text,
        this.vegan,
        this.vegetarian,
        this.ciqualFoodCode,
        this.ciqualProxyFoodCode,
        this.processing,
    });

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        hasSubIngredients: json["has_sub_ingredients"] == null ? null : hasSubIngredientsValues.map[json["has_sub_ingredients"]]!,
        id: json["id"],
        percentEstimate: json["percent_estimate"]?.toDouble(),
        percentMax: json["percent_max"]?.toString(),
        percentMin: json["percent_min"]?.toString(),
        rank: json["rank"],
        text: json["text"],
        vegan: json["vegan"] == null ? null : hasSubIngredientsValues.map[json["vegan"]]!,
        vegetarian: json["vgeetarian"] == null ? null : hasSubIngredientsValues.map[json["vgeetarian"]]!,
        ciqualFoodCode: json["ciqual_food_code"],
        ciqualProxyFoodCode: json["ciqual_proxy_food_code"],
        processing: json["processing"],
    );

    Map<String, dynamic> toJson() => {
        "has_sub_ingredients": hasSubIngredientsValues.reverse[hasSubIngredients],
        "id": id,
        "percent_estimate": percentEstimate,
        "percent_max": percentMax,
        "percent_min": percentMin,
        "rank": rank,
        "text": text,
        "vegan": hasSubIngredientsValues.reverse[vegan],
        "vegetarian": hasSubIngredientsValues.reverse[vegetarian],
        "ciqual_food_code": ciqualFoodCode,
        "ciqual_proxy_food_code": ciqualProxyFoodCode,
        "processing": processing,
    };
}

enum HasSubIngredients {
    MAYBE,
    YES
}

final hasSubIngredientsValues = EnumValues({
    "maybe": HasSubIngredients.MAYBE,
    "yes": HasSubIngredients.YES
});

class IngredientsAnalysis {
    List<String>? enPalmOilContentUnknown;
    List<String>? enVeganStatusUnknown;
    List<String>? enVegetarianStatusUnknown;

    IngredientsAnalysis({
        this.enPalmOilContentUnknown,
        this.enVeganStatusUnknown,
        this.enVegetarianStatusUnknown,
    });

    factory IngredientsAnalysis.fromJson(Map<String, dynamic> json) => IngredientsAnalysis(
        enPalmOilContentUnknown: json["en:palm-oil-content-unknown"] == null ? [] : List<String>.from(json["en:palm-oil-content-unknown"]!.map((x) => x)),
        enVeganStatusUnknown: json["en:vegan-status-unknown"] == null ? [] : List<String>.from(json["en:vegan-status-unknown"]!.map((x) => x)),
        enVegetarianStatusUnknown: json["en:vegetarian-status-unknown"] == null ? [] : List<String>.from(json["en:vegetarian-status-unknown"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "en:palm-oil-content-unknown": enPalmOilContentUnknown == null ? [] : List<dynamic>.from(enPalmOilContentUnknown!.map((x) => x)),
        "en:vegan-status-unknown": enVeganStatusUnknown == null ? [] : List<dynamic>.from(enVeganStatusUnknown!.map((x) => x)),
        "en:vegetarian-status-unknown": enVegetarianStatusUnknown == null ? [] : List<dynamic>.from(enVegetarianStatusUnknown!.map((x) => x)),
    };
}
class Languages {
    int? enEnglish;

    Languages({
        this.enEnglish,
    });

    factory Languages.fromJson(Map<String, dynamic> json) => Languages(
        enEnglish: json["en:english"],
    );

    Map<String, dynamic> toJson() => {
        "en:english": enEnglish,
    };
}

class LanguagesCodes {
    int? en;

    LanguagesCodes({
        this.en,
    });

    factory LanguagesCodes.fromJson(Map<String, dynamic> json) => LanguagesCodes(
        en: json["en"],
    );

    Map<String, dynamic> toJson() => {
        "en": en,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
