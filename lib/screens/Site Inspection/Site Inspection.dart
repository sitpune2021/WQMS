import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/report_screen/report_screen.dart';
import 'package:workqualitymonitoringsystem/screens/yojna_list/yojna_list.dart';

class SiteInspectionForm extends StatefulWidget {
  final String workName; // 🔹 Passed from last screen

  const SiteInspectionForm({super.key, required this.workName});

  @override
  State<SiteInspectionForm> createState() => _SiteInspectionFormState();
}

class _SiteInspectionFormState extends State<SiteInspectionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? uploadedPhoto;
  String? uploadedVideo;

  /// 🔹 Submit Form
  /// 🔹 Submit Form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (uploadedPhoto == null || uploadedPhoto!.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("कृपया कामाचा फोटो टाका")));
        return;
      }

      if (uploadedVideo == null || uploadedVideo!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("कृपया कामाचा व्हिडिओ टाका")),
        );
        return;
      }

      final requestData = {
        "workName": widget.workName,
        "details": _detailsController.text,
        "remark": _remarkController.text,
        "description": _descriptionController.text,
        "photo": uploadedPhoto,
        "video": uploadedVideo,
      };

      debugPrint("Submitted Data: $requestData");

      Navigator.push(context, MaterialPageRoute(builder: (_) => YojnaList()));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("जतन केले")));
    }
  }

  InputDecoration inputDecoration(String hint, double width) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.04,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.backScreenColor),
        child: Column(
          children: [
            /// 🔹 Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: screenWidth * 0.05,
                      color: ColorConstants.iconColor,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    "स्थळ पाहणी",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.apptitleColor,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 White container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 Work Name (From Last Screen)
                          Text(
                            "कामाचे नाव : ${widget.workName}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          /// 🔹 तपशील
                          Text(
                            'तपशील ',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          TextFormField(
                            controller: _detailsController,
                            decoration: const InputDecoration(
                              labelText: "तपशील",
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? "तपशील भरा" : null,
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          /// 🔹 शेरा
                          Text(
                            'शेरा ',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          TextFormField(
                            controller: _remarkController,
                            decoration: const InputDecoration(
                              labelText: "शेरा",
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? "शेरा भरा" : null,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'टिप्पणी / निर्देश',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 5,
                            minLines: 3,
                            style: TextStyle(fontSize: screenWidth * 0.038),
                            decoration: inputDecoration(
                              "कामाच्या दर्जा...",
                              screenWidth,
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? "टिप्पणी / निर्देश भरा"
                                : null,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          /// 🔹 फोटो
                          Text(
                            'कामाचा फोटो ',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          InkWell(
                            onTap: () {
                              setState(() {
                                uploadedPhoto = "photo.jpg";
                              });
                            },
                            child: Container(
                              width: screenWidth * .45,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    RemixIcons.upload_2_line,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 8),
                                  Text("फोटो टाका"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          /// 🔹 व्हिडिओ
                          Text(
                            'कामाचा व्हिडिओ ',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          InkWell(
                            onTap: () {
                              setState(() {
                                uploadedVideo = "video.mp4";
                              });
                            },
                            child: Container(
                              width: screenWidth * .45,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    RemixIcons.upload_2_line,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 8),
                                  Text("व्हिडिओ टाका"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          /// 🔹 Save button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.buttonColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _submitForm,
                              child: Text(
                                "जतन करा",
                                style: GoogleFonts.inter(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
