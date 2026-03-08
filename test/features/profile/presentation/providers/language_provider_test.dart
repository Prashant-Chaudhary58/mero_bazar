import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/core/providers/language_provider.dart';
import 'package:hive/hive.dart';

void main() {
  late LanguageProvider provider;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_language_test');
    Hive.init(tempDir.path);
    provider = LanguageProvider();
    await Future.delayed(const Duration(milliseconds: 50));
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('LanguageProvider Unit Tests', () {
    test('should set language and update locale', () async {
      expect(provider.locale, const Locale('en'));

      await provider.setLanguage('ne');
      expect(provider.locale, const Locale('ne'));

      await provider.setLanguage('en');
      expect(provider.locale, const Locale('en'));
    });
  });
}
