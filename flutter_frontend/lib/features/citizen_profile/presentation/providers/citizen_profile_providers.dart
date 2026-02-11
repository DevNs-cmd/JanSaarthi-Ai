import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/citizen_entity.dart';
import '../../../../data/repositories/citizen_repository.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';

// Citizen Profile State
class CitizenProfileState {
  final CitizenProfile? profile;
  final bool isLoading;
  final String? error;
  final bool hasProfile;

  CitizenProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.hasProfile = false,
  });

  CitizenProfileState copyWith({
    CitizenProfile? profile,
    bool? isLoading,
    String? error,
    bool? hasProfile,
  }) {
    return CitizenProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasProfile: hasProfile ?? this.hasProfile,
    );
  }
}

// Citizen Profile Notifier
class CitizenProfileNotifier extends StateNotifier<CitizenProfileState> {
  final CitizenRepository _repository;
  final Ref _ref;

  CitizenProfileNotifier(this._repository, this._ref)
    : super(CitizenProfileState()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _repository.getCitizenProfile(currentUser.userId);
      state = state.copyWith(
        profile: profile,
        isLoading: false,
        hasProfile: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        hasProfile: false,
      );
    }
  }

  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final citizenProfileProvider =
    StateNotifierProvider<CitizenProfileNotifier, CitizenProfileState>((ref) {
      final repository = ref.read(citizenRepositoryProvider);
      return CitizenProfileNotifier(repository, ref);
    });

// Async data provider for citizen profile
final citizenProfileAsyncProvider = FutureProvider<CitizenProfile?>((
  ref,
) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return null;

  final repository = ref.read(citizenRepositoryProvider);
  return await repository.getCitizenProfile(currentUser.userId);
});
