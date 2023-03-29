// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:donde_vamos/main.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/ui/detail_event/detail_event.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:donde_vamos/ui/login/login.dart';
import 'package:donde_vamos/ui/suscriptions/suscriptions.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class Notifications {
  //configuracion de One Signal para el manejo de notificaciones
  String oneSignalId = "0f4252a4-418d-4003-98a6-efc3a5c2a8e9";

  Future<void> initSettingsConfiguration() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(true);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('result' + result.notification.additionalData.toString());
      Event evento = Event.fromJSON(result.notification.additionalData!);
      navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => DetailEvent(event: evento)),
      );
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('event:' + event.toString());
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {});

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared
        .setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
      print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
      print("ON WILL DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
      print("ON DID DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnWillDismissInAppMessageHandler((message) {
      print("ON WILL DISMISS IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDismissInAppMessageHandler((message) {
      print("ON DID DISMISS IN APP MESSAGE ${message.messageId}");
    });
  }

  //ID App One Signal 0f4252a4-418d-4003-98a6-efc3a5c2a8e9
  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalId);
    OneSignal.shared.setRequiresUserPrivacyConsent(true);
    OneSignal.shared.consentGranted(true);

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print('res' + accepted.toString());
    });
  }

  Future<String> getUserTokenId() async {
    String tokenId = '';
    var deviceState = await OneSignal().getDeviceState();
    if (deviceState != null || deviceState?.userId != null) {
      tokenId = deviceState!.userId!;
      print("TOKEN ID: " + tokenId);
    }
    return tokenId;
  }

  //endpoint para enviar un mail al usuario cuando se suscribe a un evento
  Future<void> postNotificationEmail(
      Event evento, String subject, String message) async {
    String idEv = evento.evento_id.toString();
    // String nameEvent = evento.evento_nombre;
    Map<String, dynamic> data = {
      'subject': subject,
      'message': message,
      'evento_id': evento.evento_id.toString(),
      'evento_nombre': evento.evento_nombre,
    };
    String url = 'http://10.0.3.2:8000/api/eventos/notifications/update/$idEv/';

    var resp = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: json.encode(data),
    );
    if (resp.statusCode == 200) {
      print('hecho!');
    } else {
      print('err' + resp.body.toString());
    }
  }

  //mandar a la bd en tiempo real de firebase la
  //suscripcion a un evento
  Future<void> postSuscriptionEvent(Event event) async {
    String tokenId = '';
    await Notifications().initPlatformState().whenComplete(() async {
      tokenId = await Notifications().getUserTokenId();
      print('TOKEN ID ES' + tokenId);
    });
    String idE = event.evento_id.toString();
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child('eventos/$idE');

    ref.set({
      'id': tokenId,
    });
  }

  //mandar a la bd en tiempo real la suscripcion a un lugar
  Future<void> postSuscriptionPlace(Place place) async {
    String tokenId = 'd29975dd-2844-4dcc-ba42-1f44b8611cb1';
    //await Notifications().initPlatformState().whenComplete(() async {
    //  tokenId = await Notifications().getUserTokenId();
    //  print('TOKEN ID ES' + tokenId);
    //});
    String idP = place.lugar_id.toString();
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child('lugares/$idP');

    ref.set({
      'id': tokenId,
    });
  }

  //borrar suscripcion de un lugar (bd tiempo real)

  Future<void> deleteSuscriptionPlaceRTBD(Place place) async {
    int idPlace = place.lugar_id!;
    FirebaseDatabase.instance
        .reference()
        .child('lugares')
        .child(idPlace.toString())
        .remove();
  }

  //borrar suscripcion de un evento en la BD tiempo real
  Future<void> deleteSuscriptionEventRTBD(Event event) async {
    int idEvento = event.evento_id;
    FirebaseDatabase.instance
        .reference()
        .child('eventos')
        .child(idEvento.toString())
        .remove();
  }

  //enviar email cuando el usuario se suscribe a un lugar
  Future<void> postNotificationEmailPlace(
      Event evento, String subject, String message) async {
    String idEv = evento.evento_id.toString();
    // String nameEvent = evento.evento_nombre;
    Map<String, dynamic> data = {
      'subject': subject,
      'message': message,
      'evento_id': evento.evento_id.toString(),
      'evento_nombre': evento.evento_nombre,
    };
    String url = 'http://10.0.3.2:8000/api/eventos/notifications/update/$idEv/';

    var resp = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: json.encode(data),
    );
    if (resp.statusCode == 200) {
      print('hecho!');
    } else {
      print('err' + resp.body.toString());
    }
  }
}
