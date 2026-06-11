import 'package:e7gz/src/imports/imports.dart';

class InternetConnectionService {
  InternetConnectionService();

  final InternetConnection internetConnection = InternetConnection();

  Future<bool> hasConnection() async =>
      await internetConnection.hasInternetAccess;
}
