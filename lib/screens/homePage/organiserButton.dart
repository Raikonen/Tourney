import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import 'package:tourney/models/tournament.dart';
import 'package:tourney/screens/organiserPage/index.dart';

class OrganiserButton extends StatelessWidget {
  final Tournament _data;

  OrganiserButton(this._data);

  // Pin Submission
  void onPinSubmit(BuildContext context, String enteredOrgCode) {
    if (_data.orgCode == enteredOrgCode) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OrganiserPage(_data.tourID, _data.teamNames)));
    } else {
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          content: Row(
            children: <Widget>[
              Icon(Icons.error),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('Invalid Organiser Code'))
            ],
          )));
    }
  }

  // Open Pin Dialog
  void _verifyOrgCode(BuildContext context) async {
    PinEditingController _pinEditingController =
        PinEditingController(pinLength: 4, autoDispose: true);

    _pinEditingController.addListener(() {
      (_pinEditingController.text.length == 4)
          ? this.onPinSubmit(context, _pinEditingController.text)
          : null;
    });

    Scaffold.of(context).removeCurrentSnackBar();

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleDialog(
        title: Text("Enter Organiser Code"),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(35.0),
              child: PinInputTextField(
                  pinLength: 4,
                  autoFocus: true,
                  pinEditingController: _pinEditingController,
                  enabled: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  decoration: UnderlineDecoration(
                      enteredColor: Colors.orange,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ))))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("I am an Organiser"),
      textColor: Colors.white,
      color: Colors.pink,
      onPressed: () {
        _verifyOrgCode(context);
      },
    );
  }
}
