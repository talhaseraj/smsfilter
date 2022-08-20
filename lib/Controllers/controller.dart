import 'package:get/get.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';

class Controller extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMessages();
  }

  var isLoading = true.obs;
  SmsQuery query = SmsQuery();
  var found = true.obs;
  List<SmsMessage> allMessages = [];

  List<SmsMessage> displayMessages = [];
  var sum = 0.0.obs;
  var numberOfMonths = 0.obs;

  Future<void> getMessages() async {
    found.value = true;
    displayMessages.clear();
    allMessages.clear();
    isLoading.value = true;

    List<SmsMessage> messages = await query.getAllSms;
    for (SmsMessage sms in messages) {
      String sender = sms.sender!.toLowerCase();
      var body = sms.body;
      body = body?.replaceAll(",", "");

      if (sms.kind == SmsMessageKind.received) {
        if (isMobileNumberValid(sms.sender.toString())) {
        } else {
          if (body!.contains("AED")) {
            //   if(isTransactionSms(body)!=null)
            if (getTransactionAmount(body) != null) {
              allMessages.add(sms);
            }
          }

          // if(isTransactionSms(sms.body.toString()))
          //   {
          //
          //   }

        }
      }
    }
    displayMessages = allMessages;
    if (allMessages.isEmpty) {
      isLoading.value = true;
      Get.closeAllSnackbars();
      Get.snackbar("Search Result", "0 Results");
      found.value = false;
      update();
    } else {
      Get.closeAllSnackbars();
      Get.snackbar("Search Result", "${allMessages.length} Results");
      calculateTotal();
      countMonths();
      isLoading.value = false;
      found.value = true;

      update();
    }
    update();
  }

  void searchMessages(String key) {
    key = key.toLowerCase();

    displayMessages = [];
    for (SmsMessage sms in allMessages) {
      String sender = sms.sender!.toLowerCase();
      if (sender.contains(key)) {
        displayMessages.add(sms);
        update();
      }
    }
    if (displayMessages.isEmpty) {
      found.value = false;
    } else {
      Get.closeAllSnackbars();
      Get.snackbar("Search Result", "${displayMessages.length} Results");
    }
    if (key.isEmpty) {
      found.value = true;
      displayMessages = allMessages;
    }
    update();
    calculateTotal();
    countMonths();
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
    // RegExp exp = RegExp(r"(\b\d+\.\d+\b)");
    RegExp exp = RegExp(r"(\b\d+\.\d{2})");
    var match = exp.firstMatch(sms);
    if (match != null) {
      return double.parse(match[0].toString());
    } else {
      return null;
    }
  }

  String getAmount({required String value}) {
    value = value.replaceAll(",", "");
    String p = r"[AED]* [+-]?([0-9]*[.])?[0-9]+";

    RegExp regExp = RegExp(p);
    try {
      return regExp.stringMatch(value)!;
    } catch (E) {
      return "";
    }
  }

  void calculateTotal() {
    sum.value = 0.0;
    for (SmsMessage sms in displayMessages) {
      try {
        var temp = sms.body!.replaceAll(",", "");
        sum.value =
            sum.value + double.parse(getTransactionAmount(temp).toString());

        update();
      } catch (e) {
        print(e);
      }
    }
  }

  void countMonths() {
    numberOfMonths.value=0;
    List temp=[];
    for (SmsMessage sms in displayMessages) {

      var dateTime = sms.date;
      var month = DateFormat.MMMM().format(dateTime!);

      int monthIndex = displayMessages.indexWhere((element) {
        var temp = element.date;
        return DateFormat.yM().format(temp!) == month;
      });
      if(temp.contains(monthIndex))
        {

        }
      else
        {
          temp.add(monthIndex);
        }

    }
    numberOfMonths.value=temp.length;
    update();
  }
}
