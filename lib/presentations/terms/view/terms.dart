import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/constant/constant.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Terms and Conditions'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: ListView(
            children: [
              Text(
                'Terms and Conditions for Paid Subscription',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'By subscribing to the premium version of this app, you agree to the following terms and conditions:',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              Text(
                '1. Subscription & Billing',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- The app offers a paid subscription that unlocks premium features.\n'
                '- Payment will be charged to your account upon confirmation of purchase.\n'
                '- Subscriptions automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              Text(
                '2. Free Trial',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- New users may be eligible for a free trial, which provides access to premium features for a limited time.\n'
                '- To avoid being charged, users must cancel their subscription at least 24 hours before the end of the trial period.\n'
                '- If the subscription is not cancelled within this time, the payment will be processed automatically, and no refund will be issued.',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              Text(
                '3. Cancellation & Refunds',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- You can manage or cancel your subscription anytime through your account settings in the app store.\n'
                '- After the subscription is renewed, refunds will not be issued for the unused portion of the subscription period.',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              Text(
                '4. Changes to Pricing and Terms',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- We reserve the right to modify subscription pricing or these terms at any time.',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              Text(
                '5. User Agreement',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- By purchasing or continuing a subscription, you agree to these Terms and Conditions and our Privacy Policy.',
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
