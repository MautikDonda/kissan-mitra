import 'package:flutter/cupertino.dart';
import 'package:kissanmitra/screens/details/machine.dart';
import 'package:kissanmitra/screens/details/plant.dart';
import 'package:kissanmitra/screens/forms/addDistrict.dart';
import 'package:kissanmitra/screens/forms/addMachine.dart';
import 'package:kissanmitra/screens/forms/addPlant.dart';
import 'package:kissanmitra/screens/forms/addSoil.dart';
import 'package:kissanmitra/screens/forms/create-new-account.dart';
import 'package:kissanmitra/screens/drawer/crops.dart';
import 'package:kissanmitra/screens/drawer/gov_sites.dart';
import 'package:kissanmitra/screens/drawer/help.dart';
import 'package:kissanmitra/screens/drawer/machines.dart';
import 'package:kissanmitra/screens/drawer/settings.dart';
import 'package:kissanmitra/screens/drawer/soil.dart';
import 'package:kissanmitra/screens/forgot-password.dart';
import 'package:kissanmitra/screens/homescreen.dart';
import 'package:kissanmitra/screens/forms/login-screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kissanmitra/screens/homescreen_tabs/Agro/addFertilizer.dart';
import 'package:kissanmitra/screens/homescreen_tabs/Agro/fertilizers.dart';
import 'package:kissanmitra/screens/homescreen_tabs/Blog/newBlog.dart';
import 'package:kissanmitra/screens/profile.dart';
import 'package:kissanmitra/main.dart';

Map<String, WidgetBuilder> routes = {
  'ForgotPassword': (context) => ForgotPassword(),
  'CreateNewAccount': (context) => CreateNewAccount(),
  'login': (context) => LoginScreen(),
  'greet': (context) => Greetings(),
  'home': (context) => Homescreen(),
  'crops': (context) => CropsView(),
  'soil': (context) => SoilView(),
  'machine': (context) => MachineView(),
  'gov_site': (context) => GovSites(),
  'settings': (context) => Settings(),
  'help': (context) => Help(),
  'profile': (context) => Profile(),
  'addPlant': (c) => AddPlant(),
  'addMachine': (c) => AddMachine(),
  'addNewSoil': (c) => AddNewSoil(),
  'addDistrict': (c) => AddDistrict(),
  'newBlog': (c) => NewBlog(),
  'fertilizers':(c) => Fertilizers(),
  'addFertilizer':(c)=>AddFertilizer(),
};
