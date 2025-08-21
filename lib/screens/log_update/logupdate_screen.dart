import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/model/work_response.dart';
import 'package:workqualitymonitoringsystem/screens/yojna_list/yojna_list.dart';

class LogUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> logData;

  const LogUpdateScreen({super.key, required this.logData});

  @override
  State<LogUpdateScreen> createState() => _LogUpdateScreenState();
}

class _LogUpdateScreenState extends State<LogUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  String? workName; // Work Name to fetch from API
  bool isLoading = true;

  late TextEditingController workIdController;
  late TextEditingController locationController;
  late TextEditingController inspectionDateController;
  late TextEditingController detailsController;
  late TextEditingController remarkController;
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    workIdController = TextEditingController();
    locationController = TextEditingController();
    inspectionDateController = TextEditingController();
    detailsController = TextEditingController();
    remarkController = TextEditingController();
    commentController = TextEditingController();
    fetchWorkNameFromAPI();
  }

  @override
  void dispose() {
    workIdController.dispose();
    locationController.dispose();
    inspectionDateController.dispose();
    detailsController.dispose();
    remarkController.dispose();
    commentController.dispose();
    super.dispose();
  }

  Future<void> fetchWorkNameFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse("https://bandhkam.demosoftware.co.in/work_list"),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final workResponse = WorkResponse.fromJson(jsonData);

        if (workResponse.status == "success" &&
            workResponse.details.isNotEmpty) {
          setState(() {
            workName = workResponse.details.first.workName; // first work
            isLoading = false;
          });
        } else {
          setState(() {
            workName = "काम उपलब्ध नाही";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          workName = "Server error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        workName = "Error: $e";
        isLoading = false;
      });
    }
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
                padding: const EdgeInsets.symmetric(vertical: 10),
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
                        "लॉग ",
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
              // Main Form
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
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Form(
                            key: _formKey,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                // Work Name as static text
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "कामाचे नाव",
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Text(
                                          workName ?? "N/A",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                _buildEditableField(
                                  "कामाचा आयडी",
                                  workIdController,
                                ),
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

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.buttonColor,
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
  }) => Padding(
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

  Widget _buildDateField(
    String label,
    TextEditingController controller,
  ) => Padding(
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
          validator: (value) => (value == null || value.trim().isEmpty)
              ? "$label आवश्यक आहे"
              : null,
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
              image: (imageUrl != null)
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
