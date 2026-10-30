import 'package:e7gz/src/core/di/sl.dart';
import 'package:e7gz/src/core/services/dio_service.dart';


import 'package:e7gz/src/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:e7gz/src/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:e7gz/src/features/bookings/domain/repositories/booking_repository.dart';
import 'package:e7gz/src/features/bookings/domain/usecases/booking_usecases.dart';
import 'package:e7gz/src/features/bookings/presentation/cubit/booking_cubit.dart';

void initBookingsDependencies() {
  // Data source — Pattern A: constructor-injected with DioService
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(dioService: sl<DioService>()),
  );

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl<BookingRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
    () => GetBookingDetailsUseCase(sl<BookingRepository>()),
  );
  sl.registerLazySingleton(() => CreateBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
    () => GetAvailableSlotsUseCase(sl<BookingRepository>()),
  );

  // Cubits
  sl.registerFactory(
    () => BookingsCubit(
      getMyBookings: sl<GetMyBookingsUseCase>(),
      cancelBooking: sl<CancelBookingUseCase>(),
    ),
  );
  sl.registerFactory(
    () => CreateBookingCubit(createBooking: sl<CreateBookingUseCase>()),
  );
}