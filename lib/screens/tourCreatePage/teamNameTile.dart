import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamNameTile extends StatefulWidget {
  final int _index;
  final String _initialValue;
  final Function _updateCallback;

  TeamNameTile(this._index, this._initialValue, this._updateCallback);

  @override
  State<StatefulWidget> createState() {
    return _TeamNameTileState();
  }
}

class _TeamNameTileState extends State<TeamNameTile> {
  FocusNode _myFocusNode;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget._initialValue);
    _myFocusNode = FocusNode();
    _controller.addListener(() {
      widget._updateCallback(widget._index, _controller.text);
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _myFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        controller: _controller,
        focusNode: _myFocusNode,
        onTap: () {
          FocusScope.of(context).requestFocus(_myFocusNode);
        },
        onSubmitted: (str) {
          FocusScope.of(context).unfocus();
        },
      ),
      trailing: IconButton(
        icon: Icon(FontAwesomeIcons.eraser),
        alignment: Alignment.centerRight,
        tooltip: 'Change Team Name',
        onPressed: (() {
          _controller.clear();
          FocusScope.of(context).requestFocus(_myFocusNode);
        }),
      ),
    );
  }
}
