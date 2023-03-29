// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:donde_vamos/blocs/event_bloc/event_bloc.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/notifications/notifications.dart';
import 'package:donde_vamos/resources/event_provider.dart';
//import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/ui/detail_event/detail_event.dart';

import 'package:donde_vamos/ui/home/widgets/alert_dialog_filter.dart';
import 'package:donde_vamos/ui/home/widgets/alert_dialog_settings.dart';
import 'package:donde_vamos/ui/home/widgets/card_event.dart';
import 'package:donde_vamos/ui/home/widgets/card_nearby_event.dart';
import 'package:donde_vamos/ui/home/widgets/floating_action_button.dart';
//import 'package:donde_vamos/ui/home/widgets/floating_action_button.dart';
import 'package:donde_vamos/ui/home/widgets/label_current_events.dart';
import 'package:donde_vamos/ui/home/widgets/label_general_events.dart';
import 'package:donde_vamos/ui/home/widgets/label_nearby_events.dart';
import 'package:donde_vamos/ui/home/widgets/view_all_events_comingsoon.dart';
import 'package:donde_vamos/ui/home/widgets/view_all_nearby_events.dart';
import 'package:donde_vamos/ui/login/login.dart';
import 'package:donde_vamos/ui/profile/profile.dart';
import 'package:donde_vamos/ui/suscriptions/suscriptions.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

int actualIndex = 0;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController scrollController;
  List<Event> events = [];
  String getInitials(String nameUser) {
    print('n user' + nameUser);
    String initials = '';
    initials = nameUser.substring(0, 1);
    int indexAux = nameUser.indexOf(' ');
    initials = initials + nameUser.substring(indexAux + 1, indexAux + 2);
    return initials;
  }

  String? nameUser;
  //int actualIndex = 0;
  List<Widget> screens = [
    PrincipalScreen(),
    Suscriptions(),
    MyProfile(),
  ];
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    setearDistancia();
    getLogged().then((value) async {
      // nearbyevents = await EventProvider().getNearbyEvents();
      setState(() {});
    });
    Notifications().initPlatformState();
    Notifications().initSettingsConfiguration();
  }

  Future<void> setearDistancia() async {
    await LocalPreferences().setDistance();
    nameUser = await LocalPreferences().getNameUser();
    //nearbyevents = await EventProvider().getNearbyEvents().whenComplete(() {
    //  setState(() {});
    //});
    events = await EventProvider().getCurrentEventsOfDay();
  }

  bool existsKey = false;
  bool isLogged = false;
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> getLogged() async {
    existsKey = await LocalPreferences().existsKeyLogged();
    print('exists key' + existsKey.toString());
    isLogged = await LocalPreferences().getValueLogged();
    print('isLogged' + isLogged.toString());
    return await LocalPreferences().existsKeyLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: actualIndex == 0
              ? Text('Eventos')
              : actualIndex == 1
                  ? Text('Suscripciones')
                  : Text('Perfil'),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: isLogged,
          actions: [
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialogFilter();
                      });
                },
                child: FaIcon(
                  FontAwesomeIcons.sliders,
                  color: Colors.white,
                  size: 21.0,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            /*
                IconButton(
                    onPressed: () async {
                      double distance = await LocalPreferences().getDistance();
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialogSettings(distance: distance);
                          });
                    },
                    icon: Icon(Icons.settings))*/
          ],
        ),
        body: screens[actualIndex],
        drawer: isLogged == false
            ? null
            : Drawer(
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        gradient: AppColors().gradient,
                      ),
                      currentAccountPicture: CircleAvatar(
                        radius: 21.0,
                        child: Center(
                          child: FutureBuilder<String>(
                              future: LocalPreferences().getNameUser(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  String initialsNameUser =
                                      getInitials(snapshot.data!.toString());
                                  return Text(initialsNameUser.toUpperCase(),
                                      style: GoogleFonts.mavenPro(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white));
                                }
                                return CircularProgressIndicator();
                              }),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      accountEmail: FutureBuilder<String>(
                          future: LocalPreferences().getUsername(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text('@' + snapshot.data!.toString(),
                                  style: GoogleFonts.mavenPro(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white));
                            }
                            return CircularProgressIndicator();
                          }),
                      accountName: FutureBuilder<String>(
                          future: LocalPreferences().getNameUser(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                  'Hola' + ',' + snapshot.data!.toString(),
                                  style: GoogleFonts.mavenPro(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white));
                            }
                            return CircularProgressIndicator();
                          }),
                    ),
                    ListTile(
                      selectedColor: Colors.pink,
                      selectedTileColor: Colors.grey.withOpacity(0.30),
                      leading: Icon(Icons.calendar_month),
                      title: const Text('Eventos'),
                      selected: actualIndex == 0 ? true : false,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          actualIndex = 0;
                        });
                      },
                    ),
                    ListTile(
                      selectedColor: Colors.pink,
                      selectedTileColor: Colors.grey.withOpacity(0.30),
                      leading: FaIcon(FontAwesomeIcons.solidBell, size: 20.0),
                      title: const Text('Suscripciones'),
                      selected: actualIndex == 1 ? true : false,
                      onTap: () {
                        /*
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Suscriptions()));*/
                        Navigator.pop(context);
                        setState(() {
                          actualIndex = 1;
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: const Text('Perfil'),
                      selected: actualIndex == 2 ? true : false,
                      selectedColor: Colors.pink,
                      selectedTileColor: Colors.grey.withOpacity(0.30),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          actualIndex = 2;
                        });
                      },
                    ),
                    Expanded(child: Container()),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                      title: Text('Cerrar Sesion',
                          style: GoogleFonts.mavenPro(
                              fontWeight: FontWeight.w500)),
                      onTap: () {
                        LocalPreferences().changeValueLogged(false);
                        LocalPreferences().deleteUsername();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                    ),
                  ],
                ),
              ),
        floatingActionButton:
            isLogged == false ? FloatingActionButtonHome() : null);
  }
}

class PrincipalScreen extends StatefulWidget {
  PrincipalScreen();

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  List<Event> nearbyevents = [];
  @override
  void initState() {
    super.initState();
    setNearbyEvents();
  }

  Future<void> setNearbyEvents() async {
    nearbyevents = await EventProvider().getNearbyEvents().whenComplete(() {
      if (mounted) {
        super.setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LabelNearbyEvents(),
              nearbyevents.length >= 5
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAllNearbyEvents()));
                      },
                      child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.fromLTRB(15, 30, 20, 0),
                          child: Text('VER MAS',
                              style: GoogleFonts.mavenPro(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold))),
                    )
                  : Container(),
            ],
          ),

          //eventos que estan a menos de 2kms
          NearbyEvents(),
          Divider(
            indent: 10.0,
            color: Colors.grey.withOpacity(0.3),
            endIndent: 60.0,
            thickness: 1.5,
          ),
          FutureBuilder<List<Event>>(
              future: EventProvider().getCurrentEventsOfDay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LabelCurrentEvents(),
                      snapshot.data!.length > 5
                          ? Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.fromLTRB(15, 30, 20, 0),
                              child: Text('VER MAS',
                                  style: GoogleFonts.mavenPro(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold)))
                          : Container(),
                    ],
                  );
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.4),
                  highlightColor: Colors.white,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Card(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    ),
                  ),
                );
              }),

          FutureBuilder<List<Event>>(
              future: EventProvider().getCurrentEventsOfDay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: 300,
                    child: snapshot.data!.isEmpty
                        ? Center(
                            child: Text('No hay eventos para el dia de hoy',
                                style: GoogleFonts.mavenPro(
                                    fontWeight: FontWeight.w500)))
                        : CarouselSlider.builder(
                            options: CarouselOptions(
                              autoPlayInterval: Duration(seconds: 10),
                              enlargeCenterPage: true,
                              viewportFraction: 1.5,
                              autoPlay: true,
                              autoPlayAnimationDuration: Duration(seconds: 2),
                              height: 300,
                            ),
                            itemCount: snapshot.data!.length > 5
                                ? 5
                                : snapshot.data!.length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                    int pageViewIndex) =>
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailEvent(
                                                    event: snapshot
                                                        .data![itemIndex],
                                                  )));
                                    },
                                    child: CardNearbyEvent(
                                        event: snapshot.data![itemIndex]))),
                  );
                }
                return CircularProgressIndicator();
              }),
          Divider(
            indent: 10.0,
            color: Colors.grey.withOpacity(0.3),
            endIndent: 60.0,
            thickness: 1.5,
          ),
          //eventos que estan a mas de 2kms
          //OtherEvents(),
        ],
      ),
    );
  }
}

class NearbyEvents extends StatefulWidget {
  @override
  State<NearbyEvents> createState() => _NearbyEventsState();
}

class _NearbyEventsState extends State<NearbyEvents> {
  late Future<List<Event>> nearbyEvents;
  @override
  void initState() {
    super.initState();
    setEvents();
    //BlocProvider.of<EventBloc>(context).add(GetNearbyEvents());
  }

  Future<void> setEvents() async {
    nearbyEvents = EventProvider().getNearbyEvents();
    List<Event> events = await EventProvider().getNearbyEvents();
    print('events' + events.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
        future: nearbyEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              height: 300,
              child: snapshot.data!.isEmpty
                  ? Center(child: Text('No hay eventos cercanos'))
                  : CarouselSlider.builder(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        viewportFraction: 1.5,
                        autoPlayInterval: Duration(seconds: 10),
                        autoPlay: true,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        height: 300,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailEvent(
                                              event: snapshot.data![itemIndex],
                                            )));
                              },
                              child: CardNearbyEvent(
                                  event: snapshot.data![itemIndex]))),
              /*
              ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailEvent(
                                        event: snapshot.data![index],
                                      )));
                        },
                        child: CardNearbyEvent(event: snapshot.data![index]));
                  }),*/
            );
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.4),
            highlightColor: Colors.white,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width * 1,
              child: Card(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              ),
            ),
          );
        });
  }
}
