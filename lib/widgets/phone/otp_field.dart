import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Fixed 6-digit OTP input, rendered as two groups of 3 boxes
/// separated by a dash. A single hidden TextField owns focus,
/// input, and autofill — the boxes are purely presentational.
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.autofocus = true,
  });

  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  static const int length = 6;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    setState(() {});
    widget.onChanged?.call(value);
    if (value.length == OtpInputField.length) {
      widget.onCompleted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _BoxRow(text: _controller.text, hasFocus: _focusNode.hasFocus),
          // Invisible field: owns real input, cursor, autofill, paste.
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.oneTimeCode],
              maxLength: OtpInputField.length,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(counterText: ''),
              onChanged: _handleChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxRow extends StatelessWidget {
  const _BoxRow({required this.text, required this.hasFocus});

  final String text;
  final bool hasFocus;

  static const _emptyBorder = Color(0xFFE0E0E0);

  static const _boxSize = Size(44, 52);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < OtpInputField.length; i++) ...[
            if (i == 3)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '-',
                  style: TextStyle(fontSize: 20, color: _emptyBorder),
                ),
              ),
            _digitBox(i),
            if (i != OtpInputField.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _digitBox(int index) {
    final digit = index < text.length ? text[index] : null;
    final isActive = hasFocus && index == text.length;

    return Container(
      width: _boxSize.width,
      height: _boxSize.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? const Color.fromARGB(255, 8, 8, 8) : _emptyBorder,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: digit != null
          ? Text(
              digit,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            )
          : (isActive
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 7, 8, 7),
                      shape: BoxShape.circle,
                    ),
                  )
                : null),
    );
  }
}
