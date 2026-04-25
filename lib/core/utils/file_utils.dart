import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._();

  static Future<String> resolveOutputPath({
    required String sourcePath,
    String? customDir,
    String? customName,
  }) async {
    final String dir;
    if (customDir != null && customDir.isNotEmpty) {
      dir = customDir;
    } else {
      final ext = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      dir = p.join(ext.path, 'YJ_Converter');
    }
    Directory(dir).createSync(recursive: true);

    final baseName = customName?.isNotEmpty == true
        ? customName!
        : p.basenameWithoutExtension(sourcePath);

    return p.join(dir, '$baseName.3gp');
  }

  static String readableSize(int bytes) {
    if (bytes < 1024)           return '$bytes B';
    if (bytes < 1024 * 1024)    return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
