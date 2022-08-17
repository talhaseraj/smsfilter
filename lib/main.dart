import 'package:flutter/material.dart';
import 'package:smsfilter/Screens/sms_filter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var permission = await Permission.sms.status;
  if (permission.isGranted) {


  } else {
    await Permission.sms.request();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const SmsFilter(),
    );
  }
}

