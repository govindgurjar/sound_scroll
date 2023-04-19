import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/radio.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key, required this.radios}) : super(key: key);

  final List<MyRadio> radios;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFF34338),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF34338),
                  Color(0xFFAD54EA),
                ],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(44),
                    child: Image.asset('assets/img/govind.jpg'),
                  ),
                ),
                Text(
                  'Govind Gurjar',
                  style: GoogleFonts.dancingScript(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    height: 1.5,
                  ),
                ).shimmer(primaryColor: Vx.purple300, secondaryColor: Colors.white),
              ],
            ),
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: const Icon(Icons.phone_rounded),
            title: const Text('+91 8770207963'),
            onTap: () async {
              if (!await launchUrl(Uri.parse("tel:+91 8770207963"))) {
                throw Exception('Could not launch"');
              }
            },
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: const Icon(Icons.email_rounded),
            title: const Text('mr.govindgurjar@gmail.com'),
            onTap: () async {
              if (!await launchUrl(Uri.parse("mailto:mr.govindgurjar@gmail.com"))) {
                throw Exception('Could not launch"');
              }
            },
          ),
          Divider(),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                children: const [
                  Icon(Icons.radio_rounded, color: Colors.grey),
                  SizedBox(width: 18),
                  Text("Radio Channels"),
                ],
              ),
              children: <Widget>[
                Container(
                  height: 300,
                  // color: _selectedColor ?? AIColors.primaryColor2,
                  // color: Colors.white,
                  child: radios != null
                      ? [
                          // 100.heightBox,
                          // "All Channels".text.xl.white.semiBold.make().px16(),
                          // 20.heightBox,
                          ListView(
                            padding: Vx.m0,
                            shrinkWrap: true,
                            children: radios
                                .map((e) => ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(e.icon!),
                                      ),
                                      title: "${e.name} FM".text.black.make(),
                                      subtitle: e.tagline!.text.black.make(),
                                    ))
                                .toList(),
                          ).expand()
                        ].vStack(crossAlignment: CrossAxisAlignment.start)
                      : const Offstage(),
                ),
              ],
            ),
          ),
          // Divider(),
          ListTile(
            minLeadingWidth: 25,
            leading: const Icon(Icons.favorite_rounded),
            title: const Text('Favorite'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            minLeadingWidth: 25,
            leading: const Icon(Icons.notifications_rounded),
            title: const Text('Notification'),
            onTap: () {},
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            minLeadingWidth: 25,
            leading: const Icon(Icons.privacy_tip_rounded),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            minLeadingWidth: 25,
            leading: const Icon(Icons.feedback_rounded),
            title: const Text('Send feedback'),
            onTap: () {},
          ),
          // Divider(),
        ],
      ),
      // child: Container(
      //   // color: _selectedColor ?? AIColors.primaryColor2,
      //   color: Colors.deepPurple,
      //   child: radios != null
      //       ? [
      //           100.heightBox,
      //           "All Channels".text.xl.white.semiBold.make().px16(),
      //           20.heightBox,
      //           ListView(
      //             padding: Vx.m0,
      //             shrinkWrap: true,
      //             children: radios
      //                 .map((e) => ListTile(
      //                       leading: CircleAvatar(
      //                         backgroundImage: NetworkImage(e.icon!),
      //                       ),
      //                       title: "${e.name} FM".text.white.make(),
      //                       subtitle: e.tagline!.text.white.make(),
      //                     ))
      //                 .toList(),
      //           ).expand()
      //         ].vStack(crossAlignment: CrossAxisAlignment.start)
      //       : const Offstage(),
      // ),
    );
  }
}
