import 'package:flutter/material.dart';
import 'package:akile_attendance_system/pages/assignments.dart';
import 'package:akile_attendance_system/pages/notifications.dart';
import 'package:akile_attendance_system/pages/checkIn.dart';
import 'package:akile_attendance_system/pages/drawer/navigationDrawer.dart';
import 'package:akile_attendance_system/utilities/abstract_classes/confirmation_abstract.dart';
import 'package:akile_attendance_system/constants/colors.dart';
import 'package:akile_attendance_system/state/appState.dart';
import 'package:akile_attendance_system/utilities/get_size.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget{
  HomePage createState()=>HomePage();
}
class HomePage extends State<Home> implements ShouldImp {
  @override
  void changer({context, id}) {
  }

  pageTaped(page) {
    switch ( Provider.of<Auth>(context,listen: false).getHomePageTabFun()) {
      case 0:
        return CheckIn();
        break;
      case 1:
        return Assignments();
        break;
      default:
        return Notifications();
    }
  }

  getTitle(context) {
    if (Provider.of<Auth>(context,listen: false).getHomePageTabFun() == 0)
      return "Home";
    else if (Provider.of<Auth>(context,listen: false).getHomePageTabFun()  == 1)
      return "Assignments";
    else
      return "Notifications";
  }

  void onTabTapped(int index) {
    Provider.of<Auth>(context,listen: false).setHomePageTabFun(index);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(getTitle(context), style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: TRIAL_COLOR),
      ),
      drawer: Container(
        width: getWidth(context)*0.75,
        height: getHeight(context),
        child: SideDrawer(),
      ),
      body: Container(
        child: Center(
          child: pageTaped(Provider.of<Auth>(context).getHomePageTabFun()),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: Provider.of<Auth>(context).getHomePageTabFun() ,

        selectedItemColor: PRIMARY_COLOR,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.assignment),
            title: new Text('Assignments'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications),
            title: new Text('Notifications'),
          )
        ],
        onTap: onTabTapped,
      ),
    );
  }
}