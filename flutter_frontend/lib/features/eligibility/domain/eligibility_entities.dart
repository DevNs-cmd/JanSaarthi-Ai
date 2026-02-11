class EligibilityRequest {
  final String citizenId;
  final String schemeId;
  final Map<String, dynamic> inputData;

  EligibilityRequest({
    required this.citizenId,
    required this.schemeId,
    required this.inputData,
  });
}

class EligibilityResponse {
  final String citizenId;
  final String schemeId;
  final bool isEligible;
  final double confidenceScore;
  final List<EligibilityFactor> factors;
  final String explanation;
  final DateTime evaluatedAt;

  EligibilityResponse({
    required this.citizenId,
    required this.schemeId,
    required this.isEligible,
    required this.confidenceScore,
    required this.factors,
    required this.explanation,
    required this.evaluatedAt,
  });

  factory EligibilityResponse.fromJson(Map<String, dynamic> json) {
    return EligibilityResponse(
      citizenId: json['citizenId'] as String,
      schemeId: json['schemeId'] as String,
      isEligible: json['isEligible'] as bool,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      factors: (json['factors'] as List)
          .map(
            (factor) =>
                EligibilityFactor.fromJson(factor as Map<String, dynamic>),
          )
          .toList(),
      explanation: json['explanation'] as String,
      evaluatedAt: DateTime.parse(json['evaluatedAt'] as String),
    );
  }
}

class EligibilityFactor {
  final String factorName;
  final String factorValue;
  final double weight;
  final bool meetsCriteria;
  final String description;

  EligibilityFactor({
    required this.factorName,
    required this.factorValue,
    required this.weight,
    required this.meetsCriteria,
    required this.description,
  });

  factory EligibilityFactor.fromJson(Map<String, dynamic> json) {
    return EligibilityFactor(
      factorName: json['factorName'] as String,
      factorValue: json['factorValue'] as String,
      weight: (json['weight'] as num).toDouble(),
      meetsCriteria: json['meetsCriteria'] as bool,
      description: json['description'] as String,
    );
  }
}

class Scheme {
  final String schemeId;
  final String name;
  final String description;
  final String category;
  final String ministry;
  final double estimatedBenefit;
  final String eligibilityUrl;

  Scheme({
    required this.schemeId,
    required this.name,
    required this.description,
    required this.category,
    required this.ministry,
    required this.estimatedBenefit,
    required this.eligibilityUrl,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      schemeId: json['schemeId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      ministry: json['ministry'] as String,
      estimatedBenefit: (json['estimatedBenefit'] as num).toDouble(),
      eligibilityUrl: json['eligibilityUrl'] as String,
    );
  }
}
