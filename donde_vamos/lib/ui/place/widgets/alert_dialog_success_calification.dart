import 'package:donde_vamos/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AlertDialogSuccessCalification extends StatelessWidget {
  const AlertDialogSuccessCalification({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 35.0,
                  backgroundColor: Colors.green,
                  child: Center(
                      child:
                          Icon(Icons.check, color: Colors.white, size: 24.0))),
              SizedBox(height: 10.0),
              Text('Calificacion registrada!'),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width * 0.6,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
          child: Text('Aceptar'),
        )
      ],
    );
  }
}
