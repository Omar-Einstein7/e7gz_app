
import 'package:get_it/get_it.dart';

/// Global service locator instance.
///
/// Lives in its own tiny file so every DI module can import [sl] without
/// creating a circular import with `injection_container.dart` (which itself
/// imports all the modules).
final sl = GetIt.instance;