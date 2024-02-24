import 'package:flutter/material.dart';

/// 共享用户数据
class UserInfoWrapper extends StatelessWidget {
  UserInfoWrapper({
    this.data,
    this.child,
  });

  final Map<String, dynamic> data;
  final Widget child;

  static Map<String, dynamic> of(BuildContext context) {
    final _InheritedConfig inheritedConfig =
        context.dependOnInheritedWidgetOfExactType<_InheritedConfig>();
    return inheritedConfig.data;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedConfig(
      data: data,
      child: child,
    );
  }
}

class _InheritedConfig extends InheritedWidget {
  _InheritedConfig({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final Map<String, dynamic> data;

  @override
  bool updateShouldNotify(_InheritedConfig oldWidget) {
    return data.toString() != oldWidget.data.toString();
  }
}
