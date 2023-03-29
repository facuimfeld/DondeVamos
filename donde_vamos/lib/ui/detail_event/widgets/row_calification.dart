import 'package:flutter/material.dart';

class RowCalification extends StatefulWidget {
  String calification;
  RowCalification({required this.calification});

  @override
  State<RowCalification> createState() => _RowCalificationState();
}

class _RowCalificationState extends State<RowCalification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.grey.withOpacity(0.25), size: 20.0),
          SizedBox(width: 5.0),
          widget.calification != "0"
              ? Text(widget.calification,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.25),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold))
              : Tooltip(
                  textStyle: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  message:
                      'Este es un evento nuevo, no posee calificaciones de los usuarios todavia',
                  child: Text('Sin calificacion',
                      style: TextStyle(
                          color: Colors.grey.withOpacity(0.25),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500)),
                )
        ],
      ),
    );
  }
}
