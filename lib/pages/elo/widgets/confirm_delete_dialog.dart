import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Bestand verwijderen?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('VERWIJDER'),
        ),
      ],
    );
  }
}
