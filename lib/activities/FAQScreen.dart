import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Help Center",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 16.0),
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          FAQItem(
            question: 'How do I Signup?',
            answer:
            'To signing up, simply follow these steps:\n\n1. Open the app.\n2. Go to the Sign Up page.\n3. Fill the Information.\n4. And then click on the Sign up.',
          ),
          SizedBox(height: 16.0),
          FAQItem(
            question: 'Can upload my expenses?',
            answer:
            'Yes, you can upload your expenses. To upload a expense, go to the add expense section and upload the expense of your own will. Follow the prompts to complete the uploading process.',
          ),
          SizedBox(height: 16.0),
          FAQItem(
            question: 'How do I contact customer support?',
            answer:
            'If you need assistance or have any questions, you can contact our customer support team via email at abc@gmail.com. Our support team is available 24/7 to help you.',
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(widget.answer),
          ),
        ],
        onExpansionChanged: (expanded) {
          setState(() {
            _expanded = expanded;
          });
        },
      ),
    );
  }
}