import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:tourney/models/tournament.dart';
import 'package:tourney/screens/organiserPage/index.dart';

class PinInput extends StatefulWidget {
  final Tournament _data;
  final Function _errorCallback;
  PinInput(this._data, this._errorCallback);
  @override
  State<StatefulWidget> createState() {
    return _PinInputState();
  }
}

class _PinInputState extends State<PinInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.addListener(() {
      if (_textEditingController.text.length == 4)
        this.onPinSubmit(context, _textEditingController.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Pin Submission
  void onPinSubmit(BuildContext context, String enteredOrgCode) {
    if (widget._data.orgCode == enteredOrgCode) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OrganiserPage(widget._data.tourID, widget._data.teamNames)));
    } else {
      Navigator.pop(context);
      widget._errorCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Enter Organiser Code"),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(35.0),
            child: PinInputTextField(
                pinLength: 4,
                autoFocus: true,
                controller: _textEditingController,
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
    );
  }
}
