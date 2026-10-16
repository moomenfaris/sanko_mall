import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../models/app_notification.dart';

/// Promotional notifications source.
abstract interface class NotificationRepository {
  Future<Result<List<AppNotification>>> getAll();
}

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<Result<List<AppNotification>>> getAll() async {
    try {
      final response = await _client.dio.post(
        '${AppConstants.barcodeLookupBaseUrl}${AppConstants.notificationsPath}',
        data: const <String, dynamic>{},
        options: Options(
          headers: {'x-api-key': AppConstants.barcodeLookupApiKey},
        ),
      );
      final payload = response.data;
      if (payload is! Map<String, dynamic> || payload['success'] != true) {
        return const Err(ServerFailure('Failed to load notifications.'));
      }

      final data = payload['data'];
      if (data is! List) {
        return const Err(ServerFailure('Failed to load notifications.'));
      }

      return Success(
        data
            .whereType<Map<String, dynamic>>()
            .map(AppNotification.fromApiJson)
            .toList(),
      );
    } on DioException {
      return const Err(ServerFailure('Failed to load notifications.'));
    } catch (_) {
      return const Err(ServerFailure('Failed to load notifications.'));
    }
  }
}
