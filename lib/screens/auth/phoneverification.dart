import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/widgets/osler_button.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/ResentOtp.dart';
import 'package:doctro/model/otp_verify.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:flutter/material.dart';
import 'package:doctro/widgets/osler_toast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:doctro/chat/providers/auth_provider.dart';
import 'package:doctro/screens/auth/professional_registration_screen.dart';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/theme/ayureze_theme.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class PhoneVerificationScreen extends StatefulWidget {
  final OtpData? data;

  PhoneVerificationScreen({this.data});

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
//Set Height/Width Using MediaQuery
  late double width;
  late double height;

  int? id = 0;
  String? _verificationId;
  bool _isVerifying = false;

  //Set TextInputController In OTP
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  @override
  void initState() {
    id = widget.data!.id;
    super.initState();
    _triggerFirebaseOtp();
  }

  Future<void> _triggerFirebaseOtp() async {
    if (widget.data?.phoneForFirebase == null || widget.data!.phoneForFirebase!.isEmpty) return;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.data!.phoneForFirebase,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution (often for Android)
          _pinPutController.text = credential.smsCode ?? '';
          await _authenticateWithFirebase(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          OslerToast.error(context, e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          OslerToast.success(context, "OTP sent via Firebase!");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      OslerToast.error(context, "Error sending OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AyurezeTheme.canvas,
      appBar: PreferredSize(
        preferredSize: Size(width * 0.05, height * 0.05),
        child: SafeArea(
          child: Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.only(top: height * 0.025, left: width * 0.05),
              child: GestureDetector(
                child: Icon(Icons.arrow_back_ios, color: AyurezeTheme.forestDeep),
                onTap: () {
                  Navigator.pushNamed(context, 'SignIn');
                },
              )),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.1, left: width * 0.073, right: width * 0.073),
              child: Text(
                getTranslated(context, AppString.otp_verification_title)
                    .toString(),
                style: TextStyle(
                    fontSize: width * 0.09,
                    fontWeight: FontWeight.bold,
                    color: AyurezeTheme.textPrimary),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.040),
              child: Text(
                getTranslated(context, AppString.phone_enter_your_otp_code)
                    .toString(),
                style: TextStyle(fontSize: width * 0.040, color: AyurezeTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: width * 0.063,
                  right: width * 0.063,
                  top: height * 0.052),
              child: Pinput(
                // fieldsCount: 6,
                length: 6,
                autofocus: true,
                // textStyle: TextStyle(fontSize: width * 0.04, color: colorWhite),
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedPinTheme: PinTheme().copyWith(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    constraints: BoxConstraints(
                      maxHeight: 65,
                      minWidth: 50,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AyurezeTheme.forestDeep,
                      border: Border.all(
                        color: tealAccent.withOpacity(.2),
                      ),
                    )),
                focusedPinTheme: PinTheme().copyWith(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: AyurezeTheme.surface,
                    border: Border.all(
                      color: tealAccent.withOpacity(.2),
                    ),
                  ),
                ),
                followingPinTheme: PinTheme().copyWith(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AyurezeTheme.surface,
                      border: Border.all(
                        color: tealAccent.withOpacity(.2),
                      ),
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: width * 0.2, right: width * 0.2, top: height * 0.040),
              child: Column(
                children: [
                  Text(
                    getTranslated(context, AppString.phone_otp_not_received)
                        .toString(),
                    style: TextStyle(fontSize: width * 0.04, color: AyurezeTheme.textSecondary),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: width * 0.02),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            resentOtpVerify();
                          },
                          child: Text(
                            getTranslated(
                                    context, AppString.phone_resend_new_code)
                                .toString(),
                            style: TextStyle(
                                color: AyurezeTheme.forestDeep,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.04),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.02),
                    child: _isVerifying
                        ? const CircularProgressIndicator(color: AyurezeTheme.forestDeep)
                        : OslerButton(
                            text: getTranslated(context, AppString.phone_verify_otp).toString(),
                            onPressed: () => _verifyEnteredOtp()
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyEnteredOtp() async {
    if (_pinPutController.text.isEmpty || _pinPutController.text.length < 6) {
      OslerToast.error(context, "Please enter a valid 6-digit OTP");
      return;
    }

    if (_verificationId == null) {
      // Fallback to backend verification if Firebase didn't send an ID (e.g. error but user wants to try)
      // Or in local testing where Firebase is disabled
      await otpVerify();
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _pinPutController.text,
      );

      await _authenticateWithFirebase(credential);
    } catch (e) {
      setState(() {
        _isVerifying = false;
      });
      OslerToast.error(context, "Invalid OTP code");
    }
  }

  Future<void> _authenticateWithFirebase(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Firebase auth succeeded, now sync with the backend
      await otpVerify();
    } catch (e) {
      setState(() {
        _isVerifying = false;
      });
      OslerToast.error(context, "Authentication failed: $e");
    }
  }

  Future<BaseModel<OtpVerify>> otpVerify() async {
    Map<String, dynamic> body = {
      "user_id": id,
      // We pass the entered OTP. If the backend still validates it, we assume they are synced or we pass a bypass token.
      "otp": _pinPutController.text,
    };
    OtpVerify response;
    try {
      response = await RestClient(await RetroApi().dioData(context))
          .otpVerifyRequest(body);
      if (response.success == true) {
        _saveUserData(response);
        
        if (response.data?.isFilled == 0) {
          // New doctor or incomplete profile: Go to Professional Registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessionalRegistrationScreen(
                personalData: {
                  'name': response.data?.name,
                  'email': response.data?.email,
                  'phone': response.data?.phone,
                  'gender': response.data?.gender,
                  'dob': response.data?.dob,
                },
              ),
            ),
          );
        } else {
          // Complete profile: Go to Dashboard
          Navigator.pushReplacementNamed(context, "loginHome");
        }

        OslerToast.success(context, response.msg!);
      } else {
        OslerToast.error(context, response.msg!);
      }
    } catch (error, stacktrace) {
      setState(() {
        _isVerifying = false;
      });
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    setState(() {
      _isVerifying = false;
    });
    return BaseModel()..data = response;
  }

  Future<BaseModel<ResentOtp>> resentOtpVerify() async {
    ResentOtp? response;
    try {
      if (widget.data?.phoneForFirebase != null && widget.data!.phoneForFirebase!.isNotEmpty) {
        await _triggerFirebaseOtp();
      } else {
        response = await RestClient(await RetroApi().dioData(context))
            .resentOtpRequest(id);
        OslerToast.success(context, response.msg!);
      }
    } catch (error, stacktrace) {
      // print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  void _saveUserData(OtpVerify response) {
    if (response.data == null) return;
    
    final data = response.data!;
    SharedPreferenceHelper.setBoolean(Preferences.is_logged_in, true);
    SharedPreferenceHelper.setString(Preferences.name, data.name ?? "");
    SharedPreferenceHelper.setString(Preferences.phone_no, data.phone ?? "");
    SharedPreferenceHelper.setString(Preferences.email, data.email ?? "");
    SharedPreferenceHelper.setString(Preferences.image, data.image ?? "");
    SharedPreferenceHelper.setString(Preferences.doctorId, data.id?.toString() ?? "");
    SharedPreferenceHelper.setInt(Preferences.is_filled, data.isFilled ?? 0);
    SharedPreferenceHelper.setInt(Preferences.subscription_status, data.subscriptionStatus ?? -1);
    
    if (data.token != null && data.token!.isNotEmpty) {
      SharedPreferenceHelper.setString(Preferences.auth_token, data.token!);
    }
    
    // Notify auth provider for chat
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.handleSignIn();
    } catch (e) {
      debugPrint("Auth Provider notification error: $e");
    }
  }
}
