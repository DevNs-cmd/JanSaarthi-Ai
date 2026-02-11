import 'package:equatable/equatable.dart';

class CitizenProfile extends Equatable {
  final String citizenId;
  final String yojanaId;
  final String name;
  final String dob;
  final String gender;
  final String language;
  final String mobile;
  final String address;
  final String district;
  final String state;
  final Map<String, String> attributes;
  final String profileVersion;

  const CitizenProfile({
    required this.citizenId,
    required this.yojanaId,
    required this.name,
    required this.dob,
    required this.gender,
    required this.language,
    required this.mobile,
    required this.address,
    required this.district,
    required this.state,
    required this.attributes,
    required this.profileVersion,
  });

  factory CitizenProfile.fromJson(Map<String, dynamic> json) {
    return CitizenProfile(
      citizenId: json['citizenId'] as String,
      yojanaId: json['yojanaId'] as String,
      name: json['name'] as String,
      dob: json['dob'] as String,
      gender: json['gender'] as String,
      language: json['language'] as String,
      mobile: json['mobile'] as String,
      address: json['address'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      attributes: Map<String, String>.from(json['attributes'] as Map),
      profileVersion: json['profileVersion'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'citizenId': citizenId,
      'yojanaId': yojanaId,
      'name': name,
      'dob': dob,
      'gender': gender,
      'language': language,
      'mobile': mobile,
      'address': address,
      'district': district,
      'state': state,
      'attributes': attributes,
      'profileVersion': profileVersion,
    };
  }

  @override
  List<Object?> get props => [
    citizenId,
    yojanaId,
    name,
    dob,
    gender,
    language,
    mobile,
    address,
    district,
    state,
    attributes,
    profileVersion,
  ];
}

class Consent extends Equatable {
  final String consentToken;
  final String consentId;
  final String status;

  const Consent({
    required this.consentToken,
    required this.consentId,
    required this.status,
  });

  factory Consent.fromJson(Map<String, dynamic> json) {
    return Consent(
      consentToken: json['consentToken'] as String,
      consentId: json['consentId'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consentToken': consentToken,
      'consentId': consentId,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [consentToken, consentId, status];
}

class EligibilityResponse extends Equatable {
  final bool eligible;
  final String decisionCode;
  final List<Explanation> explanations;
  final String auditRef;

  const EligibilityResponse({
    required this.eligible,
    required this.decisionCode,
    required this.explanations,
    required this.auditRef,
  });

  factory EligibilityResponse.fromJson(Map<String, dynamic> json) {
    return EligibilityResponse(
      eligible: json['eligible'] as bool,
      decisionCode: json['decisionCode'] as String,
      explanations: (json['explanations'] as List)
          .map((e) => Explanation.fromJson(e as Map<String, dynamic>))
          .toList(),
      auditRef: json['auditRef'] as String,
    );
  }

  @override
  List<Object?> get props => [eligible, decisionCode, explanations, auditRef];
}

class Explanation extends Equatable {
  final String ruleId;
  final String message;
  final List<String> inputsUsed;
  final String policyVersion;

  const Explanation({
    required this.ruleId,
    required this.message,
    required this.inputsUsed,
    required this.policyVersion,
  });

  factory Explanation.fromJson(Map<String, dynamic> json) {
    return Explanation(
      ruleId: json['ruleId'] as String,
      message: json['message'] as String,
      inputsUsed: List<String>.from(json['inputsUsed'] as List),
      policyVersion: json['policyVersion'] as String,
    );
  }

  @override
  List<Object?> get props => [ruleId, message, inputsUsed, policyVersion];
}

class Policy extends Equatable {
  final String policyId;
  final String version;
  final String effectiveFrom;
  final String rulesetUri;
  final String checksum;
  final List<String> approvals;

  const Policy({
    required this.policyId,
    required this.version,
    required this.effectiveFrom,
    required this.rulesetUri,
    required this.checksum,
    required this.approvals,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      policyId: json['policyId'] as String,
      version: json['version'] as String,
      effectiveFrom: json['effectiveFrom'] as String,
      rulesetUri: json['rulesetUri'] as String,
      checksum: json['checksum'] as String,
      approvals: List<String>.from(json['approvals'] as List),
    );
  }

  @override
  List<Object?> get props => [
    policyId,
    version,
    effectiveFrom,
    rulesetUri,
    checksum,
    approvals,
  ];
}

class AdminDashboard extends Equatable {
  final DashboardMetrics metrics;
  final List<DailyTrend> trends;

  const AdminDashboard({required this.metrics, required this.trends});

  factory AdminDashboard.fromJson(Map<String, dynamic> json) {
    return AdminDashboard(
      metrics: DashboardMetrics.fromJson(
        json['metrics'] as Map<String, dynamic>,
      ),
      trends: (json['trends'] as List)
          .map((e) => DailyTrend.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [metrics, trends];
}

class DashboardMetrics extends Equatable {
  final int totalCitizens;
  final int activeProfiles;
  final int eligibilityChecks;
  final int successfulEvaluations;
  final double policyAdoptionRate;

  const DashboardMetrics({
    required this.totalCitizens,
    required this.activeProfiles,
    required this.eligibilityChecks,
    required this.successfulEvaluations,
    required this.policyAdoptionRate,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalCitizens: json['totalCitizens'] as int,
      activeProfiles: json['activeProfiles'] as int,
      eligibilityChecks: json['eligibilityChecks'] as int,
      successfulEvaluations: json['successfulEvaluations'] as int,
      policyAdoptionRate: (json['policyAdoptionRate'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    totalCitizens,
    activeProfiles,
    eligibilityChecks,
    successfulEvaluations,
    policyAdoptionRate,
  ];
}

class DailyTrend extends Equatable {
  final String date;
  final int count;

  const DailyTrend({required this.date, required this.count});

  factory DailyTrend.fromJson(Map<String, dynamic> json) {
    return DailyTrend(
      date: json['date'] as String,
      count: json['count'] as int,
    );
  }

  @override
  List<Object?> get props => [date, count];
}

class AuditLogEntry extends Equatable {
  final String citizenId;
  final String policyId;
  final bool decision;
  final String timestamp;
  final String auditRef;
  final String explanation;

  const AuditLogEntry({
    required this.citizenId,
    required this.policyId,
    required this.decision,
    required this.timestamp,
    required this.auditRef,
    required this.explanation,
  });

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) {
    return AuditLogEntry(
      citizenId: json['citizenId'] as String,
      policyId: json['policyId'] as String,
      decision: json['decision'] as bool,
      timestamp: json['timestamp'] as String,
      auditRef: json['auditRef'] as String,
      explanation: json['explanation'] as String,
    );
  }

  @override
  List<Object?> get props => [
    citizenId,
    policyId,
    decision,
    timestamp,
    auditRef,
    explanation,
  ];
}

class PaginatedAuditLogs extends Equatable {
  final List<AuditLogEntry> items;
  final int total;
  final int page;
  final int limit;

  const PaginatedAuditLogs({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedAuditLogs.fromJson(Map<String, dynamic> json) {
    return PaginatedAuditLogs(
      items: (json['items'] as List)
          .map((e) => AuditLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
    );
  }

  @override
  List<Object?> get props => [items, total, page, limit];
}
