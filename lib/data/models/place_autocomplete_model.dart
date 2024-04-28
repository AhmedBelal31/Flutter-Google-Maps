class PlaceAutocompleteModel {
  final String status;

  final List<PredictionsModel> predictions;

  const PlaceAutocompleteModel({
    required this.status,
    required this.predictions,
  });

  factory PlaceAutocompleteModel.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteModel(
      status: json['status'],
      predictions: List<PredictionsModel>.from(
        json['predictions'].map(
          (e) => PredictionsModel.fromJson(e),
        ),
      ),
    );
  }
}

class PredictionsModel {
  String? description;

  List<MatchedSubstrings>? matchedSubstrings;

  String? placeId;

  String? reference;

  StructuredFormatting? structuredFormatting;

  List<TermsModel>? terms;

  List<String>? types;

  PredictionsModel({
     this.description,
     this.matchedSubstrings,
     this.placeId,
     this.reference,
     this.structuredFormatting,
     this.terms,
     this.types,
  });

  factory PredictionsModel.fromJson(Map<String, dynamic> json) {
    return PredictionsModel(
      description: json['description'],
      matchedSubstrings: List<MatchedSubstrings>.from(
        json['matched_substrings'].map(
          (e) => MatchedSubstrings.fromJson(e),
        )??[],
      )   ,
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: StructuredFormatting.fromJson(json['structured_formatting']),
      terms: List<TermsModel>.from(
        json['terms'].map(
          (e) => TermsModel.fromJson(e),
        )??[],
      ),
      types: List<String>.from(json['types']),
    );
  }
}

class MatchedSubstrings {
   final int offset;

   final int length;

   MatchedSubstrings({required this.offset, required this.length});

  factory MatchedSubstrings.fromJson(Map<String, dynamic> json) {
    return MatchedSubstrings(
      offset: json['offset'],
      length: json['length'],
    );
  }
}

class StructuredFormatting {
  String? mainText;

  List<MatchedSubstrings>? mainTextMatchedSubstrings;

  String? secondaryText;

  StructuredFormatting({
     this.mainText,
     this.mainTextMatchedSubstrings,
     this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'],
      mainTextMatchedSubstrings: List<MatchedSubstrings>.from(
        json['main_text_matched_substrings'].map(
          (e) => MatchedSubstrings.fromJson(e),
        ),
      ),
      secondaryText: json['secondary_text'],
    );
  }
}

class TermsModel {
  final int offset;

  final String value;

  const TermsModel({required this.offset, required this.value});

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    return TermsModel(
      offset: json['offset'],
      value: json['value'],
    );
  }
}
