import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // ✅ added
import 'package:remixicon/remixicon.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/yojna_list/yojna_list.dart';

class SiteInspectionForm extends StatefulWidget {
  final String workName;
  final Map<String, dynamic> workData;
  const SiteInspectionForm({
    super.key,
    required this.workName,
    required this.workData,
  });

  @override
  State<SiteInspectionForm> createState() => _SiteInspectionFormState();
}

class _SiteInspectionFormState extends State<SiteInspectionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<File> selectedPhotos = [];
  File? selectedVideo;
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  /// 🔹 Submit Form
  /// 🔹 Submit Form
  Future<void> submitForm() async {
    if (_isSubmitting) return; // avoid double click
    setState(() => _isSubmitting = true);

    // 🔹 Validation before API call
    if (selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया किमान १ फोटो निवडा📸")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    if (selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया एक व्हिडिओ निवडा 🎥")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter description 📝")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    if (_remarkController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("कृपया वर्णन भरा 🗒️")));
      setState(() => _isSubmitting = false);
      return;
    }

    if (widget.workData["work_type_id"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया कामाचा प्रकार निवडा ⚒️")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    if (widget.workData["work_layer_id"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया कामाचा थर निवडा 🏗️")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      var uri = Uri.parse("https://bandhkam.demosoftware.co.in/add_visit");
      var request = http.MultipartRequest("POST", uri);

      // Normal fields
      request.fields["visited_by"] = widget.workData["visited_by"].toString();
      request.fields["work_item_id"] = widget.workData["work_item_id"]
          .toString();
      request.fields["is_ongoing"] = widget.workData["is_ongoing"].toString();
      request.fields["work_type_id"] = widget.workData["work_type_id"]
          .toString();
      request.fields["work_layer_id"] = widget.workData["work_layer_id"]
          .toString();
      request.fields["description"] = _descriptionController.text.trim();
      request.fields["remark"] = _remarkController.text.trim();

      // Photos
      for (var photo in selectedPhotos) {
        request.files.add(
          await http.MultipartFile.fromPath("photo[]", photo.path),
        );
      }

      // ✅ Single Video
      if (selectedVideo != null) {
        request.files.add(
          await http.MultipartFile.fromPath("video", selectedVideo!.path),
        );
      }

      log("📤 Sending request with fields: ${request.fields}");
      log(
        "📤 Sending ${selectedPhotos.length} photos & ${selectedVideo != null ? 1 : 0} video",
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        log("✅ Success: $responseBody");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("फॉर्म जतन झाला ✅"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // ✅ Direct navigation without delay
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const YojnaList()),
          );
        }
      } else {
        log("❌ Failed [${response.statusCode}]: $responseBody");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("फॉर्म जतन करण्यात अयशस्वी ❌"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      log("🔥 Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  /// 🔹 Pick Photo
  Future<void> pickPhotos() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        selectedPhotos = pickedFiles.map((x) => File(x.path)).toList();
      });
      log("📸 Selected Photos: ${selectedPhotos.length}");
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        setState(() {
          selectedVideo = File(video.path);
        });
        log("🎥 Selected Video: ${selectedVideo!.path}");
      } else {
        log("⚠️ No video selected");
      }
    } catch (e) {
      log("🔥 Error picking video: $e");
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

            /// 🔹 White Container
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
                          /// कामाचे नाव
                          Text(
                            "कामाचे नाव : ${widget.workName}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          /// तपशील
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

                          /// शेरा
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

                          /// टिप्पणी
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

                          /// फोटो
                          Text(
                            'कामाचा फोटो ',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          InkWell(
                            onTap: pickPhotos,
                            child: Container(
                              width: screenWidth * .45,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    RemixIcons.upload_2_line,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    selectedPhotos.isNotEmpty
                                        ? "फोटो निवडला"
                                        : "फोटो टाका",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          /// व्हिडिओ
                          Text(
                            'कामाचा व्हिडिओ ',
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          InkWell(
                            onTap: pickVideo,
                            child: Container(
                              width: screenWidth * .45,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    RemixIcons.upload_2_line,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    selectedVideo != null
                                        ? "व्हिडिओ निवडला"
                                        : "व्हिडिओ टाका",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          /// Save button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.buttonColor,
                                minimumSize: Size(double.infinity, 50),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
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
