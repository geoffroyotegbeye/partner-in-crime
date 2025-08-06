import 'dart:io' if (dart.library.io) 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProofSubmissionWidget extends StatefulWidget {
  final XFile capturedMedia;
  final bool isVideoMode;
  final TextEditingController notesController;
  final VoidCallback onRetake;
  final VoidCallback onSubmit;

  const ProofSubmissionWidget({
    Key? key,
    required this.capturedMedia,
    required this.isVideoMode,
    required this.notesController,
    required this.onRetake,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ProofSubmissionWidget> createState() => _ProofSubmissionWidgetState();
}

class _ProofSubmissionWidgetState extends State<ProofSubmissionWidget> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _simulateUpload() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Simulate upload progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() => _uploadProgress = i / 100);
      }
    }

    setState(() => _isUploading = false);
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Media preview
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(77),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Media display
                    Center(
                      child: widget.isVideoMode
                          ? _VideoPreview(file: widget.capturedMedia)
                          : _ImagePreview(file: widget.capturedMedia),
                    ),

                    // Play button for video
                    if (widget.isVideoMode)
                      const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),

                    // Media type indicator
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(153),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isVideoMode
                                  ? Icons.videocam
                                  : Icons.photo_camera,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.isVideoMode ? 'Video' : 'Photo',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Basic editing tools
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          _EditButton(
                            onPressed: () {
                              // TODO: Implement rotate
                            },
                            icon: Icons.rotate_right,
                            tooltip: 'Rotate',
                          ),
                          const SizedBox(width: 8),
                          _EditButton(
                            onPressed: () {
                              // TODO: Implement crop
                            },
                            icon: Icons.crop,
                            tooltip: 'Crop',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Notes input and actions
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completion Notes (Optional)',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: TextField(
                      controller: widget.notesController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Add any notes about your task completion...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Upload progress
                  if (_isUploading)
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Uploading proof...',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${(_uploadProgress * 100).round()}%',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _uploadProgress,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .outline
                              .withAlpha(51),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isUploading ? null : widget.onRetake,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retake'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _isUploading ? null : _simulateUpload,
                          icon: _isUploading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check),
                          label: Text(
                              _isUploading ? 'Uploading...' : 'Submit Proof'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final XFile file;

  const _ImagePreview({required this.file});

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Image.network(
            file.path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : Image.file(
            File(file.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
  }
}

class _VideoPreview extends StatelessWidget {
  final XFile file;

  const _VideoPreview({required this.file});

  @override
  Widget build(BuildContext context) {
    // For demo purposes, show a placeholder
    // In real implementation, use video_player package
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam,
            color: Colors.white.withAlpha(179),
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Video Preview',
            style: GoogleFonts.inter(
              color: Colors.white.withAlpha(179),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            file.name,
            style: GoogleFonts.inter(
              color: Colors.white.withAlpha(128),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;

  const _EditButton({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(153),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
