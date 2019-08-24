import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:tourney/models/tournament.dart';
import 'package:tourney/screens/organiserPage/index.dart';
import 'package:flushbar/flushbar.dart';

class PinInput extends StatefulWidget {
  final Tournament _tourData;
  PinInput(this._tourData);

  @override
  State<StatefulWidget> createState() {
    return _PinInputState();
  }
}

class _PinInputState extends State<PinInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final Flushbar _errorFlushbar = Flushbar(
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.red[300],
    ),
    animationDuration: Duration(seconds: 0),
    duration: Duration(seconds: 3),
    leftBarIndicatorColor: Colors.red[300],
    messageText: Text(
      "Invalid Organiser Pin",
      style: TextStyle(
          fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w300),
    ),
  );
  bool _isInvalid = false;

  @override
  void initState() {
    _textEditingController.addListener(() async {
      if (_textEditingController.text.length == 4) {
        bool res = this.onPinSubmit(context, _textEditingController.text);
        if (!res)
          this.setState(() {
            _isInvalid = true;
          });
      } else {
        _errorFlushbar.dismiss();
        this.setState(() {
          _isInvalid = false;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Pin Submission
  bool onPinSubmit(BuildContext context, String enteredOrgCode) {
    if (widget._tourData.orgCode == enteredOrgCode) {
      Navigator.of(context).pop(true);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OrganiserPage(widget._tourData)));
      return true;
    } else {
      _errorFlushbar.show(context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Enter Organiser Pin"),
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
                    enteredColor: _isInvalid ? Colors.red : Colors.green,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ))))
      ],
    );
  }
}
