import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OvertimeScreen extends StatelessWidget {
  const OvertimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overtime'.tr),
      ),
      body: const Center(
        child: Text('Overtime'),
      ),
    );
  }
}
