import 'package:flutter/material.dart';
import 'dart:async';
import '../../../widgets/phone/otp_field.dart';
import '../../../widgets/back_button.dart';
import '../../../data/users.dart';
import '../../../data/session.dart';
import 'phone_number_changed_screen.dart';

enum _VerifyStatus { idle, verifying, error }

class EnterOtpCodeScreen extends StatefulWidget {
  const EnterOtpCodeScreen({super.key});

  @override
  State<EnterOtpCodeScreen> createState() => _EnterOtpCodeScreenState();
}

class _EnterOtpCodeScreenState extends State<EnterOtpCodeScreen> {
  static const _verifyTimeout = Duration(seconds: 10);

  _VerifyStatus _status = _VerifyStatus.idle;
  final _otpKey = GlobalKey<State>();
  Key _otpResetKey = UniqueKey();
  String _phoneNumber = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _phoneNumber =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
  }

  Future<void> _verifyOtp(String code) async {
    if (_status == _VerifyStatus.verifying) return;
    setState(() => _status = _VerifyStatus.verifying);

    bool? success;
    try {
      success = await _callVerifyApi(code).timeout(_verifyTimeout);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = _VerifyStatus.error;
        _otpResetKey = UniqueKey();
      });
      return;
    }

    if (!mounted) return;
    if (success != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PhoneNumberChangedScreen()),
      );
    } else {
      setState(() {
        _status = _VerifyStatus.error;
        _otpResetKey = UniqueKey();
      });
    }
  }

  Future<bool?> _callVerifyApi(String code) async {
    await Future.delayed(const Duration(seconds: 3));
    if (code != '111111') return null;
    final normalized = _phoneNumber.replaceAll(' ', '');
    final match = users.cast<dynamic>().firstWhere(
      (u) => (u.phoneNumber as String).replaceAll(' ', '') == normalized,
      orElse: () => null,
    );
    if (match != null) {
      AppSession.currentUser = match;
      return false; // existing user
    }
    return true; // new user
  }

  @override
  Widget build(BuildContext context) {
    final isVerifying = _status == _VerifyStatus.verifying;

    return PopScope(
      canPop: !isVerifying,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: isVerifying ? null : const AppBackButton(),
          elevation: 1,
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter the verification code',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'We have sent a verification code to your phone number.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 50),
                    OtpInputField(
                      key: _status == _VerifyStatus.error
                          ? _otpResetKey
                          : _otpKey,
                      onCompleted: _verifyOtp,
                    ),
                    const Spacer(),
                    if (_status == _VerifyStatus.error) ...[
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.warning, color: Colors.black),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Something went wrong.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'Check your phone number and resend the code to try again.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ResendTimerButton(
                      onResend: () {
                        // Resend API call owned here, same as before.
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isVerifying) const _LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AbsorbPointer(
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 4)),
        ),
      ),
    );
  }
}

class ResendTimerButton extends StatefulWidget {
  const ResendTimerButton({
    super.key,
    required this.onResend,
    this.cooldownSeconds = 30,
  });

  final VoidCallback onResend;
  final int cooldownSeconds;

  @override
  State<ResendTimerButton> createState() => _ResendTimerButtonState();
}

class _ResendTimerButtonState extends State<ResendTimerButton> {
  Timer? _timer;
  late int _secondsLeft = widget.cooldownSeconds;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _secondsLeft = widget.cooldownSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _handleTap() {
    widget.onResend();
    _startCountdown();
  }

  bool get _isCoolingDown => _secondsLeft > 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _isCoolingDown ? Colors.grey : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: _isCoolingDown ? null : _handleTap,

        child: Text(
          _isCoolingDown
              ? 'Resend code in 0:${_secondsLeft.toString().padLeft(2, '0')}'
              : 'Resend Code',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
