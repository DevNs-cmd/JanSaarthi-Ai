import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/eligibility_entities.dart';
import '../../data/repositories/eligibility_repository.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';

// Eligibility State
class EligibilityState {
  final List<Scheme> availableSchemes;
  final List<Scheme> suggestedSchemes;
  final EligibilityResponse? currentEvaluation;
  final bool isLoading;
  final String? error;
  final bool hasEvaluated;

  EligibilityState({
    this.availableSchemes = const [],
    this.suggestedSchemes = const [],
    this.currentEvaluation,
    this.isLoading = false,
    this.error,
    this.hasEvaluated = false,
  });

  EligibilityState copyWith({
    List<Scheme>? availableSchemes,
    List<Scheme>? suggestedSchemes,
    EligibilityResponse? currentEvaluation,
    bool? isLoading,
    String? error,
    bool? hasEvaluated,
  }) {
    return EligibilityState(
      availableSchemes: availableSchemes ?? this.availableSchemes,
      suggestedSchemes: suggestedSchemes ?? this.suggestedSchemes,
      currentEvaluation: currentEvaluation ?? this.currentEvaluation,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasEvaluated: hasEvaluated ?? this.hasEvaluated,
    );
  }
}

// Eligibility Notifier
class EligibilityNotifier extends StateNotifier<EligibilityState> {
  final EligibilityRepository _repository;
  final Ref _ref;

  EligibilityNotifier(this._repository, this._ref) : super(EligibilityState()) {
    _loadSchemes();
  }

  Future<void> _loadSchemes() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final schemes = await _repository.getAvailableSchemes();
      final currentUser = _ref.read(currentUserProvider);

      List<Scheme> suggestions = [];
      if (currentUser != null) {
        suggestions = await _repository.getSuggestedSchemes(currentUser.userId);
      }

      state = state.copyWith(
        availableSchemes: schemes,
        suggestedSchemes: suggestions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> evaluateEligibility(
    String schemeId,
    Map<String, dynamic> inputData,
  ) async {
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = state.copyWith(error: 'User not authenticated');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = EligibilityRequest(
        citizenId: currentUser.userId,
        schemeId: schemeId,
        inputData: inputData,
      );

      final response = await _repository.evaluateEligibility(request);
      state = state.copyWith(
        currentEvaluation: response,
        hasEvaluated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshSchemes() async {
    await _loadSchemes();
  }

  void clearEvaluation() {
    state = state.copyWith(
      currentEvaluation: null,
      hasEvaluated: false,
      error: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final eligibilityProvider =
    StateNotifierProvider<EligibilityNotifier, EligibilityState>((ref) {
      final repository = ref.read(eligibilityRepositoryProvider);
      return EligibilityNotifier(repository, ref);
    });

// Async providers for specific data
final availableSchemesProvider = FutureProvider<List<Scheme>>((ref) async {
  final repository = ref.read(eligibilityRepositoryProvider);
  return await repository.getAvailableSchemes();
});

final suggestedSchemesProvider = FutureProvider.family<List<Scheme>, String>((
  ref,
  citizenId,
) async {
  final repository = ref.read(eligibilityRepositoryProvider);
  return await repository.getSuggestedSchemes(citizenId);
});
