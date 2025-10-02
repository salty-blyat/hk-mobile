import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkImg extends StatelessWidget {
  final String? src;
  final double height;

  const NetworkImg({
    super.key,
    this.src,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;

    if (src != null && src!.startsWith('data:image')) {
      try {
        final String base64Str = src!.split(',').last;
        bytes = base64Decode(base64Str);
      } catch (e) {
        bytes = null; // If decoding fails, fallback to icon
      }
    }
    return Stack(
      children: [
        bytes != null
            ? Image.memory(
                key: ValueKey(src),
                bytes,
                fit: BoxFit.contain,
                height: height,
                gaplessPlayback: true, // prevent image flicker
              )
            : Image.network(
                src ?? '',
                height: height,
                width: double.infinity,
                gaplessPlayback: true,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: height,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              )
      ],
    );
  }
}
