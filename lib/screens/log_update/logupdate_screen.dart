import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/log_report/log_report.dart';
import 'package:workqualitymonitoringsystem/screens/yojna_list/yojna_list.dart';

class LogUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> logData;

  const LogUpdateScreen({super.key, required this.logData});

  @override
  State<LogUpdateScreen> createState() => _LogUpdateScreenState();
}

class _LogUpdateScreenState extends State<LogUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController workNameController;
  late TextEditingController workIdController;
  late TextEditingController locationController;
  late TextEditingController inspectionDateController;
  late TextEditingController detailsController;
  late TextEditingController remarkController;
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    // Controllers start empty; hint text shows previous value
    workNameController = TextEditingController();
    workIdController = TextEditingController();
    locationController = TextEditingController();
    inspectionDateController = TextEditingController();
    detailsController = TextEditingController();
    remarkController = TextEditingController();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    workNameController.dispose();
    workIdController.dispose();
    locationController.dispose();
    inspectionDateController.dispose();
    detailsController.dispose();
    remarkController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("फॉर्म यशस्वीरित्या जतन केला")),
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => YojnaList()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया सर्व आवश्यक माहिती भरा")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: ColorConstants.backScreenColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  // horizontal: screenWidth * 0.04,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: screenWidth * 0.05,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: screenWidth * .03),
                    Expanded(
                      child: Text(
                        " रिपोर्ट ",
                        style: GoogleFonts.inter(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Form Container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildEditableField("कामाचे नाव", workNameController),
                          _buildEditableField("कामाचा आयडी", workIdController),
                          _buildEditableField(
                            "साईटचे ठिकाण",
                            locationController,
                          ),
                          _buildDateField(
                            "तपासणीची तारीख",
                            inspectionDateController,
                          ),
                          _buildEditableField(
                            "तपशील",
                            detailsController,
                            required: false,
                          ),
                          _buildEditableField(
                            "शेरा",
                            remarkController,
                            required: false,
                          ),

                          const SizedBox(height: 16),

                          // Photos
                          Row(
                            children: [
                              _buildPhotoCard(
                                "पूर्वीचा फोटो",
                                widget.logData["beforePhoto"],
                                screenWidth,
                                height: screenWidth * 0.25,
                              ),
                              const SizedBox(width: 10),
                              _buildPhotoCard(
                                "नंतरचा फोटो",
                                widget.logData["afterPhoto"],
                                screenWidth,
                                height: screenWidth * 0.25,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildEditableField(
                            " टिपणी / निरीक्षण  ",
                            commentController,
                          ),
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.buttonColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "जतन करा",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: widget.logData[label] ?? label,
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            validator: (value) {
              if (required && (value == null || value.trim().isEmpty)) {
                return "$label आवश्यक आहे";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: widget.logData[label] ?? label,
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "$label आवश्यक आहे";
              }
              return null;
            },
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                String formattedDate =
                    "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                setState(() {
                  controller.text = formattedDate;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(
    String label,
    String? imageUrl,
    double screenWidth, {
    double height = 100,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: height,
            width: screenWidth * 0.4,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? const Icon(Icons.image, size: 40, color: Colors.grey)
                : null,
          ),
        ],
      ),
    );
  }
}
