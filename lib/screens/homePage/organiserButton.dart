import 'package:flutter/material.dart';
import 'package:tourney/models/inheritedWidget.dart';
import 'package:tourney/models/tournament.dart';

import 'package:tourney/screens/homePage/pinInput.dart';
import 'package:tourney/screens/organiserPage/index.dart';

class OrganiserButton extends StatelessWidget {
  final Function _onPageChange;

  OrganiserButton(this._onPageChange);

  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    return Container();
  }
}
