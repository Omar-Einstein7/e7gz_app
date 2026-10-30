import 'package:dio/dio.dart';
import 'package:e7gz/src/di/injection_container.dart';


import 'package:e7gz/src/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:e7gz/src/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:e7gz/src/features/notifications/domain/repositories/notification_repository.dart';
import 'package:e7gz/src/features/notifications/presentation/cubit/notifications_cubit.dart';

void initNotificationsDependencies() {
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl<NotificationRemoteDataSource>()),
  );

  sl.registerFactory(
    () => NotificationsCubit(repository: sl<NotificationRepository>()),
  );
}