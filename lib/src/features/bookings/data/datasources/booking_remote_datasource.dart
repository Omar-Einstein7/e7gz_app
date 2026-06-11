import 'package:e7gz/src/utils/logger.dart';
import 'package:e7gz/src/features/bookings/data/models/booking_model.dart';
import 'package:e7gz/src/services/dio_service.dart';

class BookingRemoteDataSource {
  final DioService _dio;

  BookingRemoteDataSource({required DioService dioService}) : _dio = dioService;

  Future<List<BookingModel>> getMyBookings({String? status}) async {
    try {
      final params = <String, dynamic>{'status': ?status};
      final result = await _dio.get('bookings', queryParameters: params);

      return result.fold(
        (failure) {
          logError('Failed to fetch bookings: ${failure.message}');
          throw Exception(failure.message);
        },
        (response) {
          logInfo('Bookings response status: ${response.statusCode}');
          final data = response.data as Map<String, dynamic>;
          final list = data['data']['bookings'] as List<dynamic>? ?? [];
          logSuccess('Fetched ${list.length} bookings');
          return list
              .map((b) => BookingModel.fromJson(b as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e, stackTrace) {
      logError('Failed to fetch bookings', e, stackTrace);
      rethrow;
    }
  }

  Future<BookingModel> getBookingById(String id) async {
    final result = await _dio.get('bookings/$id');
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      return BookingModel.fromJson(
        data['data']['booking'] as Map<String, dynamic>,
      );
    });
  }

  Future<BookingModel> createBooking({
    required String pitchId,
    required String date,
    required String startTime,
    required String endTime,
    String? notes,
  }) async {
    final body = {
      'pitchId': pitchId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'notes': ?notes,
    };
    final result = await _dio.post('bookings', data: body);
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      return BookingModel.fromJson(
        data['data']['booking'] as Map<String, dynamic>,
      );
    });
  }

  Future<BookingModel> cancelBooking(String bookingId) async {
    final result = await _dio.delete('bookings/$bookingId');
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      return BookingModel.fromJson(
        data['data']['booking'] as Map<String, dynamic>,
      );
    });
  }

  Future<List<TimeSlotModel>> getAvailableSlots({
    required String pitchId,
    required String date,
  }) async {
    final result = await _dio.get(
      'bookings/pitch/$pitchId/slots',
      queryParameters: {'date': date},
    );
    return result.fold((failure) => throw Exception(failure.message), (
      response,
    ) {
      final data = response.data as Map<String, dynamic>;
      final slots = data['data']['slots'] as List<dynamic>? ?? [];
      return slots
          .map((s) => TimeSlotModel.fromJson(s as Map<String, dynamic>))
          .toList();
    });
  }
}
