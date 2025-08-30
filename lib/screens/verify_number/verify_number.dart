import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workqualitymonitoringsystem/auth/auth.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/otp_screen/otp_screen.dart';
// import 'package:field_visit/screens/otp/otp_screen.dart';  // optional

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({super.key});

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneCtrl = TextEditingController();
  bool _sending = false;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);

    final result = await Auth.sendOtp(phoneCtrl.text.trim());

    if (!mounted) return;

    setState(() => _sending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success ? Colors.green : Colors.red,
      ),
    );

    if (result.success) {
      // Navigate to OTP screen (pass mobile / otp if needed)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(mobile: result.mobile!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //     statusBarBrightness: Brightness.dark,
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text("पासवर्ड विसरलात?"),
      //   centerTitle: true,
      //   backgroundColor: ColorConstants.orange,
      //   foregroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 60),

                // Logo (reuse same asset)
                Center(
                  child: Image.asset('assets/images/logo.png', height: 220),
                ),
                const SizedBox(height: 20),

                // Header Text
                const Text(
                  "पासवर्ड विसरलात का ?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "तुमच्या खात्याशी लिंक असलेला मोबाइल नंबर खाली द्या",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Mobile Field
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'मोबाईल क्रमांक टाका',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.iconColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.iconColor,
                        width: 2,
                      ),
                    ),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'कृपया मोबाईल क्रमांक टाका';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                      return 'मोबाईल क्रमांक 10 अंकांचा असावा';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Send OTP button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _sending ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: _sending
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'OTP पाठवा',
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorConstants.buttonTxtColor,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
