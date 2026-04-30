
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/constants/constant.dart';
import 'package:akile_attendance_system/pages/SharedPreference/sharedPreference.dart';
import 'package:akile_attendance_system/pages/dialog/confirmationDialog.dart';
import 'package:akile_attendance_system/pages/widgets/custom_shape.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/utilities/abstract_classes/confirmation_abstract.dart';
import 'package:akile_attendance_system/utilities/get_staff_id.dart';
import 'package:akile_attendance_system/utilities/get_round_letter.dart';
import 'package:akile_attendance_system/utilities/get_size.dart';
import 'package:provider/provider.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

class SideDrawer extends StatefulWidget {
  _SideDrawer createState() => _SideDrawer();
}

class _SideDrawer extends State<SideDrawer> implements ShouldImp {
  bool isDark = false;
  BuildContext context;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getSettingPref("dark").then((value) async {
      if (value == true) {
        setState(() {
          isDark = true;
        });
      } else if (value == false) {
        setState(() {
          isDark = false;
        });
      } else {
        setState(() {
          isDark = false;
        });
      }
    });
    super.initState();
  }

  String name, email, image;
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  build(BuildContext context) {
    return _buildDrawer(context);
  }

  clipShape(context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: getHeight(context),
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: getHeight(context),
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
              ),
            ),
          ),
        ),
      ],
    );
  }

  navigationDrawer(context) {
    return Drawer(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Flexible(
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 200.0,
                width: getWidth(context) * 0.5,
                child: Stack(
                  children: [
                    isDark == true ? Container() : clipShape(context),
                    Container(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: RoundedLetter(
                                text: getRoundLetter(getStaffId(context))
                                    .toUpperCase(),
                                shapeType: ShapeType.circle,
                                // shapeColor: PRIMARY_COLOR.withOpacity(0.5),
                                shapeSize: 60,
                                fontSize: 30,
                                borderWidth: 1,
                                borderColor: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Expanded(
                              child: Text(
                                getStaffId(context),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 40),
                    )
                  ],
                ),
              ),

              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //     context, SlideLeftRoute(page()));
                },
                title: _buildRow(Icons.timeline, "Change Password"),
              ),
              Divider(),
              ListTile(
                onTap: () {},
                title: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15),
                  child: Row(children: [
                    Icon(
                      Icons.wb_sunny,
                      color: PRIMARY_COLOR,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Dark mode",
                    ),
                    Switch(
                      value: Provider.of<AppState>(context).getTheme() ==
                              Constant.lightTheme
                          ? false
                          : true,
                      onChanged: (value) async {
                        setState(() {
                          isDark = !isDark;
                          setSettingPref(
                            key: "dark",
                            value: isDark,
                          );
                        });

                        if (isDark == true) {
                          Provider.of<AppState>(context, listen: false)
                              .setDark();
                        } else {
                          Provider.of<AppState>(context, listen: false)
                              .setLight();
                        }
                      },
                      activeTrackColor: PRIMARY_COLOR,
                      activeColor: SECONDARY_COLOR,
                    ),
                    Spacer(),
                  ]),
                ),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  ConfirmationDialog(
                      context: context,
                      title: "Are you sure to logout?",
                      callback: _SideDrawer());
                },
                title: _buildRow(Icons.exit_to_app, "Logout"),
              ),
            ],
          ),
        ),
      ),
    ]));
  }

  _buildDrawer(context) {
    return navigationDrawer(context);
  }

  _buildRow(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Row(children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
        SizedBox(width: 10.0),
        Text(
          title,
        ),
        Spacer(),
      ]),
    );
  }

  @override
  void changer({context, id}) {
    signOut();
    Navigator.pop(context);
    Navigator.of(context).pushNamedAndRemoveUntil(
        Constant.SIGN_IN, (Route<dynamic> route) => false);
  }
}
