import 'package:flutter/services.dart';
import 'package:e7gz/src/utils/utils.dart';

/// A service to handle clipboard operations.
class CopyService {
  CopyService();

  /// Copy text to the system clipboard.
  FutureEither<void> copy(String text) async {
    return runTask(() async {
      await Clipboard.setData(ClipboardData(text: text));
      AppLogger.info('Text copied to clipboard');
    });
  }
}
