import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class RowLink extends StatelessWidget {
  String url;
  RowLink({required this.url});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.link,
          size: 20.0,
          color: Colors.grey.withOpacity(0.25),
        ),
        SizedBox(width: 5.0),
        GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(Uri.parse(url)))
              await launchUrl(Uri.parse(url));
            else
              // can't launch url, there is some error
              throw "Could not launch $url";
          },
          child: Text(url,
              style: GoogleFonts.mavenPro(
                  color: Colors.blue.withOpacity(0.6),
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
