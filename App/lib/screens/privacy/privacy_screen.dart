import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔐 Data Privacy and AI Training',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'At Aquaware, your privacy is our top priority. The water quality data you upload through the app is used to improve our services and enhance the accuracy of our AI predictions. However, rest assured that all data utilized for AI training and analysis is fully anonymized.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'This means:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• No personal identifiers: Your personal information is never tied to the data used for AI training.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '• Anonymized data sets: The data sets we use are scrubbed of any details that could link the information back to you.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '• Non-traceable: The information used in AI models and predictions is designed to be non-traceable, ensuring complete anonymity.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'This approach allows us to continually improve our AI models, providing better predictions and analyses, while maintaining your privacy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'As our AI functionalities are further developed and tested, these advanced features, including specific water quality analysis and AI-driven predictions, will be available as premium services. Until then, you can enjoy the basic features of the Aquaware app, including data uploads and essential analyses, for free.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Text(
              '💬 Support & Community',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Join our vibrant community of aquarium enthusiasts. Share tips, ask questions, and get support directly from the Aquaware team. We\'re here to help you create the best possible environment for your aquatic life.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Just visit the Aquaware GitHub Repository for more information",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '• Documentation: Our API documentation for all types of requests.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '• Support: Open a new issue in the repository and we will look into it.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '• Discussions: Connect with other Aquaware users in the discussions tab.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'We hope you enjoy using Aquaware and look forward to helping you create the perfect environment for your aquatic life!',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
