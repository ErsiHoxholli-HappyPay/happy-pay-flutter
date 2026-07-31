import 'package:flutter/material.dart';
import 'package:happ_pay_flutter/widgets/get_started_modal/step_progress_bar.dart';

class OnboardingStepData {
  const OnboardingStepData({
    required this.eyebrow,
    required this.title,
    this.primaryLabel = 'Continue',
  });

  final String eyebrow;
  final String title;
  final String primaryLabel;
}

Future<void> showOnboardingSheet(
  BuildContext context, {
  required List<OnboardingStepData> steps,
  VoidCallback? onSkip,
  VoidCallback? onComplete,
}) {
  assert(steps.isNotEmpty, 'steps must not be empty');
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) =>
        OnboardingSheet(steps: steps, onSkip: onSkip, onComplete: onComplete),
  );
}

class OnboardingSheet extends StatefulWidget {
  const OnboardingSheet({
    super.key,
    required this.steps,
    this.onSkip,
    this.onComplete,
  });

  final List<OnboardingStepData> steps;
  final VoidCallback? onSkip;
  final VoidCallback? onComplete;

  @override
  State<OnboardingSheet> createState() => _OnboardingSheetState();
}

class _OnboardingSheetState extends State<OnboardingSheet> {
  int _currentStep = 0;

  void _handleSkip() {
    Navigator.of(context).pop();
    widget.onSkip?.call();
  }

  void _handlePrimaryPressed() {
    final isLastStep = _currentStep == widget.steps.length - 1;
    if (!isLastStep) {
      setState(() => _currentStep++);
      return;
    }
    Navigator.of(context).pop();
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepProgressBar(
              stepFills: List.generate(widget.steps.length, (i) {
                if (i < _currentStep) return 1.0;
                if (i > _currentStep) return 0.0;
                // partial fill per step: 0.3 on step 0, 0.6 on step 1, 1.0 on last
                const partials = [0.3, 0.6, 1.0];
                return partials[_currentStep.clamp(0, partials.length - 1)];
              }),
            ),
            const SizedBox(height: 24),
            Text(
              step.eyebrow,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: Text(
                step.title,
                key: ValueKey(_currentStep),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 150),
            if (_currentStep == widget.steps.length - 1)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handlePrimaryPressed,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              Row(
                children: [
                  TextButton(
                    onPressed: _handleSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      onPressed: _handlePrimaryPressed,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        step.primaryLabel,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
