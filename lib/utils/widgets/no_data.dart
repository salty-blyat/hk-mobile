import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(CupertinoIcons.clear_circled,
            size: 40, color: Colors.black54),
        const SizedBox(height: 8),
        Text(
          'Not found'.tr,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    ));
  }
}
