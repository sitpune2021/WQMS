// lib/screens/visit_list/visit_list_screen.dart
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/model/visit_list.dart';
import 'package:workqualitymonitoringsystem/screens/visit_details/visit_details.dart';
import 'package:workqualitymonitoringsystem/widgets/custom_appbar.dart';

class VisitListScreen extends StatefulWidget {
  final String workItemId;
  const VisitListScreen({super.key, required this.workItemId});

  @override
  State<VisitListScreen> createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  bool _isFocused = false;
  List<VisitItem> _workList = [];
  List<VisitItem> _filteredList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    _searchController.addListener(_filterList);
    _fetchData();
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredList = _workList
          .where(
            (item) =>
                item.workName.toLowerCase().contains(query) ||
                item.id.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.post(
        Uri.parse("https://bandhkam.demosoftware.co.in/visit_list"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"work_item_id": widget.workItemId}),
      );

      log("📡 Status Code: ${response.statusCode}");
      log("📡 Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final visitResponse = VisitResponse.fromJson(jsonData);

        setState(() {
          _workList = visitResponse.details;
          _filteredList = _workList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      log("❌ Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );

    return Scaffold(
      appBar: CustomAppBar(title: 'पहाणी यादी'),
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   title: Text(
      //     ' कामांची यादी ',
      //     style: GoogleFonts.inter(fontSize: 18, color: Colors.white),
      //   ),
      //   backgroundColor: ColorConstants.statubarColor,
      // ),
      body: Column(
        children: [
          SizedBox(height: height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Search by work name or ID",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 0.02),
                  topRight: Radius.circular(width * 0.02),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredList.isEmpty
                    ? const Center(
                        child: Text(
                          "कोणतेही काम आढळले नाही ⚠️",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredList.length,
                        itemBuilder: (context, index) {
                          final work = _filteredList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      VisitDetailsScreen(visitId: work.id),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: height * 0.015),
                              padding: EdgeInsets.all(width * 0.03),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(
                                  width * 0.025,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "कामाची आयडी : ${work.id}",
                                    style: GoogleFonts.inter(
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "स्थिती : ${work.isOngoing.isEmpty ? 'N/A' : work.isOngoing}",
                                    style: GoogleFonts.inter(
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.008),
                                  Text(
                                    "कामाचे नाव : ${work.workName}",
                                    style: GoogleFonts.inter(
                                      fontSize: width * 0.038,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.008),
                                  Text(
                                    "अनुमानित किंमत : ₹${work.workPrice}",
                                    style: GoogleFonts.inter(
                                      fontSize: width * 0.038,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.008),
                                  Text(
                                    "तारीख : ${work.date}",
                                    style: GoogleFonts.inter(
                                      fontSize: width * 0.038,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
