import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/log_report/log_report.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController workNameController = TextEditingController();
  final TextEditingController workIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? beforeImage;
  File? afterImage;
  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    workNameController.dispose();
    workIdController.dispose();
    locationController.dispose();
    dateController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  // Request permissions
  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  // Pick Date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  // Pick Image
  Future<void> pickImage(bool isBefore) async {
    await requestPermissions();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final XFile? file = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (file != null) {
                  setState(() {
                    if (isBefore) {
                      beforeImage = File(file.path);
                    } else {
                      afterImage = File(file.path);
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.of(ctx).pop();
                final XFile? file = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (file != null) {
                  setState(() {
                    if (isBefore) {
                      beforeImage = File(file.path);
                    } else {
                      afterImage = File(file.path);
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Submit Form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "workName": workNameController.text,
        "workId": workIdController.text,
        "location": locationController.text,
        "date": dateController.text,
        "remarks": remarksController.text,
        "beforeImage": beforeImage?.path,
        "afterImage": afterImage?.path,
      };
      debugPrint("Form Data: $data");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Report Submitted!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: width,
          decoration: BoxDecoration(gradient: ColorConstants.backScreenColor),
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios_new, size: width * 0.05),
                  ),
                  Text(
                    ' रिपोर्ट ',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),

              // Main Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.025),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildLabel("कामाचे नाव", width),
                          buildField(
                            workNameController,
                            "कामाचे नाव टाका",
                            width,
                          ),
                          SizedBox(height: height * 0.012),

                          buildLabel("कामाचा आयडी", width),
                          buildField(
                            workIdController,
                            "उदा. 432",
                            width,
                            type: TextInputType.number,
                          ),
                          SizedBox(height: height * 0.012),

                          buildLabel("साइटचे ठिकाण", width),
                          buildField(locationController, "ठिकाण टाका", width),
                          SizedBox(height: height * 0.012),

                          buildLabel("तपासणीची तारीख", width),
                          TextFormField(
                            controller: dateController,
                            readOnly: true,
                            onTap: () => _pickDate(context),
                            style: TextStyle(fontSize: width * 0.038),
                            decoration: inputDecoration("तारीख निवडा", width)
                                .copyWith(
                                  suffixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                ),
                            validator: (v) => v!.isEmpty ? "तारीख निवडा" : null,
                          ),
                          SizedBox(height: height * 0.018),

                          // Photos
                          Row(
                            children: [
                              Expanded(
                                child: buildPhotoBox(
                                  "पूर्वीचा फोटो",
                                  width,
                                  height,
                                  beforeImage,
                                  () => pickImage(true),
                                ),
                              ),
                              SizedBox(width: width * 0.03),
                              Expanded(
                                child: buildPhotoBox(
                                  "नंतरचा फोटो",
                                  width,
                                  height,
                                  afterImage,
                                  () => pickImage(false),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.018),

                          buildLabel("टिप्पणी / निर्देश", width),
                          TextFormField(
                            controller: remarksController,
                            maxLines: 5,
                            minLines: 3,
                            style: TextStyle(fontSize: width * 0.038),
                            decoration: inputDecoration(
                              "कामाच्या दर्जा...",
                              width,
                            ),
                          ),
                          SizedBox(height: height * 0.02),

                          // ✅ EDIT BUTTON INSIDE WHITE CONTAINER
                          SizedBox(
                            width: double.infinity,
                            height: height * 0.055,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    width * 0.02,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LogReportScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                " एडिट ",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: ColorConstants.iconColor,
                                  fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text, double width) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: width * 0.038),
      ),
    );
  }

  Widget buildField(
    TextEditingController controller,
    String hint,
    double width, {
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      style: TextStyle(fontSize: width * 0.038),
      decoration: inputDecoration(hint, width),
      validator: (v) => v!.isEmpty ? hint : null,
    );
  }

  Widget buildPhotoBox(
    String label,
    double width,
    double height,
    File? image,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: width * 0.035)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: height * 0.09,
            width: width * 0.35,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(width * 0.02),
              color: Colors.grey[200],
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                : Icon(
                    Icons.add_a_photo,
                    size: width * 0.12,
                    color: Colors.grey,
                  ),
          ),
        ),
      ],
    );
  }

  InputDecoration inputDecoration(String hint, double width) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: width * 0.035),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.03,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(width * 0.02),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(width * 0.02),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(width * 0.02),
        borderSide: const BorderSide(color: Colors.teal, width: 1.5),
      ),
    );
  }
}
