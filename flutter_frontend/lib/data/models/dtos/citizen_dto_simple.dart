// Simple DTO models without code generation
class CitizenProfileDto {
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

  CitizenProfileDto({
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

  factory CitizenProfileDto.fromJson(Map<String, dynamic> json) {
    return CitizenProfileDto(
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
}

class UpsertCitizenRequestDto {
  final String yojanaId;
  final DemographicsDto? demographics;
  final ContactDto? contact;
  final Map<String, String>? attributes;
  final String consentToken;
  final String source;

  UpsertCitizenRequestDto({
    required this.yojanaId,
    this.demographics,
    this.contact,
    this.attributes,
    required this.consentToken,
    required this.source,
  });

  Map<String, dynamic> toJson() {
    return {
      'yojanaId': yojanaId,
      'demographics': demographics?.toJson(),
      'contact': contact?.toJson(),
      'attributes': attributes,
      'consentToken': consentToken,
      'source': source,
    };
  }
}

class DemographicsDto {
  final String? name;
  final String? dob;
  final String? gender;
  final String? language;

  DemographicsDto({this.name, this.dob, this.gender, this.language});

  Map<String, dynamic> toJson() {
    return {'name': name, 'dob': dob, 'gender': gender, 'language': language};
  }
}

class ContactDto {
  final String? mobile;
  final String? address;
  final String? district;
  final String? state;

  ContactDto({this.mobile, this.address, this.district, this.state});

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'address': address,
      'district': district,
      'state': state,
    };
  }
}

class CitizenProfileResponseDto {
  final String citizenId;
  final String status;
  final String profileVersion;

  CitizenProfileResponseDto({
    required this.citizenId,
    required this.status,
    required this.profileVersion,
  });

  factory CitizenProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return CitizenProfileResponseDto(
      citizenId: json['citizenId'] as String,
      status: json['status'] as String,
      profileVersion: json['profileVersion'] as String,
    );
  }
}
