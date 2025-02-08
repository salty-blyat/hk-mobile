import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:staff_view_ui/auth/verify_otp/verify_otp_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});
  final VerifyOtpController controller = Get.put(VerifyOtpController());

  @override
  Widget build(BuildContext context) {
    const length = 6;
    var borderColor = Get.theme.colorScheme.primary;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: AppTheme.borderRadius,
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verification'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please enter the verification code we send to your phone or email'
                  .tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 68,
                  child: Pinput(
                    length: length,
                    defaultPinTheme: defaultPinTheme,
                    onCompleted: (pin) {
                      controller.submit(pin);
                    },
                    focusedPinTheme: defaultPinTheme.copyWith(
                      height: 68,
                      width: 64,
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: borderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: errorColor,
                        borderRadius: AppTheme.borderRadius,
                      ),
                    ),
                    onChanged: (value) {
                      controller.error.value = '';
                    },
                  ),
                ),
                Obx(() => controller.error.value.isNotEmpty
                    ? Text(
                        controller.error.value,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.normal,
                              color: AppTheme.dangerColor,
                            ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
