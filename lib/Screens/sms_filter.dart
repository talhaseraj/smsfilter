import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smsfilter/Controllers/controller.dart';

import '../colors.dart';
import 'package:get/get.dart';

class SmsFilter extends StatefulWidget {
  const SmsFilter({Key? key}) : super(key: key);
  @override
  State<SmsFilter> createState() => _SmsFilterState();
}

class _SmsFilterState extends State<SmsFilter> {
  TextEditingController searchController = TextEditingController();
 // Controller controller = Get.put(Controller());

  @override
  void initState() {
    // TODO: implement initState
   // controller.getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:GetBuilder<Controller>( // specify type as Controller
        init: Controller(), // intialize with the Controller
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
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
                        onTap: (){

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
                             // setState(() {
                                print(controller.displayMessages.length);
                                print(controller.allMessages.length);

                                 controller.searchMessages(input);
                                // if(input=="")
                                // {
                                //   controller.displayMessages=controller.allMessages;
                                // }

                            //  });

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
                    () => controller.found.value? controller.isLoading.value
                        ? const CupertinoActivityIndicator(
                            radius: 50,
                            color: Colors.white,
                          )
                        : ListView.builder(
                            itemCount: controller.displayMessages.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              var body = controller.displayMessages[index].body;
                              body=body.toString().replaceAll(",", "");
                              var date =
                                  "${controller.displayMessages[index].date?.day}/${controller.displayMessages[index].date?.month}/${controller.displayMessages[index].date?.year} ";
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
                                            controller.displayMessages[index]
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
                                        "AED : ${controller.getTransactionAmount(body)}",
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
                          ):
                    const Center(child: Icon(Icons.search_off,size: 100,)),
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
                    child: Obx(()=> Text(
                      "Total Amount : ${controller.sum.toStringAsFixed(2)} AED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xff006F88),
                        fontSize: size.width * .05,
                        fontWeight: FontWeight.bold,
                        fontFamily: "MontRegular",
                      ),
                    ),),
                  ),
                ),
              ]),
        ),
    )),
    );
  }


}
