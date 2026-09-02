import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/session.dart';
import 'package:happy_pay_flutter/features/settings_screens/account_details/view_account_details.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final bool _hasEmail = AppSession.hasEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text(
          'FeedBack',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help Us Improve!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Let us know what we can improve, so your experience will be even better. Please note that we can’t directly respond to given feedback here.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _hasEmail
                  ? TextFormField(
                      minLines: 2, // starting height (1 line)
                      maxLines:
                          5, // cap how far it can grow — prevents infinite expansion
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hint: Text('Type your message here.'),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'No e-mail linked.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'You need to add your e-mail account to send us feedback through the app.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ViewAccountDetails(
                                      primaryLabel: 'Delete Account',
                                      onSubmit: (data) => '',
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.black,
                                ),
                                foregroundColor: WidgetStateColor.resolveWith(
                                  (states) => Colors.white,
                                ),
                                shape: WidgetStateOutlinedBorder.resolveWith(
                                  (states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              child: Text('Go to Account Settings'),
                            ),
                          ),
                        ],
                      ),
                    ),

              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 50),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _hasEmail ? Navigator.pop(context) : null;
                    },
                    style: ButtonStyle(
                      alignment: Alignment.centerRight,

                      backgroundColor: WidgetStateColor.resolveWith(
                        (states) => _hasEmail ? Colors.black : Colors.grey,
                      ),
                      foregroundColor: WidgetStateColor.resolveWith(
                        (states) => Colors.white,
                      ),
                      shape: WidgetStateOutlinedBorder.resolveWith(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                    ),
                    child: Text('Send'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'or contact us via',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    const SizedBox(width: 10),
                    Text('Phone'),
                  ],
                ),
              ),

              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.email),
                    const SizedBox(width: 10),
                    Text('Email'),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.language),
                    const SizedBox(width: 10),
                    Text('Website'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
