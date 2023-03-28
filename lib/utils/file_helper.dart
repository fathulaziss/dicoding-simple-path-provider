import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<File> writeFile(String path, String content) async {
    final file = File(path);

    // Menuliskan konten ke dalam berkas.
    if (kDebugMode) {
      print('Saved to $path');
    }
    return file.writeAsString(content);
  }

  static Future<String> readFile(String filePath) async {
    try {
      final file = File(filePath);

      // Membaca berkas sebagai sebuah String.
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // Jika terjadi eror, mencetak pesan eror ke konsol dan mengembalikan teks kosong.
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
  }

  static Future<String> getFilePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final prefix = directory.path;
    final absolutePath = '$prefix/$filename.txt';
    return absolutePath;
  }
}
