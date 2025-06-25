import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/constant/constant.dart';

class UnsubscribeInfoScreen extends StatelessWidget {
  const UnsubscribeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'How to Unsubscribe'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: ListView(
            children: [
              Text(
                'How to Cancel Your Subscription',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'If you wish to stop your subscription, follow the steps below:',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              Text(
                'For Android',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1. Open the Google Play Store.\n'
                '2. Tap on your profile icon in the top right.\n'
                '3. Select "Payments & subscriptions" > "Subscriptions".\n'
                '4. Find this app in the list and tap on it.\n'
                '5. Tap "Cancel subscription" and follow the instructions.',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              Text(
                'Important Notes',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- You must cancel at least 24 hours before the renewal date to avoid being charged.\n'
                '- Deleting the app does not cancel your subscription.\n'
                '- After cancelling, you will still have access to premium features until the current billing period ends.',
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
