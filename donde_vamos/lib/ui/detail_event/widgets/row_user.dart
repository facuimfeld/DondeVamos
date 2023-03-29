//obtener la empresa que organiza el evento
import 'package:donde_vamos/resources/company_provider.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';

class RowUser extends StatefulWidget {
  String user;
  RowUser({required this.user});

  @override
  State<RowUser> createState() => _RowUserState();
}

class _RowUserState extends State<RowUser> {
  Future<Map<String, dynamic>>? getCompanyUser;
  @override
  void initState() {
    super.initState();
    print('USER' + widget.user);
    getCompanyUser = CompanyProvider().getCompanyFromUser(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.business,
              color: Colors.grey.withOpacity(0.25), size: 18.0),
          const SizedBox(width: 5.0),
          FutureBuilder<Map<String, dynamic>>(
              future: getCompanyUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    width: 150,
                    child: Text(snapshot.data!["empresa_nombre"],
                        maxLines: 2, style: AppColors().styleBody),
                  );
                }
                return CircularProgressIndicator();
              }),
        ],
      ),
    );
  }
}
