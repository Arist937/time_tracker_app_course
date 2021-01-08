import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
  }) : super(key: key);

  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  _buildCupertinoTabItem(TabItem tabItem) {
    final TabItemData item = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      label: item.title,
      icon: Icon(item.icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildCupertinoTabItem(TabItem.jobs),
          _buildCupertinoTabItem(TabItem.entries),
          _buildCupertinoTabItem(TabItem.profile),
        ],
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];

        return CupertinoTabView(
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }
}
