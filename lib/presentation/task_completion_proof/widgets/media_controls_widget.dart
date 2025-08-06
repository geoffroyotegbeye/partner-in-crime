import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MediaControlsWidget extends StatelessWidget {
  final bool isVideoMode;
  final bool isRecording;
  final bool isFlashOn;
  final VoidCallback onModeToggle;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;
  final VoidCallback onGallery;

  const MediaControlsWidget({
    Key? key,
    required this.isVideoMode,
    required this.isRecording,
    required this.isFlashOn,
    required this.onModeToggle,
    required this.onFlashToggle,
    required this.onCapture,
    required this.onGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withAlpha(179),
            Colors.black.withAlpha(230),
          ],
        ),
      ),
      child: Column(
        children: [
          // Top controls row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flash control (hidden on web)
                kIsWeb
                    ? const SizedBox(width: 48)
                    : _ControlButton(
                        onPressed: onFlashToggle,
                        icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                        label: 'Flash',
                        isActive: isFlashOn,
                      ),

                // Mode toggle
                _ControlButton(
                  onPressed: onModeToggle,
                  icon: isVideoMode ? Icons.videocam : Icons.camera_alt,
                  label: isVideoMode ? 'Video' : 'Photo',
                  isActive: true,
                ),

                // Gallery button
                _ControlButton(
                  onPressed: onGallery,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  isActive: false,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Capture button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: onCapture,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: isVideoMode && isRecording
                      ? Colors.red
                      : Theme.of(context).colorScheme.tertiary,
                ),
                child: isVideoMode && isRecording
                    ? const Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 32,
                      )
                    : Icon(
                        isVideoMode ? Icons.videocam : Icons.camera_alt,
                        color: Colors.white,
                        size: 32,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isActive;

  const _ControlButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withAlpha(51)
              : Colors.black.withAlpha(77),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
