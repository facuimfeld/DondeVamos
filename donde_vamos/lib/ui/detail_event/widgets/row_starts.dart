import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RowStars extends StatefulWidget {
  String calif;
  RowStars({required this.calif});

  @override
  State<RowStars> createState() => _RowStarsState();
}

class _RowStarsState extends State<RowStars> {
  List<Widget> stars = [];
  double calif1 = 0.0;
  int? calif2;
  @override
  void initState() {
    super.initState();
    calif1 = double.parse(widget.calif);
    calif2 = calif1.toInt();
    print('widget' + widget.calif.toString());
    stars = List.generate(calif2!,
        (index) => const Icon(Icons.star, color: Colors.yellow, size: 14.0));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: calif2 == 0
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: calif2,
              itemBuilder: (context, index) {
                return const Icon(Icons.star, color: Colors.yellow, size: 13.0);
              }),
    );
  }
}
