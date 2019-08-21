import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourney/resources/repository.dart';

/*
 Firstly, we put the ancestor of our widget tree as a MyInheritedWidget,
 by building this widget, we create the state which builds the InheritedWidget, 
 which will have the child widget and also the state object passed down to it.
 When we call the of method of the MyInheritedWidget in the build method of a particular
 child widget, it will be redirected to the the ancestor Inherited Widget as built in the 
 build method. After getting this reference to the inherited widget, we can use the data field
 to access the state object.
 With access to the state object, we can use the mutators to change the state object, which will
 cause the MyInheritedWidget to be rebuilt, re-instantiating the _MyInherited with the updated state
 and due to the of method of the MyInheritedWidget having a listener component, after the rebuilding of
 MyInheritedWidget and _MyInherited, the updateShouldNotify method will be called, causing the child widget
 calling the of method to be rebuilt as well, thus ending the loop
*/

class _MyInherited extends InheritedWidget {
  _MyInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final MyInheritedWidgetState data;

  @override
  bool updateShouldNotify(_MyInherited oldWidget) {
    return true;
  }
}

class MyInheritedWidget extends StatefulWidget {
  final Repository _repository = Repository();
  final Widget child;

  MyInheritedWidget({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  MyInheritedWidgetState createState() => new MyInheritedWidgetState();

  static MyInheritedWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited)
        .data;
  }
}

class MyInheritedWidgetState extends State<MyInheritedWidget> {
  Stream<DocumentSnapshot> currentTournamnent;
  String currentTourID;

  void currentTournament(String tourID) {
    currentTournamnent = widget._repository.tournamentStream(tourID);
    currentTourID = tourID;
  }

  String getCurrentTournament() {
    return this.currentTourID;
  }

  @override
  Widget build(BuildContext context) {
    return new _MyInherited(
      data: this,
      child: widget.child,
    );
  }
}
