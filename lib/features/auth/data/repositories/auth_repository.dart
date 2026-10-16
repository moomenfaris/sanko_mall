import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../models/user_model.dart';

/// Contract for authentication. Swap [AuthRepositoryImpl] mock branch for a
/// real Dio call once the backend is live — UI/state code stays unchanged.
abstract interface class AuthRepository {
  Future<Result<UserModel>> login(String email, String password);
  Future<Result<UserModel>> loginAsGuest();
  Future<void> logout();
  UserModel? currentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._prefs, this._client);

  final SharedPreferences _prefs;
  // ignore: unused_field
  final ApiClient _client;
  UserModel? _cached;

  @override
  UserModel? currentUser() {
    if (_cached != null) return _cached;
    final token = _prefs.getString(AppConstants.prefAuthToken);
    if (token == null) return null;
    final isGuest = _prefs.getBool(AppConstants.prefIsGuest) ?? false;
    _cached = isGuest
        ? UserModel.guest()
        : UserModel(id: 'me', email: 'user@sankomall.local', token: token);
    return _cached;
  }

  @override
  Future<Result<UserModel>> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (AppConstants.useMockData) {
      if (email.isEmpty || password.length < 4) {
        return const Err(AuthFailure('Invalid email or password.'));
      }
      final user = UserModel(id: 'me', email: email, token: 'mock-jwt-token');
      await _persist(user);
      return Success(user);
    }
    // Real backend call would go here using _client.dio.post('/auth/login').
    return const Err(ServerFailure());
  }

  @override
  Future<Result<UserModel>> loginAsGuest() async {
    final user = UserModel.guest();
    await _persist(user);
    return Success(user);
  }

  Future<void> _persist(UserModel user) async {
    _cached = user;
    await _prefs.setString(AppConstants.prefAuthToken, user.token);
    await _prefs.setBool(AppConstants.prefIsGuest, user.isGuest);
  }

  @override
  Future<void> logout() async {
    _cached = null;
    await _prefs.remove(AppConstants.prefAuthToken);
    await _prefs.remove(AppConstants.prefIsGuest);
  }
}
