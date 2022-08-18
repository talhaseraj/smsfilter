import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smsfilter/Controllers/controller.dart';

import '../colors.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';

class SmsFilter extends StatefulWidget {
  const SmsFilter({Key? key}) : super(key: key);

  @override
  State<SmsFilter> createState() => _SmsFilterState();
}

class _SmsFilterState extends State<SmsFilter> {
  TextEditingController searchController = TextEditingController();
  SmsQuery query = SmsQuery();
  List<SmsMessage> displayMessages = [];
  Controller controller = Get.put(Controller());
  double sum = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    getMessages("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(gradient: backgroundColor),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        "SMS FILTER",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 15),
                    height: size.height * .14,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white70,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Enter Some Text To Filter SMS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff006F88),
                            fontSize: size.width * .05,
                            fontWeight: FontWeight.bold,
                            fontFamily: "MontRegular",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: size.width * .12,
                          width: size.width * .8,
                          child: TextField(
                            onChanged: (input) {
                              if (input.isEmpty) {
                                getMessages("");
                              } else {
                                getMessages(input);
                              }
                            },
                            controller: searchController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: "Enter Text",
                              suffixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white70,
                  ),
                  child: Obx(
                    () => controller.isLoading.value
                        ? const CupertinoActivityIndicator(
                            radius: 50,
                            color: Colors.white,
                          )
                        : ListView.builder(
                            itemCount: displayMessages.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              var body = displayMessages[index].body;
                              body=body.toString().replaceAll(",", "");
                              var date =
                                  "${displayMessages[index].date?.day}/${displayMessages[index].date?.month}/${displayMessages[index].date?.year} ";
                              return Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            displayMessages[index]
                                                .sender
                                                .toString(),
                                            style: TextStyle(
                                              color: const Color(0xff006F88),
                                              fontSize: size.width * .05,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "MontRegular",
                                            ),
                                          ),
                                          Text(date),
                                        ],
                                      ),
                                      const Divider(thickness: 2),
                                      Text(
                                        "AED : ${getTransactionAmount(body)}",
                                        //getAmount(value: body.toString()),
                                        //maxLines: 1,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 30, left: 15, right: 15),
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    //    height: size.height * .14,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white70,
                    ),
                    child: Text(
                      "Total Amount : ${sum.toStringAsFixed(2)} AED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xff006F88),
                        fontSize: size.width * .05,
                        fontWeight: FontWeight.bold,
                        fontFamily: "MontRegular",
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Future<void> getMessages(String key) async {
    key = key.toLowerCase();
    displayMessages.clear();
    controller.isLoading.value = true;

    List<SmsMessage> messages = await query.getAllSms;
    for (SmsMessage sms in messages) {
      String sender = sms.sender!.toLowerCase();
      var body = sms.body;
      body=body?.replaceAll(",", "");

      if (sms.kind == SmsMessageKind.received) {
        if (isMobileNumberValid(sms.sender.toString())) {
        } else {
          if (sender.contains(key)) {
            if (body!.contains("AED")) {
              //   if(isTransactionSms(body)!=null)
              if (getTransactionAmount(body) != null) {

                displayMessages.add(sms);
              }
            }

            // if(isTransactionSms(sms.body.toString()))
            //   {
            //
            //   }

          }
        }
      }
    }
    if (displayMessages.isEmpty) {
      controller.isLoading.value = true;
      Get.snackbar("Search Result", "0 Results");
      controller.update();
    } else {
      Get.closeAllSnackbars();

      Get.snackbar("Search Result", "${displayMessages.length} Results");
      calculateTotal();
      controller.isLoading.value = false;
      controller.update();
    }
  }

  bool isMobileNumberValid(String phoneNumber) {
    String regexPattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    var regExp = RegExp(regexPattern);

    if (phoneNumber.isEmpty) {
      return false;
    } else if (regExp.hasMatch(phoneNumber)) {
      return true;
    }
    return false;
  }

  double? getTransactionAmount(String sms) {

    RegExp exp = RegExp(r"(\b\d+\.\d+\b)");
    var match = exp.firstMatch(sms);
    if (match != null) {
      print(match[0]);
      return double.parse(match[0].toString());
    } else {
      return null;
    }
  }

  String getAmount({required String value}) {
    value=value.replaceAll(",", "");
    String p = r"[AED]* [+-]?([0-9]*[.])?[0-9]+";

    RegExp regExp = RegExp(p);
try
{
  return regExp.stringMatch(value)!;
}
  catch(E)
    {
      return "";
    }
  }

  void calculateTotal() {
    sum = 0.0;
    for (SmsMessage sms in displayMessages) {
      try {
        var temp=sms.body!.replaceAll(",", "");
        print(getTransactionAmount(temp));
        sum = sum +
            double.parse(getTransactionAmount(temp).toString());
        setState(() {
          controller.update();
        });
      } catch (e) {
        print(e);
      }
    }
  }
}
