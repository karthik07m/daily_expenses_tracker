import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/constants.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);
  static const routeName = "/appInfo";

  @override
  _AppInfoState createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  bool _expandDevInfoIcon = false;
  bool _expandFeatures = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "App Info",
          style: TextStyle(color: kBackgroundColor),
        ),
        iconTheme: IconThemeData(color: kBackgroundColor),
      ),
      // drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 160,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: Hero(
                      tag: "logo",
                      child: Image.asset(
                        'assets/icon/startlogo.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    appName,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyText1!.color),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                aboutApp,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _expandDevInfoIcon = !_expandDevInfoIcon;
                });
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Developer Info",
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _expandDevInfoIcon = !_expandDevInfoIcon;
                              });
                            },
                            icon: Icon(
                              _expandDevInfoIcon
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                      if (_expandDevInfoIcon)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              child: Image.asset(
                                "assets/icon/profile.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              appOwner,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: mailAdress,
                                      );

                                      launch(emailLaunchUri.toString());
                                    },
                                    icon: Icon(
                                      Icons.mail_outline,
                                      color: kPrimaryColor,
                                      size: 32,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await canLaunch(gitUrl)
                                          ? await launch(gitUrl)
                                          : throw 'Could not launch $gitUrl';
                                    },
                                    child: Image.asset(
                                      "assets/icon/github.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await canLaunch(linkdinUrl)
                                          ? await launch(linkdinUrl)
                                          : throw 'Could not launch $gitUrl';
                                    },
                                    child: Image.asset(
                                      "assets/icon/linkedin.png",
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ]),
                            Divider(
                              color: kPrimaryColor,
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _expandFeatures = !_expandFeatures;
                  });
                },
                child: Card(
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Upcoming Features",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _expandFeatures = !_expandFeatures;
                                  });
                                },
                                icon: Icon(
                                  _expandFeatures
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                          if (_expandFeatures)
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: features
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.adjust_sharp,
                                                color: Colors.blueGrey,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  " $e",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blueGrey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList())
                        ])))),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          version,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
