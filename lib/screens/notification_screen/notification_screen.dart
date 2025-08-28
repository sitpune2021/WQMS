import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark-blue status bar with light icons
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //     statusBarBrightness: Brightness.dark,
    //   ),
    // );

    return Scaffold(
      body: Container(
        // Gradient page background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0F7F9), Color(0xFF00B3A4)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Reserve/pain the status bar height in dark blue
              Container(
                height: MediaQuery.of(context).padding.top,
                color: const Color(0xFF002D96),
              ),

              // Header row (on gradient, not inside blue bar)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: ColorConstants.apptitleColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "नोटिफिकेशन",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // >>> BACKGROUND CONTAINER <<<
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 10,
                        right: 10,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          // Light grey inner row with text + eye icon
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Text(
                                    '"तक्रार नोंद झाली आहे"',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),

                          // take up remaining space so button sticks to bottom
                          const Spacer(),

                          // ✅ Submit button at bottom
                          // SizedBox(
                          //   width: double.infinity,
                          //   height: 48,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: const Color(0xFF34D2C0),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(4),
                          //       ),
                          //       elevation: 0,
                          //     ),
                          //     onPressed: () {},
                          //     child: const Text(
                          //       "सबमिट",
                          //       style: TextStyle(
                          //         color: Color(0xFF002D96),
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.w800,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
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
