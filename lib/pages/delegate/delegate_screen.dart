import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DelegateScreen extends StatelessWidget {
  const DelegateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delegate'.tr),
      ),
      body: const Center(
        child: Text('Delegate'),
      ),
    );
  }
}
