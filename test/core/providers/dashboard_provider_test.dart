import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';

void main() {
  group('DashboardProvider Unit Tests', () {
    test('setSelectedIndex should update selectedIndex', () {
      final provider = DashboardProvider();

      provider.setSelectedIndex(1);
      expect(provider.selectedIndex, 1);

      provider.setSelectedIndex(2);
      expect(provider.selectedIndex, 2);
    });
  });
}
