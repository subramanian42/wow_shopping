import 'package:flutter/material.dart';
import 'package:wow_shopping/features/main/main_screen.dart';

class BottomNavNotifier extends ChangeNotifier {
  NavItem get item => _item;

  NavItem _item = NavItem.home;

  set updateItem(NavItem item) {
    _item = item;
    notifyListeners();
  }
}
