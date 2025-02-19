import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/utils/functions.dart';

import '../widgets/card.dart';

class Profile extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;
  const Profile({super.key, required this.isGuest, this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "text": "Update Password",
        "icon": Icons.password_rounded,
        "route": UhlLinkRoutesNames.updatePassword,
        'pathParameters': {"user": jsonEncode(widget.user)},
        "guest": false
      },
      {
        "text": "Achievements/PORs",
        "icon": Icons.emoji_events_rounded,
        "route": UhlLinkRoutesNames.porsPage,
        'pathParameters': {},
        "guest": false
      },
      {
        "text": "Settings",
        "icon": Icons.settings,
        "route": UhlLinkRoutesNames.settingsPage,
        'pathParameters': {},
        "guest": true
      },
    ];
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.aspectRatio * 90,
                backgroundColor: Theme.of(context).primaryColor,
                child: widget.isGuest
                    ? const Icon(Icons.person, size: 30)
                    : ClipOval(
                        child: Image.network(
                            "https://drive.google.com/uc?export=download&id=${getIdFromDriveLink(widget.user!['image'])}",
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const CircularProgressIndicator();
                        }, errorBuilder: (context, object, trace) {
                          return const Icon(Icons.error_outline_outlined,
                              size: 30);
                        }),
                      ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isGuest ? "Not Logged in" : widget.user!['name'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    widget.isGuest
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                GoRouter.of(context)
                                    .goNamed(UhlLinkRoutesNames.chooseAuth);
                              },
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      Theme.of(context).primaryColor),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )),
                              child: Text(
                                "Log In",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.white, fontSize: 17),
                              ),
                            ),
                          )
                        : Text(
                            widget.user!['email'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontFamily: "Montserrat_Regular",
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor),
                          ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Divider(
            thickness: 2,
            color: Theme.of(context).colorScheme.scrim,
          ),
          for (var item in items
              .where((item) => widget.isGuest ? item['guest'] == true : true))
            CardWidget(
              text: item['text'],
              icon: item['icon'],
              onTap: () {
                GoRouter.of(context).pushNamed(item['route'], pathParameters: {
                  for (var entry in item['pathParameters'].entries)
                    entry.key: entry.value.toString()
                });
              },
            ),
        ],
      ),
    );
  }
}
