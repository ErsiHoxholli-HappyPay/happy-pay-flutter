import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/phone/otp_field.dart';
import '../../widgets/back_button.dart';
import '../../api/api_client.dart' show NetworkException;
import '../../api/auth_api.dart';

enum _VerifyStatus { idle, verifying, error }

/// Route arguments for [OtpCodeScreen]. Pass both the phone number
/// and the [AuthMode] chosen in step 1/2 of the auth flow, so resend
/// knows which call to repeat.
class OtpCodeScreenArgs {
  const OtpCodeScreenArgs({required this.phone, required this.mode, this.code});

  final String phone;
  final AuthMode mode;
  final String? code;
}

class OtpCodeScreen extends StatefulWidget {
  const OtpCodeScreen({super.key});

  @override
  State<OtpCodeScreen> createState() => _OtpCodeScreenState();
}

class _OtpCodeScreenState extends State<OtpCodeScreen> {
  static const _verifyTimeout = Duration(seconds: 15);

  // Resend countdown (see docs/auth-flow-guide.md, step 3).
  static const resendDelay = 30;
  int secondsLeft = resendDelay;
  Timer? countdown;

  _VerifyStatus _status = _VerifyStatus.idle;
  final _otpKey = GlobalKey<State>();
  Key _otpResetKey = UniqueKey();
  String _phoneNumber = '';
  String? _loginCode;
  AuthMode _mode = AuthMode.login;

  // Error banner text. Defaults to the wrong-code message; resend
  // failures override it with their own wording (see _handleResend).
  String _errorTitle = 'Something went wrong.';
  String _errorSubtitle =
      'Check your phone number and resend the code to try again.';

  bool _resending = false;

  @override
  void initState() {
    super.initState();
    // A code was sent immediately before this screen opened.
    startCountdown();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is OtpCodeScreenArgs) {
      _phoneNumber = args.phone;
      _mode = args.mode;
      _loginCode = args.code;
    }
  }

  @override
  void dispose() {
    countdown?.cancel();
    super.dispose();
  }

  void startCountdown() {
    countdown?.cancel();
    setState(() => secondsLeft = resendDelay);
    countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft <= 1) {
        timer.cancel();
        setState(() => secondsLeft = 0);
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  Future<void> _handleResend() async {
    if (secondsLeft > 0 || _resending) return;
    setState(() => _resending = true);
    try {
      final response = _mode == AuthMode.login
          ? await requestLoginCode(_phoneNumber)
          : await requestRegistrationCode(_phoneNumber);
      if (!mounted) return;
      if (response.isHttpOk && response.bodyStatusCode == 200) {
        setState(() {
          _status = _VerifyStatus.idle; // clear any old error banner
          _resending = false;
        });
        startCountdown();
      } else {
        setState(() {
          _status = _VerifyStatus.error;
          _errorTitle = 'We could not send a new code.';
          _errorSubtitle = 'Please try again.';
          _resending = false;
        });
      }
    } on NetworkException {
      if (!mounted) return;
      setState(() {
        _status = _VerifyStatus.error;
        _errorTitle = 'No connection.';
        _errorSubtitle = 'Please try again.';
        _resending = false;
      });
    }
  }

  Future<void> _verifyOtp(String code) async {
    if (_status == _VerifyStatus.verifying) return;
    setState(() => _status = _VerifyStatus.verifying);

    if (_mode == AuthMode.login) {
      await _verifyLoginCode(code);
      return;
    }

    await _verifyRegistrationCode(code);
  }

  Future<void> _verifyRegistrationCode(String code) async {
    ConfirmResult result;

    try {
      result = await confirmRegistrationCode(
        _phoneNumber,
        code,
      ).timeout(_verifyTimeout);
    } on NetworkException {
      if (!mounted) return;

      setState(() {
        _status = _VerifyStatus.error;
        _errorTitle = 'No connection.';
        _errorSubtitle = 'Please try again.';
        _otpResetKey = UniqueKey();
      });
      return;
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _status = _VerifyStatus.error;
        _errorTitle = 'Something went wrong.';
        _errorSubtitle = 'Please try again.';
        _otpResetKey = UniqueKey();
      });
      return;
    }

    if (!mounted) return;

    switch (result) {
      case ConfirmResult.confirmed:
        // TODO(#45): member lookup, then signup form.
        break;

      case ConfirmResult.rejected:
        setState(() {
          _status = _VerifyStatus.error;
          _errorTitle = 'Something went wrong.';
          _errorSubtitle =
              'Check your phone number and resend the code to try again.';
          _otpResetKey = UniqueKey();
        });
        break;

      case ConfirmResult.failed:
        setState(() {
          _status = _VerifyStatus.error;
          _errorTitle = 'Something went wrong.';
          _errorSubtitle = 'Please try again.';
          _otpResetKey = UniqueKey();
        });
        break;
    }
  }

  Future<void> _verifyLoginCode(String code) async {
    ConfirmResult result;
    try {
      result = await confirmLoginCode(
        _phoneNumber,
        code,
      ).timeout(_verifyTimeout);
    } catch (_) {
      // Covers timeout, NetworkException, and any other unexpected failure.
      if (!mounted) return;
      setState(() {
        _status = _VerifyStatus.error;
        _errorTitle = 'Something went wrong.';
        _errorSubtitle = 'Please try again.';
        _otpResetKey = UniqueKey();
      });
      return;
    }

    if (!mounted) return;
    switch (result) {
      case ConfirmResult.confirmed:
        // TODO(#45): continue to the member lookup. Loader stays up until then.
        break;
      case ConfirmResult.rejected:
        setState(() {
          _status = _VerifyStatus.error;
          _errorTitle = 'Something went wrong.';
          _errorSubtitle =
              'Check your phone number and resend the code to try again.';
          _otpResetKey = UniqueKey();
        });
        break;

      case ConfirmResult.failed:
        setState(() {
          _status = _VerifyStatus.error;
          _errorTitle = 'Something went wrong.';
          _errorSubtitle = 'Please try again.';
          _otpResetKey = UniqueKey();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVerifying = _status == _VerifyStatus.verifying;
    final isCoolingDown = secondsLeft > 0;
    final resendDisabled = isCoolingDown || _resending;

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
                    if (_loginCode != null) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _loginCode,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Login code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ],
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
                            children: [
                              const Icon(Icons.warning, color: Colors.black),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _errorTitle,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      _errorSubtitle,
                                      style: const TextStyle(
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: resendDisabled
                              ? Colors.grey
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: resendDisabled
                            ? null
                            : () => _handleResend(),
                        child: Text(
                          isCoolingDown
                              ? 'Resend code in 0:${secondsLeft.toString().padLeft(2, '0')}'
                              : (_resending ? 'Sending...' : 'Resend Code'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
