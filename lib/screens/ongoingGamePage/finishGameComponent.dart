import 'package:flutter/material.dart';

class FinishGameComponent extends StatelessWidget {
  final bool _isLoading;
  final Function _finishGame;

  FinishGameComponent(this._isLoading, this._finishGame);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      color: (_isLoading) ? Colors.grey : Colors.red,
      child: InkWell(
        onTap: _isLoading ? null : _finishGame,
        child: Center(
            child: Text("End Game",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
      ),
    );
  }
}
