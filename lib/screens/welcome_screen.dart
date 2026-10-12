import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../theme.dart';
import '../widgets/common.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 280,
                  height: 290,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'See you next study session.',
                textAlign: TextAlign.center,
                style: nunito(
                  size: 16,
                  weight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
              const Spacer(),
              PrimaryButton(label: 'Continue', onPressed: store.signIn),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
