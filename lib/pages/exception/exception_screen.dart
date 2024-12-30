import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExceptionScreen extends StatelessWidget {
  const ExceptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exception'.tr),
      ),
      body: const Center(
        child: Text('Exception'),
      ),
    );
  }
}
