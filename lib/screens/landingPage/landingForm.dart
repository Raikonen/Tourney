import 'package:flutter/material.dart';

import 'package:tourney/resources/repository.dart';
import 'package:tourney/models/inheritedWidget.dart';
import 'package:tourney/screens/pageController/index.dart';
import 'package:tourney/screens/tourCreatePage/index.dart';

class LandingForm extends StatefulWidget {
  @override
  _LandingFormState createState() {
    return _LandingFormState();
  }
}

class _LandingFormState extends State<LandingForm> {
  final _formKey = GlobalKey<FormState>();
  final _repository = Repository();
  bool _isLoading = false;
  bool _isValidated = false;
  final _myController = TextEditingController();

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  // Loading Button
  Widget _createButtonChild() {
    return _isLoading
        ? SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ))
        : Text(
            'Enter',
            style: TextStyle(
                color: Colors.purple,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          );
  }

  // Validate TourID and set _isValidated bool accordingly
  Future<void> validateTourID(String tourID) async {
    dynamic response = await (_repository.checkTournament(tourID));
    this.setState(() {
      _isValidated = response;
    });
  }

  // On Form Submit
  void onSubmit() async {
    this.setState(() {
      _isLoading = true;
    });
    await validateTourID(_myController.text);

    if (_formKey.currentState.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyInheritedWidget(
                    child: MyPageController(_myController.text),
                  )));
    }
    this.setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            // Input Box
            Container(
                padding: EdgeInsets.only(top: 80.0),
                width: 250.0,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: 'Ubuntu'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter a Tournament ID";
                    } else if (this._isValidated == null) {
                      return "Connection Error";
                    } else if (!this._isValidated) {
                      return "Tournament Not Found";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      errorStyle:
                          TextStyle(fontSize: 12.0, fontFamily: 'Ubuntu'),
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          fontFamily: 'Ubuntu'),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Tournament ID'),
                  controller: _myController,
                )),

            // Enter Button
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                  width: 250.0,
                  child: OutlineButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    borderSide: BorderSide(width: 2.0, color: Colors.purple),
                    onPressed: _isLoading ? () {} : this.onSubmit,
                    child: _createButtonChild(),
                  )),
            ),

            // New Tournament Button
            SizedBox(
                width: 250.0,
                child: OutlineButton(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    borderSide: BorderSide(width: 2.0, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TourCreate(),
                          ));
                    },
                    child: Text(
                      "New Tournament",
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    )))
          ],
        ),
      ),
    ));
  }
}
