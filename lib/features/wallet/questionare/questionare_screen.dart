import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:happy_pay_flutter/widgets/get_started_modal/step_progress_bar.dart';
import 'package:happy_pay_flutter/models/questionare.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key, required this.question, this.onSubmit});

  final Questionare question;
  final ValueChanged<String>? onSubmit;

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StepProgressBar(stepFills: [0.5]),
        titleSpacing: 100,
        centerTitle: true,
        elevation: 1,
        leading: const AppBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...widget.question.answer.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _OptionTile(
                  label: option,
                  selected: option == _selected,
                  onTap: () {
                    setState(() => _selected = option);
                    onSubmit(option);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit(String answer) {
    widget.onSubmit?.call(answer);
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: selected ? Colors.grey.shade100 : Colors.white,
          border: Border.all(
            color: selected ? Colors.grey.shade400 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
            selected
                ? Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                : Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
