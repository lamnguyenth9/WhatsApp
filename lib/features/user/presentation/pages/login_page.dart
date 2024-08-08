import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/app_const.dart';
import 'package:flutter_application_10/features/app/home/home_page.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/credential/cubit/credential_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/pages/initial_profile_submit_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  static Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode("84");
  String _countryCode = _selectedFilteredDialogCountry.phoneCode;
  String phoneNumber = "";
  
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      builder: (context, state) {
        if (state is CredentialLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CredentialPhoneAuthSmsCodeReceive) {
          return const OtpPage();
        }
        if (state is CredentialPhoneAuthProfileInfor) {
          return InitialProfileSubmitPage(phoneNumber: phoneNumber);
        }
        if (state is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authticated) {
                return HomePage(uid: state.uid);
              }
              return _bodyWidget();
            },
          );
        }
        return _bodyWidget();
      },
      listener: (context, state) {
        if (state is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (state is CredentialFailure) {
          toast("Something went wrong");
        }
      },
    );
  }

  _bodyWidget() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Center(
                    child: Text(
                      'Verify Your Phone Number',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tabColor),
                    ),
                  ),
                  const Text(
                    "WhatsApp Clone will send you SMS message (carrier charges may apply) to verify your phone number. Enter the country code and phone number",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                    onTap: _openFilteredCountryPickerDialog,
                    title: _buildDialogItems(_selectedFilteredDialogCountry),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1.5, color: tabColor))),
                        width: 80,
                        height: 42,
                        alignment: Alignment.center,
                        child: Text(_selectedFilteredDialogCountry.phoneCode),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 1.5),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: tabColor, width: 1.5))),
                        child: TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                              hintText: "Phone number",
                              border: InputBorder.none),
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _submitVerifyPhoneNumber,
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

  void _openFilteredCountryPickerDialog() {
    showDialog(
        context: context,
        builder: (_) => Theme(
            data: Theme.of(context).copyWith(
              primaryColor: tabColor,
            ),
            child: CountryPickerDialog(
              titlePadding: const EdgeInsets.all(8.0),
              searchCursorColor: tabColor,
              searchInputDecoration: const InputDecoration(
                hintText: "Search",
              ),
              isSearchable: true,
              title: const Text("Select your phone code"),
              onValuePicked: (Country country) {
                setState(() {
                  _selectedFilteredDialogCountry = country;
                  _countryCode = country.phoneCode;
                });
              },
              itemBuilder: _buildDialogItems,
            )));
  }

  Widget _buildDialogItems(Country country) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: tabColor, width: 1.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CountryPickerUtils.getDefaultFlagImage(country),
          Text(" +${country.phoneCode}"),
          Expanded(
              child: Text(
            " ${country.name}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          const Spacer(),
          const Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }
  void _submitVerifyPhoneNumber(){
    if(_phoneController.text.isNotEmpty){
      phoneNumber="+$_countryCode${_phoneController.text}";
      print("phone Number: $phoneNumber");
      BlocProvider.of<CredentialCubit>(context).submitVerifyPhoneNumber(phoneNumber: phoneNumber);
    }else{
      toast("Enter your Phone Number");
    }
  }
}
