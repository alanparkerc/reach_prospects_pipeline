import 'package:flutter/material.dart';
import '../../cosmetic/styles.dart';
import '../../library/hot_cold_leads.dart';

class ChangeLeadTypeDialog extends StatefulWidget {
  final Map<String, dynamic> prospect;
  final Map<String, String> mainHeader;
  final int columnIndex;
  final int rowIndex;
  final Function(int, int) changeHotLead;
  final Function(int, int) changeColdLead;

  const ChangeLeadTypeDialog(
      {super.key,
      required this.prospect,
      required this.mainHeader,
      required this.changeHotLead,
      required this.changeColdLead,
      required this.columnIndex,
      required this.rowIndex});

  @override
  ChangeLeadTypeDialogState createState() => ChangeLeadTypeDialogState();
}

class ChangeLeadTypeDialogState extends State<ChangeLeadTypeDialog> {
  Map<String, dynamic> modifyProspect = {};
  bool hotLead = false;
  bool coldLead = false;

  void pageRoute() {
    Navigator.pop(context, modifyProspect);
  }

  @override
  void dispose() {
    // Dispose of the controllers when they are no longer needed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    modifyProspect = widget.prospect;
    hotLead = modifyProspect['hotLead'];
    coldLead = modifyProspect['coldLead'];
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(12.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Change Lead Type", style: mainStyle),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, modifyProspect); // Close the dialog
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
        Row(
          children: [
            const Text('Hot Lead'),
            Checkbox(
              value: hotLead,
              onChanged: (_) async {
                setState(() {
                  hotLead = !hotLead;
                });
                await widget.changeHotLead(widget.columnIndex, widget.rowIndex);
                if (hotLead) {
                  modifyProspect = await saveHotLead(
                      modifyProspect, widget.prospect['id'], widget.mainHeader);
                } else {
                  modifyProspect = await deleteHotLead(modifyProspect,
                      widget.prospect['tags'], widget.mainHeader);
                }
              },
            ),
            const Text('Cold Lead'),
            Checkbox(
              value: coldLead,
              onChanged: (_) async {
                setState(() {
                  coldLead = !coldLead;
                });
                await widget.changeColdLead(
                    widget.columnIndex, widget.rowIndex);
                if (coldLead) {
                  modifyProspect = await saveColdLead(
                      modifyProspect, widget.prospect['id'], widget.mainHeader);
                } else {
                  modifyProspect = await deleteColdLead(modifyProspect,
                      widget.prospect['tags'], widget.mainHeader);
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
