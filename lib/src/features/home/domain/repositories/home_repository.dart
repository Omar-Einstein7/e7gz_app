import 'package:fpdart/fpdart.dart';
import '../../../../utils/typedefs.dart';
import '../entities/home_data.dart';

abstract class HomeRepository {
  FutureEither<HomeData> getHomeData();
}
