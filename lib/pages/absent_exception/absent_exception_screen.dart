import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AbsentExceptionScreen extends StatelessWidget {
  const AbsentExceptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AbsentException'.tr),
      ),
      body: const Center(
        child: Text('AbsentException'),
      ),
    );
  }
}
