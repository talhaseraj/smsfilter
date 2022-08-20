import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smsfilter/Controllers/controller.dart';
import 'package:intl/intl.dart';
import '../colors.dart';
import 'package:get/get.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class SmsFilter extends StatefulWidget {
  const SmsFilter({Key? key}) : super(key: key);

  @override
  State<SmsFilter> createState() => _SmsFilterState();
}

class _SmsFilterState extends State<SmsFilter> {
  TextEditingController searchController = TextEditingController();

  var month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GetBuilder<Controller>(
          init: Controller(),
          builder: (controller) => SingleChildScrollView(
                child: Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(gradient: backgroundColor),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SafeArea(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              const Text(
                                "SMS FILTER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onTap: () {
                                  searchController.text="";
                                  controller.getMessages();
                                },
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
                                      controller.searchMessages(input);
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white70,
                          ),
                          child: Obx(
                            () => controller.found.value
                                ? controller.isLoading.value
                                    ? const CupertinoActivityIndicator(
                                        radius: 50,
                                        color: Colors.white,
                                      )
                                    : ListView.builder(
                                        cacheExtent: 10,
                                        itemCount:
                                            controller.displayMessages.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          SmsMessage sms =
                                              controller.displayMessages[index];
                                          var dateTime = sms.date;
                                          var body = sms.body;
                                          body = body
                                              .toString()
                                              .replaceAll(",", "");
                                          var date =
                                              "${dateTime?.day}/${dateTime?.month}/${dateTime!.year} ";

                                          month =
                                              DateFormat.yM().format(dateTime!);

                                          int monthIndex = controller
                                              .displayMessages
                                              .indexWhere((element) {
                                            var temp = element.date;
                                            return DateFormat.yM()
                                                    .format(temp!) ==
                                                month;
                                          });

                                          return Column(
                                            children: [
                                              if (index == monthIndex)
                                                Card(
                                                  child: Center(
                                                    heightFactor: 2.3,
                                                    child: Text(
                                                        DateFormat.MMMM()
                                                            .format(dateTime!),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                size.width *
                                                                    .05,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                  color:
                                                      const Color(0xff00D3FE),
                                                ),
                                              Card(
                                                elevation: 3,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            sms.sender
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xff006F88),
                                                              fontSize:
                                                                  size.width *
                                                                      .05,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "MontRegular",
                                                            ),
                                                          ),
                                                          Text(date),
                                                        ],
                                                      ),
                                                      const Divider(
                                                          thickness: 2),
                                                      Text(
                                                        "AED : ${controller.getTransactionAmount(body)}",
                                                        //getAmount(value: body.toString()),
                                                        //maxLines: 1,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                : const Center(
                                    child: Icon(
                                    Icons.search_off,
                                    size: 100,
                                  )),
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, bottom: 30, left: 15, right: 15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            //    height: size.height * .14,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white70,
                            ),
                            child: Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${controller.sum.toStringAsFixed(2)} AED",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xff006F88),
                                      fontSize: size.width * .05,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "MontRegular",
                                    ),
                                  ),
                                  Text(
                                    "${controller.numberOfMonths} Months",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xff006F88),
                                      fontSize: size.width * .05,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "MontRegular",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              )),
    );
  }
}
