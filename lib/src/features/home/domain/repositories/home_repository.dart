import 'package:e7gz/src/utils/typedefs.dart';
import 'package:e7gz/src/features/home/domain/entities/home_data.dart';

abstract class HomeRepository {
  FutureEither<HomeData> getHomeData();
}
