import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/model/work_response.dart';
import 'package:workqualitymonitoringsystem/model/work_type.dart';
import 'package:workqualitymonitoringsystem/model/work_layer.dart';
import 'package:workqualitymonitoringsystem/screens/Site%20Inspection/Site%20Inspection.dart';

class WorkDetailScreen extends StatefulWidget {
  final WorkDetails work;
  final Map<String, dynamic> workData;

  const WorkDetailScreen({
    super.key,
    required this.work,
    required this.workData,
  });

  @override
  State<WorkDetailScreen> createState() => _WorkDetailScreenState();
}

class _WorkDetailScreenState extends State<WorkDetailScreen> {
  final TextEditingController reasonController = TextEditingController();

  bool? isWorkOngoing;
  String? selectedType;
  String? selectedWorkLayerId;
  Map<String, dynamic>? workDetails;
  bool isLoading = true;
  bool hasError = false;

  WorkType? workTypeData;
  bool isWorkTypeLoading = true;

  WorkLayerResponse? workLayerData;
  bool isWorkLayerLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWorkDetails();
    fetchWorkTypes();
  }

  Future<void> fetchWorkDetails() async {
    const url = "https://bandhkam.demosoftware.co.in/work_details";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"work_id": widget.work.id}),
      );

      log("Status Code: ${response.statusCode}");
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          setState(() {
            workDetails = data["details"];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            hasError = true;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      log("Error fetching work details: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> fetchWorkTypes() async {
    const url = "https://bandhkam.demosoftware.co.in/work_type_list";
    try {
      final response = await http.get(Uri.parse(url));
      log("WorkType Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          workTypeData = WorkType.fromJson(data);
          isWorkTypeLoading = false;
        });
      } else {
        setState(() => isWorkTypeLoading = false);
      }
    } catch (e) {
      log("Error fetching work types: $e");
      setState(() => isWorkTypeLoading = false);
    }
  }

  Future<void> fetchWorkLayers(String workTypeId) async {
    const url = "https://bandhkam.demosoftware.co.in/work_layer_list";
    setState(() => isWorkLayerLoading = true);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"work_type_id": workTypeId}),
      );

      log("Layer API Status: ${response.statusCode}");
      log("Layer API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          workLayerData = WorkLayerResponse.fromJson(data);
          isWorkLayerLoading = false;
        });
      } else {
        setState(() => isWorkLayerLoading = false);
      }
    } catch (e) {
      log("Error fetching work layers: $e");
      setState(() => isWorkLayerLoading = false);
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );

    final double containerTop = height * 0.01;
    final double font = width * 0.04;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA8EDEA), Color(0xFFFED6E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  right: width * 0.02,
                  top: height * 0.04,
                  bottom: height * 0.004,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 25,
                        color: ColorConstants.iconColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'कामाचा तपशील',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.apptitleColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      top: containerTop,
                      left: width * 0.05,
                      right: width * 0.05,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            width * 0.04,
                            height * 0.05,
                            width * 0.04,
                            height * 0.02,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- Work Details Box ---
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : hasError
                                    ? const Text("Error loading work details.")
                                    : workDetails == null
                                    ? const Text("No work details found.")
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _infoRow(
                                            "वर्क आय डी :",
                                            workDetails?["id"] ??
                                                widget.work.id,
                                            font,
                                          ),
                                          _infoRow(
                                            "कामाचे नाव :",
                                            workDetails?["work_name"] ??
                                                widget.work.workName,
                                            font,
                                          ),
                                          _infoRow(
                                            "ठेकेदाराचे नाव :",
                                            workDetails?["assigned_to"] ??
                                                widget.work.assignedTo,
                                            font,
                                          ),
                                          _infoRow(
                                            "स्टार्ट डेट :",
                                            workDetails?["start_date"] ??
                                                widget.work.startDate,
                                            font,
                                          ),
                                          _infoRow(
                                            "एंड डेट :",
                                            workDetails?["end_date"] ??
                                                widget.work.endDate,
                                            font,
                                          ),
                                        ],
                                      ),
                              ),

                              SizedBox(height: height * 0.016),

                              // --- Work ongoing? ---
                              Text(
                                "काम चालू आहे ?",
                                style: GoogleFonts.inter(
                                  fontSize: font,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: isWorkOngoing,
                                    onChanged: (v) => setState(() {
                                      isWorkOngoing = v;
                                      if (isWorkOngoing != true) {
                                        selectedType = null;
                                        workLayerData = null;
                                      }
                                    }),
                                  ),
                                  Text(
                                    "हो",
                                    style: GoogleFonts.inter(fontSize: font),
                                  ),
                                  SizedBox(width: width * 0.05),
                                  Radio<bool>(
                                    value: false,
                                    groupValue: isWorkOngoing,
                                    onChanged: (v) => setState(() {
                                      isWorkOngoing = v;
                                      selectedType = null;
                                      workLayerData = null;
                                    }),
                                  ),
                                  Text(
                                    "नाही",
                                    style: GoogleFonts.inter(fontSize: font),
                                  ),
                                ],
                              ),

                              SizedBox(height: height * 0.016),

                              // --- YES branch ---
                              if (isWorkOngoing == true) ...[
                                Text(
                                  "कामाचा प्रकार",
                                  style: GoogleFonts.inter(
                                    fontSize: font,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: height * 0.008),

                                isWorkTypeLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : DropdownButtonFormField<String>(
                                        value: selectedType,
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                        ),
                                        hint: Text(
                                          "कामाचा प्रकार निवडा",
                                          style: GoogleFonts.inter(
                                            fontSize: font,
                                          ),
                                        ),
                                        items: (workTypeData?.details ?? [])
                                            .map((e) {
                                              return DropdownMenuItem<String>(
                                                value: e.id.toString(),
                                                child: Text(
                                                  e.workType,
                                                  style: GoogleFonts.inter(
                                                    fontSize: font,
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedType = value;
                                            if (value != null) {
                                              fetchWorkLayers(value);
                                            } else {
                                              workLayerData = null;
                                            }
                                          });
                                        },
                                      ),
                                SizedBox(height: size.height * .01),

                                if (isWorkLayerLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),

                                if (!isWorkLayerLoading &&
                                    workLayerData != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          "लेयर व कामाचा प्रकार निवडा:",
                                          style: GoogleFonts.inter(
                                            fontSize: font,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      Column(
                                        children: workLayerData!.details.map((
                                          layer,
                                        ) {
                                          final isSelected =
                                              selectedWorkLayerId == layer.id;

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                            ),
                                            child: ChoiceChip(
                                              label: SizedBox(
                                                width: size.width * .4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "लेयर: ${layer.layer}",
                                                      style: GoogleFonts.inter(
                                                        fontSize: font * 0.95,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "कामाचा प्रकार: ${layer.workType}",
                                                      style: GoogleFonts.inter(
                                                        fontSize: font * 0.85,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              selected: isSelected,
                                              selectedColor:
                                                  Colors.teal.shade300,
                                              onSelected: (selected) {
                                                setState(() {
                                                  selectedWorkLayerId = selected
                                                      ? layer.id
                                                      : null;
                                                });
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                              ],

                              // --- NO branch ---
                              if (isWorkOngoing == false) ...[
                                Text(
                                  "काम सुरू न झाल्याचे कारण",
                                  style: GoogleFonts.inter(
                                    fontSize: font,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: reasonController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: "कारण",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF2F2F2),
                                  ),
                                ),
                                SizedBox(height: height * 0.016),
                                _uploadBox("कामाचा फोटो", "फोटो टाका", font),
                                _uploadBox(
                                  "कामाचा व्हिडिओ",
                                  "व्हिडिओ टाका",
                                  font,
                                ),
                              ],

                              SizedBox(height: height * 0.02),
                              Center(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      padding: EdgeInsets.symmetric(
                                        vertical: height * 0.016,
                                        horizontal: width * 0.2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      // 1. काम चालू आहे? (Yes/No)
                                      if (isWorkOngoing == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "कृपया काम चालू आहे का ते निवडा",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // 2. If YES → validate कामाचा प्रकार (dropdown)
                                      if (isWorkOngoing == true &&
                                          (selectedType == null ||
                                              selectedType!.isEmpty)) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "कृपया कामाचा प्रकार निवडा",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // 3. If YES → validate लेयर व काम प्रकार (ChoiceChip)
                                      if (isWorkOngoing == true &&
                                          (selectedWorkLayerId == null ||
                                              selectedWorkLayerId!.isEmpty)) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "कृपया लेयर व काम प्रकार निवडा",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // 4. If NO → validate कारण
                                      if (isWorkOngoing == false &&
                                          reasonController.text
                                              .trim()
                                              .isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "कृपया कारण प्रविष्ट करा",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      // ✅ All validations passed → navigate & pass API data
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SiteInspectionForm(
                                            workName: widget.work.workName,
                                            workData: {
                                              "visited_by": "123",
                                              "work_item_id": widget.work.id,
                                              // "work_item_id": widget.work.id,
                                              "work_type_id": selectedType,
                                              "is_ongoing":
                                                  isWorkOngoing == true
                                                  ? "yes"
                                                  : "no",
                                              "work_layer_id":
                                                  selectedWorkLayerId,
                                              "reason": isWorkOngoing == false
                                                  ? reasonController.text.trim()
                                                  : null,
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "पुढे जा",
                                      style: GoogleFonts.inter(
                                        fontSize: font,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, double font) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: font,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(value, style: GoogleFonts.inter(fontSize: font)),
          ),
        ],
      ),
    );
  }

  Widget _uploadBox(String title, String buttonText, double font) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: font, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Icon(Icons.upload, color: Colors.black54),
              const SizedBox(width: 8),
              Text(buttonText, style: GoogleFonts.inter(fontSize: font)),
            ],
          ),
        ),
      ],
    );
  }
}
