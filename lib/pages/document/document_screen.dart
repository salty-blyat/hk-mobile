import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document'.tr),
      ),
      body: const Center(
        child: Text('Document'),
      ),
    );
  }
}
