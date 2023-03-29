// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/comment_place.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/resources/comment_provider.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/comments/comments_places.dart';
import 'package:donde_vamos/ui/place/widgets/message_no_comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RowComments extends StatefulWidget {
  int idPlace;
  RowComments({required this.idPlace});

  @override
  State<RowComments> createState() => _RowCommentsState();
}

class _RowCommentsState extends State<RowComments> {
  int comments = 0;
  @override
  void initState() {
    super.initState();
    getCommentsPlace();
  }

  Future<void> getCommentsPlace() async {
    comments = await CommentProvider()
        .getCommentsPlace(widget.idPlace)
        .whenComplete(() {
      setState(() {});
    });
    print('cant comments' + comments.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: GestureDetector(
        onTap: () async {
          Place place = await PlacesProvider().getPlace(widget.idPlace);

          List<CommentPlace> commentsPlaces = await CommentProvider()
              .getAllCommentsPlace(place.lugar_id!.toInt());
          bool isLogged = await LocalPreferences().getValueLogged();
          if (isLogged == true) {
            comments == 0
                ? showDialog(
                    context: context,
                    builder: (ctx) {
                      return MessageNoComments(
                          place.lugar_id!, place.lugar_nombre.toString());
                    })
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsPlaces(
                            comments: commentsPlaces,
                            idPlace: place.lugar_id.toString(),
                            namePlace: place.lugar_nombre.toString())));
          } else {
            comments > 0
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsPlaces(
                            comments: commentsPlaces,
                            idPlace: place.lugar_id.toString(),
                            namePlace: place.lugar_nombre.toString())))
                : Container();
          }
        },
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.comment,
              size: 16.0,
              color: Colors.grey.withOpacity(0.35),
            ),
            SizedBox(width: 5.0),
            comments > 0
                ? comments == 1
                    ? Text(comments.toString() + ' ' + 'comentario',
                        style: GoogleFonts.mavenPro(
                            color: Colors.blue.withOpacity(0.6),
                            fontWeight: FontWeight.w500))
                    : Text(comments.toString() + ' ' + 'comentarios',
                        style: GoogleFonts.mavenPro(
                            color: Colors.blue.withOpacity(0.6),
                            fontWeight: FontWeight.w500))
                : Text('Sin comentarios',
                    style: GoogleFonts.mavenPro(
                        color: Colors.blue.withOpacity(0.6),
                        fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
