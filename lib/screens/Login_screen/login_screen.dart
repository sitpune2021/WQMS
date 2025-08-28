import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workqualitymonitoringsystem/auth/auth.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/dashboard/dashboard_screen.dart';
import 'package:workqualitymonitoringsystem/screens/verify_number/verify_number.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF39CCC1), // Dark Blue
              Color(0xFFFDEFFFD), // Cyan
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // 🔹 Title
              Text(
                "लॉग इन स्क्रीन",
                style: GoogleFonts.inter(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //const SizedBox(height: 20),

              // 🔹 White Container (FULL HEIGHT)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 30, right: 15),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Logo
                            Center(
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 120,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Mobile Number
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "मोबाईल क्रमांक टाका",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                hintText: "9992912782",
                                counterText: "",
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: ColorConstants.iconColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: ColorConstants.iconColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 10) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'कृपया मोबाईल क्रमांक टाका';
                                } else if (!RegExp(
                                  r'^[0-9]{10}$',
                                ).hasMatch(value)) {
                                  return 'मोबाईल क्रमांक 10 अंकांचा असावा';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "पासवर्ड टाका",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: ColorConstants.iconColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: ColorConstants.iconColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: ColorConstants.iconColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: ColorConstants.iconColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'कृपया पासवर्ड टाका';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );

                                    final responseMessage = await Auth.login(
                                      mobileController.text.trim(),
                                      passwordController.text.trim(),
                                    );

                                    Navigator.of(context).pop(); // close loader

                                    if (responseMessage ==
                                        "Successfully logged In.") {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      mobileController.clear();
                                      passwordController.clear();
                                      prefs.setBool("isLoggedIn", true);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'यशस्वी लॉगिन: $responseMessage',
                                          ),
                                        ),
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const DashboardScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(responseMessage),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants.buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  "लॉग इन",
                                  style: TextStyle(
                                    color: ColorConstants.buttonTxtColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Change Password
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const VerifyNumber(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    RemixIcons.lock_2_fill,
                                    size: 24,
                                    color: ColorConstants.iconColor,
                                  ),
                                  label: const Text(
                                    "पासवर्ड बदल",
                                    style: TextStyle(
                                      color: ColorConstants.iconColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
