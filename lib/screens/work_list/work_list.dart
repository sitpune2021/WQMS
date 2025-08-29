import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workqualitymonitoringsystem/model/user_model.dart';
import 'package:workqualitymonitoringsystem/model/work_response.dart';
import 'package:workqualitymonitoringsystem/screens/visit_list/visit_list.dart';
import 'package:workqualitymonitoringsystem/screens/work_details_screen/work_detail_screen.dart';
import 'package:workqualitymonitoringsystem/widgets/custom_appbar.dart';

class WorkListId extends StatefulWidget {
  const WorkListId({super.key});

  @override
  State<WorkListId> createState() => _WorkListIdState();
}

class _WorkListIdState extends State<WorkListId> {
  UserModel? userModel;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  bool _isFocused = false;
  WorkDetails? workDetails;
  List<WorkDetails> _workList = [];
  bool _isLoading = true;
  List<WorkDetails> _filteredList = [];

  // // 🔹 Load user first, then fetch work list
  // Future<void> _loadUserAndFetchData() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   final userString = prefs.getString('userid');
  //   print("-------->${userString}");

  //   if (userString != null) {
  //     //  userModel = UserModel.fromJson(jsonDecode(userString));
  //     print("${_fetchData()}"); // ✅ only call after userModel is loaded
  //   } else {
  //     // Handle case when user is not stored
  //     log("❌ No current user found in SharedPreferences");
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    _fetchData();
    // _loadUserAndFetchData();
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('userid');
    print("user-------->$userString");
    try {
      final response = await http.post(
        Uri.parse("https://bandhkam.demosoftware.co.in/work_list"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userString}),
      );

      log("📡 Status Code: ${response.statusCode}");
      log("📡 Response: ${response.body}");
      log("📡 userid----: ${userString}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final workResponse = WorkResponse.fromJson(jsonData);

        setState(() {
          _workList = workResponse.details;
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

  void _filterList(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredList = _workList;
      } else {
        _filteredList = _workList.where((work) {
          final idMatch = work.id.toString().contains(query);
          final yojanaMatch = work.yojanaName.toLowerCase().contains(
            query.toLowerCase(),
          );
          final workNameMatch = work.workName.toLowerCase().contains(
            query.toLowerCase(),
          );

          return idMatch || yojanaMatch || workNameMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Color(0xFF002D96),
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'प्रकल्प यादी',
        // icon: Icons.arrow_back_ios_new,
        // onIconPressed: () {
        //   Navigator.pop(context);
        // },
      ),
      body: Column(
        children: [
          //SizedBox(height: height * 0.06),
          Expanded(
            child: Stack(
              children: [
                // White container
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.1,
                    left: 10,
                    right: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(width * 0.02),
                        topRight: Radius.circular(width * 0.02),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.0),
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
                                        builder: (_) => VisitListScreen(
                                          workItemId: work.id.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: height * 0.015,
                                    ),
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(
                                        width * 0.025,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "कामाची आयडी : ${work.id}",
                                          style: GoogleFonts.inter(
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "योजना : ${work.yojanaName}",
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
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),

                // Floating search bar
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: height * 0.065,
                      width: width * .94,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.03),
                      decoration: BoxDecoration(
                        color: _isFocused ? Colors.white : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.teal, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.search, color: Colors.black54),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              decoration: const InputDecoration(
                                hintText: "शोधा",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.black87,
                              ),
                              onChanged: _filterList,
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear, color: Colors.red),
                              onPressed: () {
                                _searchController.clear();
                                _filterList("");
                              },
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
    );
  }
}
