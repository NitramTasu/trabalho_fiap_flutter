import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_fiap_flutter/provider/theme_provider.dart';

class FAB extends StatelessWidget {
  const FAB({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentThemeType = Provider.of<ThemeProvider>(context).currentThemeType;
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.red,
        animatedIconTheme: IconThemeData(size: 22.0),
        children: [
          SpeedDialChild(
            child: Image.asset("images/fire.png"),
            backgroundColor: Colors.black,
            onTap: () {
              Navigator.pushNamed(context, "/firestore");
            },
            label: 'Salvos no Firestore',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
          SpeedDialChild(
            child: Image.asset("images/server.png"),
            backgroundColor: Colors.black,
            onTap: () {
              Navigator.pushNamed(context, "/floor");
            },
            label: 'Salvos no Floor',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
          SpeedDialChild(
            child: Image.asset("images/brush.png"),
            backgroundColor: Colors.black,
            onTap: () async {
              if (currentThemeType == ThemeType.dark) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme(ThemeType.light);
              } else {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme(ThemeType.dark);
              }
            },
            label: 'Mudar Tema',
            labelStyle:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            labelBackgroundColor: Colors.black,
          ),
        ]);
  }
}
