import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/model/work_response.dart';
import 'package:workqualitymonitoringsystem/model/work_type.dart';
import 'package:workqualitymonitoringsystem/model/work_layer.dart';
import 'package:workqualitymonitoringsystem/screens/Site%20Inspection/Site%20Inspection.dart';
import 'package:workqualitymonitoringsystem/screens/dashboard/dashboard_screen.dart';

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
  String? selectedType; // work_type_id
  String? selectedWorkLayerId; // work_layer_id
  Map<String, dynamic>? workDetails;
  bool isLoading = true;
  bool hasError = false;

  WorkType? workTypeData;
  bool isWorkTypeLoading = true;

  WorkLayerResponse? workLayerData;
  bool isWorkLayerLoading = false;

  // Photo & video state
  List<File> _photos = [];
  File? _video;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchWorkDetails();
    fetchWorkTypes();
  }

  // ---------------- API Calls ----------------
  Future<void> fetchWorkDetails() async {
    const url = "https://bandhkam.demosoftware.co.in/work_details";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"work_id": widget.work.id}),
      );

      if (!mounted) return;

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
      if (!mounted) return;
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
      if (!mounted) return;
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
      if (!mounted) return;
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

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          workLayerData = WorkLayerResponse.fromJson(data);
          isWorkLayerLoading = false;
          selectedWorkLayerId = null; // reset layer selection
        });
      } else {
        setState(() => isWorkLayerLoading = false);
      }
    } catch (e) {
      log("Error fetching work layers: $e");
      if (!mounted) return;
      setState(() => isWorkLayerLoading = false);
    }
  }

  // ---------------- Pickers ----------------
  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _photos = picked.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> pickVideo() async {
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _video = File(picked.path);
      });
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
                                      if (isWorkOngoing == false) {
                                        selectedType = null;
                                        selectedWorkLayerId = null;
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
                                      selectedWorkLayerId = null;
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
                                if (isWorkTypeLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if ((workTypeData?.details ?? []).isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      "कामाचा प्रकार उपलब्ध नाही",
                                      style: GoogleFonts.inter(fontSize: font),
                                    ),
                                  )
                                else
                                  DropdownButtonFormField<String>(
                                    value:
                                        selectedType, // <-- nothing selected by default
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
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
                                      style: GoogleFonts.inter(fontSize: font),
                                    ),
                                    items: (workTypeData?.details ?? [])
                                        .map(
                                          (e) => DropdownMenuItem<String>(
                                            value: e.id.toString(),
                                            child: Text(
                                              e.workType,
                                              style: GoogleFonts.inter(
                                                fontSize: font,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedType = value;
                                        selectedWorkLayerId = null;
                                        workLayerData = null;
                                      });
                                      if (value != null) fetchWorkLayers(value);
                                    },
                                  ),

                                SizedBox(height: size.height * .01),

                                if (isWorkLayerLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (workLayerData == null)
                                  const SizedBox.shrink()
                                else if ((workLayerData!.details).isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      "लेयर्स उपलब्ध नाहीत",
                                      style: GoogleFonts.inter(fontSize: font),
                                    ),
                                  )
                                else
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
                                                width: size.width * .7,
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
                                const SizedBox(height: 12),
                                _mediaPickers(font),
                              ],

                              SizedBox(height: height * 0.02),
                              // ---------------- Button ----------------
                              SizedBox(
                                width: double.infinity, // full width button
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          height * 0.016, // vertical padding
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _submitForm,
                                  child: Text(
                                    isWorkOngoing == true
                                        ? "पुढे जा" // YES selected
                                        : "जतन करा", // NO selected or not selected yet
                                    style: GoogleFonts.inter(
                                      fontSize: font,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
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

  // ---------------- Helpers ----------------
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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

  Widget _mediaPickers(double font) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'कामाचा फोटो',
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: pickImages,
          child: Container(
            width: screenWidth * .45,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.upload_file, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _photos.isNotEmpty
                      ? "${_photos.length} फोटो निवडले"
                      : "फोटो टाका",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_photos.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _photos.map((file) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: -8,
                    top: -8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _photos.remove(file);
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
        Text(
          'कामाचा व्हिडिओ',
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
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
                const Icon(Icons.upload_file, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _video != null ? "व्हिडिओ निवडला" : "व्हिडिओ टाका",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_video != null)
          Text(
            "Selected: ${_video!.path.split('/').last}",
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Colors.grey[700],
            ),
          ),
      ],
    );
  }

  void _submitForm() {
    if (isWorkOngoing == null) {
      _showSnack("कृपया काम चालू आहे का ते निवडा");
      return;
    }

    final Map<String, dynamic> formData = {
      "visited_by": "123", // TODO: dynamic
      "work_item_id": widget.work.id,
      "is_ongoing": isWorkOngoing == true ? "yes" : "no",
      "description": reasonController.text.trim(),
      "remark": reasonController.text.trim(),
    };

    if (isWorkOngoing == true) {
      // --- YES branch ---
      if (selectedType == null || selectedType!.isEmpty) {
        _showSnack("कृपया कामाचा प्रकार निवडा");
        return;
      }
      if (selectedWorkLayerId == null || selectedWorkLayerId!.isEmpty) {
        _showSnack("कृपया लेयर व काम प्रकार निवडा");
        return;
      }

      formData["work_type_id"] = selectedType;
      formData["work_layer_id"] = selectedWorkLayerId;

      // Navigate to SiteInspectionForm
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SiteInspectionForm(
            workName: widget.work.workName,
            workData: formData,
          ),
        ),
      );
    } else {
      // --- NO branch ---
      if (reasonController.text.trim().isEmpty) {
        _showSnack("कृपया कारण प्रविष्ट करा");
        return;
      }

      // **Photo & video validation**
      if (_photos.isEmpty && _video == null) {
        _showSnack("कृपया किमान एक फोटो किंवा व्हिडिओ अपलोड करा");
        return;
      }

      formData["photo"] = _photos.map((f) => f.path).toList();
      formData["video"] = _video?.path ?? "";

      // Navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("फॉर्म जतन झाला ✅"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }

    log("Form Data: $formData");
  }
}
