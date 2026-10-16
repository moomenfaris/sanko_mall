import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/scanner/data/repositories/product_repository.dart';
import '../../features/notifications/data/repositories/notification_repository.dart';

/// Global service locator. Registers singletons used across features.
final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // API client injects the stored auth token on every request.
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      tokenProvider: () => sl<AuthRepository>().currentUser()?.token,
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<SharedPreferences>(), sl<ApiClient>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl<ApiClient>()),
  );
}
