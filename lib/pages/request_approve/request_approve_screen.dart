import 'package:flutter/material.dart';
import 'package:get/get.dart';
class RequestApproveScreen extends StatelessWidget {
  const RequestApproveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Approve'.tr),
      ),
      body: const Center(
        child: Text('Request Approve'),
      ),
    );
  }
}
