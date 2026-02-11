import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../models/dtos/citizen_dto_simple.dart';
import '../../../domain/entities/citizen_entity.dart';

// DTO to Entity Mapper
class CitizenMapper {
  static CitizenProfile toEntity(CitizenProfileDto dto) {
    return CitizenProfile(
      citizenId: dto.citizenId,
      yojanaId: dto.yojanaId,
      name: dto.name,
      dob: dto.dob,
      gender: dto.gender,
      language: dto.language,
      mobile: dto.mobile,
      address: dto.address,
      district: dto.district,
      state: dto.state,
      attributes: dto.attributes,
      profileVersion: dto.profileVersion,
    );
  }

  static CitizenProfileDto toDto(CitizenProfile entity) {
    return CitizenProfileDto(
      citizenId: entity.citizenId,
      yojanaId: entity.yojanaId,
      name: entity.name,
      dob: entity.dob,
      gender: entity.gender,
      language: entity.language,
      mobile: entity.mobile,
      address: entity.address,
      district: entity.district,
      state: entity.state,
      attributes: entity.attributes,
      profileVersion: entity.profileVersion,
    );
  }

  static UpsertCitizenRequestDto toUpsertDto(UpsertCitizenRequest request) {
    return UpsertCitizenRequestDto(
      yojanaId: request.yojanaId,
      demographics: request.demographics != null
          ? DemographicsDto(
              name: request.demographics!.name,
              dob: request.demographics!.dob,
              gender: request.demographics!.gender,
              language: request.demographics!.language,
            )
          : null,
      contact: request.contact != null
          ? ContactDto(
              mobile: request.contact!.mobile,
              address: request.contact!.address,
              district: request.contact!.district,
              state: request.contact!.state,
            )
          : null,
      attributes: request.attributes,
      consentToken: request.consentToken,
      source: request.source,
    );
  }
}

// Repository Interface
abstract class CitizenRepository {
  Future<CitizenProfile> getCitizenProfile(String citizenId);
  Future<CitizenProfile> upsertCitizenProfile(UpsertCitizenRequest request);
}

// Repository Implementation
class CitizenRepositoryImpl implements CitizenRepository {
  final ApiClient apiClient;

  CitizenRepositoryImpl({required this.apiClient});

  @override
  Future<CitizenProfile> getCitizenProfile(String citizenId) async {
    final response = await apiClient.get<CitizenProfileDto>(
      AppConstants.citizenProfileBaseUrl,
      '${AppConstants.citizenProfilePath}/$citizenId',
      parser: (data) =>
          CitizenProfileDto.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return CitizenMapper.toEntity(response.data!);
    } else {
      throw Exception(
        response.error?.message ?? 'Failed to fetch citizen profile',
      );
    }
  }

  @override
  Future<CitizenProfile> upsertCitizenProfile(
    UpsertCitizenRequest request,
  ) async {
    final requestDto = CitizenMapper.toUpsertDto(request);

    final response = await apiClient.post<CitizenProfileResponseDto>(
      AppConstants.citizenProfileBaseUrl,
      AppConstants.citizenProfilePath,
      requestDto.toJson(),
      parser: (data) =>
          CitizenProfileResponseDto.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      // Fetch the updated profile
      return await getCitizenProfile(response.data!.citizenId);
    } else {
      throw Exception(
        response.error?.message ?? 'Failed to update citizen profile',
      );
    }
  }
}

// Repository Provider
final citizenRepositoryProvider = Provider<CitizenRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return CitizenRepositoryImpl(apiClient: apiClient);
});

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(networkInfo: NetworkInfo());
});
