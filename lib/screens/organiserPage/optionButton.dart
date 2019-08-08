import 'package:flutter/material.dart';

class _IconClip extends CustomClipper<Path> {
  double _width = 30.0;
  double _slant = 10.0;

  _IconClip(this._width, this._slant);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(_width, 0);
    path.lineTo((_width - _slant), size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OptionButton extends StatelessWidget {
  final bool _isRounded;
  final String _optionText;
  final Icon _optionIcon;
  final Function _optionCallback;

  OptionButton(this._isRounded, this._optionText, this._optionIcon,
      this._optionCallback);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, //Color(0xFFD7DFE5),
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: _isRounded ? BorderRadius.circular(30.0) : null),
        width: 300.0,
        height: 50.0,
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: _IconClip(50.0, 10.0),
              child: Container(
                  decoration: BoxDecoration(
                borderRadius: _isRounded ? BorderRadius.circular(30.0) : null,
                color: Color(0xFF2D3E46),
              )),
            ),
            InkWell(
                onTap: _optionCallback,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    _optionIcon,
                    SizedBox(
                      width: 25.0,
                    ),
                    Text(
                      _optionText,
                      style: TextStyle(
                          fontFamily: 'PermanentMarker', fontSize: 20.0),
                    ),
                    Expanded(child: Container())
                  ],
                ))
          ],
        ));
  }
}
