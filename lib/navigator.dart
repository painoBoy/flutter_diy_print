import './pages/account/setting_page.dart';

import './pages/modelLibrary/modelLib_page.dart';
import './pages/workspace/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/provider/printCommand.dart';
class NavigatorBarPage extends StatefulWidget {
  @override
  _NavigatorBarPageState createState() => _NavigatorBarPageState();
}

class _NavigatorBarPageState extends State<NavigatorBarPage> {
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  List<Widget> pageList = [
    Home(
      key: childKey,
    ),
    ModelLibraryPage(),
    SettingPage()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    print("tabs init");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    //抽屉Head
    var drawerHeader = DrawerHeader(
      decoration: BoxDecoration(
        color: Color(0xFFFF8633),
      ),
      child: Text(
        'ad Header',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
    return Scaffold(
        drawer: Drawer(
          //左滑抽屉
          child: ListView(
            padding: EdgeInsets.zero, //去除左滑顶部padding
            children: <Widget>[
              drawerHeader,
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              Divider(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedFontSize: 14,
          selectedFontSize: 14,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          // selectedItemColor:Colors.green,
          items: [
            createItem("workspace", "Workspace"),
            createItem("model_lib", "Model Lib"),
            createItem("account", "Account"),
          ],
          onTap: (int index) {
            // if (index == 0) {
            //   // childKey.currentState.initTimer();
            //   // childKey.currentState.getPrinterInfo();
            // // } else {
            // //   childKey.currentState.cancelTimer();
            // }
            _pageController.jumpToPage(index);
            if (mounted)
              setState(() {
                _currentIndex = index;
              });
          },
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: pageList,
        )
        // IndexedStack(
        //   index: _currentIndex,
        //   children: <Widget>[
        //     Home(
        //       key: childKey,
        //     ),
        //     ModelLibraryPage(),
        //     SettingPage(),
        //   ],
        // )
        );
  }
}

BottomNavigationBarItem createItem(String iconName, String title) {
  return BottomNavigationBarItem(
      icon: Image.asset("assets/images/tabbar/$iconName.png",
          width: ScreenUtil().setWidth(38)),
      activeIcon: Image.asset(
        "assets/images/tabbar/${iconName}_active.png",
        width: ScreenUtil().setWidth(38),
      ),
      title: Text(title));
}
