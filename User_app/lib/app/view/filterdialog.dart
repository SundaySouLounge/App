import 'package:flutter/material.dart';

import '../util/theme.dart';

class FilterDialog extends StatefulWidget {
  bool switchValue1;
  bool switchValue2;
  bool switchValue3;
  bool switchValue4;
  DateTime selectedDate;

  final Function(bool, bool, bool, bool, DateTime)? onClose;

  FilterDialog({
    Key? key,
    required this.selectedDate,
    this.switchValue1 = true,
    this.switchValue2 = true,
    this.switchValue3 = true,
    this.switchValue4 = true,
    required this.onClose,
  }) : super(key: key);
  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  void initState() {
    super.initState();
    widget.selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Options'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Solo'),
              value: widget.switchValue1,
              onChanged: (value) {
                setState(() {
                  widget.switchValue1 = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Duo'),
              value: widget.switchValue2,
              onChanged: (value) {
                setState(() {
                  widget.switchValue2 = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Trio'),
              value: widget.switchValue3,
              onChanged: (value) {
                setState(() {
                  widget.switchValue3 = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('More'),
              value: widget.switchValue4,
              onChanged: (value) {
                setState(() {
                  widget.switchValue4 = value;
                });
              },
            ),
            Text('Select a Date:'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.appColor),
              onPressed: () {
                _selectDate(context);
              },
              child: Text('Pick a date'),
            ),
            Text(
              "${widget.selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ThemeProvider.appColor, // Background Color
          ),
          onPressed: () {
            if (widget.onClose != null) {
              widget.onClose!.call(
                widget.switchValue1,
                widget.switchValue2,
                widget.switchValue3,
                widget.switchValue4,
                widget.selectedDate,
              );
            }
            Navigator.of(context).pop();
          },
          child: Text('Apply', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ThemeProvider.appColor, // Background Color
          ),
          onPressed: () {
            // Close the dialog without applying the filter
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.selectedDate)
      setState(() {
        widget.selectedDate = picked;
      });
  }
}
