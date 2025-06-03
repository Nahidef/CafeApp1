import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';

class CafeRestaurantInfo extends StatefulWidget {
  const CafeRestaurantInfo({super.key});

  @override
  State<CafeRestaurantInfo> createState() => _CafeRestaurantInfoState();
}

class _CafeRestaurantInfoState extends State<CafeRestaurantInfo> {
  late final VideoPlayerController _videoController;
  final LatLng _cafeLocation = const LatLng(37.7749, -122.4194);
  final Marker _marker = const Marker(
    markerId: MarkerId('cafe_location'),
    position: LatLng(37.7749, -122.4194),
    infoWindow: InfoWindow(title: 'Cafe Restoran'),
  );

  static final List<(String, String, String)> _staff = [
    ('resimler/calisan2.jpg', 'calisan1', 'Kafe Müdürü'),
    ('resimler/calisan3.jpg', 'calisan2', 'Şef'),
    ('resimler/calisan4.jpg', 'calisan3', 'Barista'),
    ('resimler/calisan5.jpg', 'calisan4', 'Garson'),
    ('resimler/calisan6.jpg', 'calisan5', 'Garson'),
    ('resimler/calisan7.jpg', 'calisan6', 'Kasiyer'),
  ];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('resimler/tanitim.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
    _videoController.setLooping(true);
    _videoController.setVolume(1.0);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _disableParentScroll(BuildContext context) {
    PrimaryScrollController.of(context)?.position?.hold(() {});
  }

  void _enableParentScroll(BuildContext context) {
    // Scroll tekrar etkinleşir — ekstra işlem gerekmiyor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCCF),
      body: CustomScrollView(
        slivers: [
          _buildHeaderImage(),
          _buildLocalVideoPlayer(),
          _buildStaffGrid(),
          _buildContactSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'resimler/coffebg2.png',
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
          ),
          Container(
            height: 250,
            color: Colors.black.withOpacity(0.35),
          ),
          Positioned(
            child: Text(
              'Kahvenin dünya turu \nburada başlıyor!',
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                fontSize: 38,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalVideoPlayer() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _videoController.value.isInitialized
              ? Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
              Positioned.fill(
                child: _ControlsOverlay(controller: _videoController),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(
                  _videoController,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Color(0xFF4B3423),
                  ),
                ),
              ),
            ],
          )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildStaffGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final (img, name, role) = _staff[index];
            return Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    img,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    cacheHeight: 90,
                    cacheWidth: 90,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Text(
                  role,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            );
          },
          childCount: _staff.length,
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('İletişim',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('E&M Cafe', style: TextStyle(fontSize: 16)),
            const Text('(123) 456‑7890', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Listener(
                  onPointerDown: (_) => _disableParentScroll(context),
                  onPointerUp: (_) => _enableParentScroll(context),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _cafeLocation,
                      zoom: 14.0,
                    ),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    markers: {_marker},
                    liteModeEnabled: false,
                    gestureRecognizers: {
                      Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                      ),
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (widget.controller.value.isPlaying && _showControls) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && widget.controller.value.isPlaying) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _showControls = true);
        if (widget.controller.value.isPlaying) {
          widget.controller.pause();
        } else {
          widget.controller.play();
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted && widget.controller.value.isPlaying) {
              setState(() => _showControls = false);
            }
          });
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showControls || !widget.controller.value.isPlaying
            ? Container(
          color: Colors.black26,
          child: Center(
            child: Icon(
              widget.controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 64,
              color: Colors.white,
            ),
          ),
        )
            : const SizedBox(),
      ),
    );
  }
}