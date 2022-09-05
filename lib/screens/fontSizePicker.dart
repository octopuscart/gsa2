import 'package:flutter/material.dart';
import '../modal/curd.dart';

class FontSizePickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final double initialFontSize;

  const FontSizePickerDialog({this.initialFontSize = 18});

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  /// current selection of the slider
  double _fontSize = 18;
  Dbconnect db = Dbconnect();

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
    print(_fontSize);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Text Size'),
      content: Container(
        height: 60,
        child: Slider(
          value: _fontSize,
          min: 18,
          max: 40,
          divisions: 5,
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Map updateData = {"attr_value": _fontSize};
            db.updateTableCondition(
                "init_setup", updateData, {"attr_type": "font_size"});
            Navigator.pop(context, _fontSize);
          },
          child: Text('DONE'),
        )
      ],
    );
  }
}
