import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class GallerySelectionWidget extends StatefulWidget {
  final bool isVideoMode;
  final Function(XFile) onMediaSelected;

  const GallerySelectionWidget({
    Key? key,
    required this.isVideoMode,
    required this.onMediaSelected,
  }) : super(key: key);

  @override
  State<GallerySelectionWidget> createState() => _GallerySelectionWidgetState();
}

class _GallerySelectionWidgetState extends State<GallerySelectionWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickMedia(ImageSource source) async {
    setState(() => _isLoading = true);

    try {
      final XFile? media;
      if (widget.isVideoMode) {
        media = await _picker.pickVideo(source: source);
      } else {
        media = await _picker.pickImage(source: source);
      }

      if (media != null) {
        widget.onMediaSelected(media);
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select media: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withAlpha(77),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            'Select ${widget.isVideoMode ? 'Video' : 'Photo'}',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 24),

          if (_isLoading)
            const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading media...'),
                SizedBox(height: 24),
              ],
            )
          else ...[
            // Gallery option
            _MediaSourceOption(
              icon: Icons.photo_library,
              title: 'Choose from Gallery',
              subtitle:
                  'Select existing ${widget.isVideoMode ? 'video' : 'photo'}',
              onTap: () => _pickMedia(ImageSource.gallery),
            ),

            const SizedBox(height: 16),

            // Camera option
            _MediaSourceOption(
              icon: widget.isVideoMode ? Icons.videocam : Icons.camera_alt,
              title: 'Take ${widget.isVideoMode ? 'Video' : 'Photo'}',
              subtitle: 'Use camera to capture new media',
              onTap: () => _pickMedia(ImageSource.camera),
            ),
          ],

          const SizedBox(height: 24),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaSourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MediaSourceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlpha(51),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
