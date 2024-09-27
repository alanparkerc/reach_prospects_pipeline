import 'package:flutter/material.dart';
import 'package:reach_prospects/library/constants.dart';
import '../../cosmetic/styles.dart';

class ChangeTag extends StatefulWidget {
  final Map<String, dynamic> prospect;
  final Map<String, String> mainHeader;
  final int mapIndex;
  final Function(Map<String, dynamic>, int) onSquareMoved;
  final Function(String) tagChange;

  const ChangeTag({
    super.key,
    required this.prospect,
    required this.mainHeader,
    required this.mapIndex,
    required this.onSquareMoved,
    required this.tagChange,
  });

  @override
  ChangeTagState createState() => ChangeTagState();
}

class ChangeTagState extends State<ChangeTag> {
  String nextStage = '';

  void pageRoute() {
    Navigator.pop(
      context,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nextStage = widget.prospect['nextStage'];
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(12.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Quick Edit", style: mainStyle),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Close the dialog
              },
              style: clearButtonStyle,
              child: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const Text(
          "Move Stage",
          style: TextStyle(color: Colors.black),
        ),
        DropdownButton<String>(
          onChanged: (value) {
            setState(() {
              nextStage = value!;
            });
          },
          value: nextStage,
          items:
              stageDropdownItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () async {
            int index = stageDropdownItems.indexOf(nextStage);
            if (index != widget.mapIndex) {
              await widget.onSquareMoved(widget.prospect, index);
              await widget.tagChange(nextStage);
            }
            pageRoute();
          },
          style: clearButtonStyle,
          child: Text(
            'Submit',
            style: mainStyle,
          ),
        ),
      ],
    );
  }
}
