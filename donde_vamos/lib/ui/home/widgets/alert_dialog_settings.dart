// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';

class AlertDialogSettings extends StatefulWidget {
  double distance;
  AlertDialogSettings({required this.distance});

  @override
  State<AlertDialogSettings> createState() => _AlertDialogSettingsState();
}

class _AlertDialogSettingsState extends State<AlertDialogSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajustes'),
      content: SizedBox(
        height: 200,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Radio de busqueda de evento' +
                " " +
                widget.distance.toInt().toString() +
                " " +
                "Km"),
            Slider(
                label: widget.distance.toInt().toString(),
                max: 151.0,
                min: 1.0,
                value: widget.distance,
                // divisions: 1,
                onChanged: (val) {
                  setState(() {
                    widget.distance = val;
                  });
                })
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              await LocalPreferences().modifyDistance(widget.distance);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
            child: Text('Guardar cambios')),
      ],
    );
  }
}
