import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:workqualitymonitoringsystem/constants/constant.dart';

class CheckInternet {
  static Future<bool> hasInternetAccess() async {
    try {
      final response = await http.get(
        Uri.parse(Constant.officeType),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print("Constant.officeType ${Constant.officeType}");
        print("officeType response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("OfficeTypeList Error $e");
      }
      return false;
    }
    return false;
  }
}
