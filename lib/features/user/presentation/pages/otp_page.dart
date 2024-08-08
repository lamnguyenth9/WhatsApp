import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/credential/cubit/credential_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

import 'initial_profile_submit_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  
  
   @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 0,
                  ),
                  const Center(
                    child: Text(
                      "Verify Your Otp",
                      style: TextStyle(
                          color: tabColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Enter your OTP for the WhatsApp Clone Verification (so that you will be moved for the further steps to complete)",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _pinCodeWidget(),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: _submitSmsCode ,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 20),
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _pinCodeWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          PinCodeFields(
              controller: _otpController,
              length: 6,
              activeBorderColor: tabColor,
              onComplete: (String pinCode) {}),
          const Text("Enter your 6 digit code ")
        ],
      ),
    );
  }
  void _submitSmsCode(){
    print("Sms Code: ${_otpController.text}");
    if(_otpController.text.isNotEmpty){
      BlocProvider.of<CredentialCubit>(context).submitSmsCode(smsPinCode: _otpController.text);
    }
  }
}
