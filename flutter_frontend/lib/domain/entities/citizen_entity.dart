class CitizenProfile {
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

  CitizenProfile({
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

  CitizenProfile copyWith({
    String? citizenId,
    String? yojanaId,
    String? name,
    String? dob,
    String? gender,
    String? language,
    String? mobile,
    String? address,
    String? district,
    String? state,
    Map<String, String>? attributes,
    String? profileVersion,
  }) {
    return CitizenProfile(
      citizenId: citizenId ?? this.citizenId,
      yojanaId: yojanaId ?? this.yojanaId,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      district: district ?? this.district,
      state: state ?? this.state,
      attributes: attributes ?? this.attributes,
      profileVersion: profileVersion ?? this.profileVersion,
    );
  }
}

class UpsertCitizenRequest {
  final String yojanaId;
  final Demographics? demographics;
  final Contact? contact;
  final Map<String, String>? attributes;
  final String consentToken;
  final String source;

  UpsertCitizenRequest({
    required this.yojanaId,
    this.demographics,
    this.contact,
    this.attributes,
    required this.consentToken,
    required this.source,
  });
}

class Demographics {
  final String? name;
  final String? dob;
  final String? gender;
  final String? language;

  Demographics({this.name, this.dob, this.gender, this.language});
}

class Contact {
  final String? mobile;
  final String? address;
  final String? district;
  final String? state;

  Contact({this.mobile, this.address, this.district, this.state});
}
