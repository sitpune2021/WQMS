import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:workqualitymonitoringsystem/model/visit_details.dart';
import 'package:workqualitymonitoringsystem/widgets/custom_appbar.dart';

class VisitDetailsScreen extends StatefulWidget {
  final String visitId;
  const VisitDetailsScreen({super.key, required this.visitId});

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> {
  bool _isLoading = true;
  VisitDetail? _visitDetail;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _fetchVisitDetail();
  }

  Future<void> _fetchVisitDetail() async {
    try {
      final response = await http.post(
        Uri.parse("https://bandhkam.demosoftware.co.in/visit_details"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"visit_id": widget.visitId}),
      );

      log("📡 Status Code: ${response.statusCode}");
      log("📡 Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final visitData = VisitDetail.fromJson(jsonData['details']);

        if (visitData.video.isNotEmpty) {
          _videoController =
              VideoPlayerController.network(
                  "https://bandhkam.demosoftware.co.in/${visitData.video}",
                )
                ..initialize().then((_) => setState(() {}))
                ..addListener(() {
                  setState(() {});
                  if (_videoController!.value.position >=
                      _videoController!.value.duration) {
                    _videoController!.seekTo(Duration.zero);
                    _videoController!.pause();
                  }
                });
        }

        setState(() {
          _visitDetail = visitData;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      log("❌ Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'भेट तपशील',
        icon: Icons.arrow_back_ios_new,
        onIconPressed: () => Navigator.pop(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _visitDetail == null
          ? const Center(child: Text("कोणतेही डेटा उपलब्ध नाही"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= Visit Info Card =================
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "भेट तपशील",
                        //   style: GoogleFonts.inter(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 18,
                        //   ),
                        // ),
                        const SizedBox(height: 12),
                        _buildLabelValue("आयडी", _visitDetail!.id),
                        _buildLabelValue(
                          "कामाची आयडी",
                          _visitDetail!.workItemId,
                        ),
                        _buildLabelValue("स्थिती", _visitDetail!.isOngoing),
                        _buildLabelValue("वर्णन", _visitDetail!.description),
                        _buildLabelValue("टिप्पणी", _visitDetail!.remark),
                        _buildLabelValue("नाव", _visitDetail!.name),
                        _buildLabelValue("तारीख", _visitDetail!.date),
                        _buildLabelValue(
                          "कामाचा प्रकार",
                          _visitDetail!.workType,
                        ),
                        _buildLabelValue(
                          "कामाची पातळी",
                          _visitDetail!.workLayer,
                        ),
                      ],
                    ),
                  ),

                  // ================= Photos Card =================
                  _visitDetail!.photos.isNotEmpty
                      ? _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "कामाचे फोटो",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: screenHeight * 0.18,
                                child: PageView.builder(
                                  itemCount: _visitDetail!.photos.length,
                                  controller: PageController(
                                    viewportFraction: 0.7,
                                  ),
                                  itemBuilder: (context, index) {
                                    final photo = _visitDetail!.photos[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          "https://bandhkam.demosoftware.co.in/$photo",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Center(
                                                child: Text(
                                                  "कोणतीही प्रतिमा उपलब्ध नाही",
                                                  style: GoogleFonts.inter(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "कोणतीही प्रतिमा उपलब्ध नाही",
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                  // ================= Video Card =================
                  _videoController != null &&
                          _videoController!.value.isInitialized
                      ? _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "कामाचा व्हिडिओ",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.25,
                                    width: screenWidth * 0.85,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _videoController!.value.isPlaying
                                            ? _videoController!.pause()
                                            : _videoController!.play();
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _videoController!.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: Column(
                                      children: [
                                        VideoProgressIndicator(
                                          _videoController!,
                                          allowScrubbing: true,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          colors: const VideoProgressColors(
                                            playedColor: Colors.blue,
                                            backgroundColor: Colors.black26,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(
                                                _videoController!
                                                    .value
                                                    .position,
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              _formatDuration(
                                                _videoController!
                                                    .value
                                                    .duration,
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "कोणताही व्हिडिओ उपलब्ध नाही",
                            style: GoogleFonts.inter(color: Colors.grey),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
