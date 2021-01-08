import 'package:flutter/material.dart';

enum TabItem { jobs, entries, profile }

class TabItemData {
  TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: 'Jobs', icon: Icons.work),
    TabItem.entries: TabItemData(title: 'Entries', icon: Icons.view_headline),
    TabItem.profile: TabItemData(title: 'Profile', icon: Icons.person),
  };
}
