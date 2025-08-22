import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkImg extends StatelessWidget {
  final String? src;
  final double height;
  final String? badge;

  const NetworkImg({
    super.key,
    this.src,
    required this.height,
    this.badge,
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
                bytes,
                fit: BoxFit.contain,
                height: height,
              )
            : Image.network(
                src ?? '',
                height: height,
                width: double.infinity,
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
                      // borderRadius: const BorderRadius.only(
                      //     topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),

        // only show badge if it's non-null and non-empty
        if (badge != null && badge!.isNotEmpty)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
