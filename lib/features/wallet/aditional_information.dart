import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/questionare.dart';
import 'package:happy_pay_flutter/features/wallet/questionare/last_question.dart';
import 'package:happy_pay_flutter/features/wallet/questionare/questionare_screen.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:happy_pay_flutter/widgets/get_started_modal/step_progress_bar.dart';

class AditionalInformation extends StatelessWidget {
  const AditionalInformation({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: FractionallySizedBox(
          widthFactor: 0.5,
          child: StepProgressBar(stepFills: [0.5]),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional information required',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'For regulatory reasons, we are required to ask you a few questions.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 30),
            Text(
              'It only takes a minute, and your information is kept safe and confidential.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
              ),
              onPressed: () {
                void go(int index) {
                  const lastQuestionIndex = 8;
                  if (index > lastQuestionIndex) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LastQuestion()),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuestionnaireScreen(
                        question: questionare[index],
                        onSubmit: (answer) {
                          // skip BNPL questions [2,3,4] when user answered No to [1]
                          final next = (index == 1 && answer == 'No')
                              ? 5
                              : index + 1;
                          go(next);
                        },
                      ),
                    ),
                  );
                }

                go(0);
              },

              child: Text('Continue'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
