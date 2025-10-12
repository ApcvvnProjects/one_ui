import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_ui/one_ui.dart';

void main() {
  group('One UI Package Tests', () {
    test('Package can be imported', () {
      // Basic smoke test - if this fails, the package has major issues
      expect(true, isTrue);
    });

    test('OneUIBottomNavigationBar can be created', () {
      final items = [
        const OneUIBottomNavigationBarItem(label: 'Home'),
        const OneUIBottomNavigationBarItem(label: 'Search'),
      ];

      final bar = OneUIBottomNavigationBar(
        items: items,
        onTap: (index) {},
      );

      expect(bar.items.length, 2);
      expect(bar.items[0].label, 'Home');
      expect(bar.items[1].label, 'Search');
    });

    test('OneUIContainedButton can be created', () {
      final button = OneUIContainedButton(
        onPressed: () {},
        child: const Text('Test'),
      );

      expect(button.onPressed, isNotNull);
    });

    test('OneUISwitch can be created', () {
      bool value = false;
      final switchWidget = OneUISwitch(
        value: value,
        onChanged: (newValue) => value = newValue,
      );

      expect(switchWidget.value, false);
      expect(switchWidget.onChanged, isNotNull);
    });
  });
}
