import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/nest_header.dart';
import 'profile_pages.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final profile = store.profile;

    return Column(
      children: [
        NestHeader(
          trailing: IconButton(
            tooltip: 'Settings',
            onPressed: () => openSettings(context),
            icon: const Icon(Icons.settings_rounded, color: AppColors.navy),
          ),
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                profile.name,
                textAlign: TextAlign.center,
                style: nunito(size: 28, weight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school_rounded,
                    size: 16,
                    color: AppColors.coral,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      profile.schoolLine,
                      style: nunito(size: 14, weight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '"${profile.quote}"',
                textAlign: TextAlign.center,
                style: nunito(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => openEditProfile(context),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coral,
                    side: const BorderSide(color: AppColors.coral),
                    shape: const StadiumBorder(),
                    textStyle: nunito(
                      size: 13,
                      weight: FontWeight.w800,
                      color: AppColors.coral,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ProfileTag(icon: Icons.school_outlined, label: profile.role),
                  _ProfileTag(icon: Icons.place_outlined, label: profile.city),
                  _ProfileTag(icon: Icons.auto_awesome_rounded, label: profile.vibe),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      icon: Icons.favorite_rounded,
                      tint: const Color(0xFF5B8DEF),
                      value: '${store.savedCount}',
                      label: 'Saved Spots',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _Stat(
                      icon: Icons.add_location_alt_rounded,
                      tint: const Color(0xFF9B7BE0),
                      value: '${store.spotsAdded}',
                      label: 'Spots Added',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _Stat(
                      icon: Icons.star_rounded,
                      tint: const Color(0xFFF0A02A),
                      value: '${profile.helpfulUpdates}',
                      label: 'Helpful Updates',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _Stat(
                      icon: Icons.local_fire_department_rounded,
                      tint: AppColors.coral,
                      value: '${profile.weekStreak}',
                      label: 'Week Streak',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: cardDecoration(color: AppColors.blush, radius: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.track_changes_rounded,
                                color: AppColors.coral,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'My Goal',
                                style: nunito(size: 15, weight: FontWeight.w800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Find great study spaces and stay consistent!',
                            style: nunito(
                              size: 12,
                              weight: FontWeight.w700,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: profile.goalDone / profile.goalTotal,
                              minHeight: 8,
                              backgroundColor: Colors.white,
                              color: AppColors.coral,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${profile.goalDone} / ${profile.goalTotal} this week',
                            style: nunito(size: 12, weight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You got this!',
                          style: nunito(size: 11, weight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _MenuTile(
                icon: Icons.person_rounded,
                tint: const Color(0xFFE7F0FF),
                iconColor: const Color(0xFF5B8DEF),
                title: 'Account Information',
                subtitle: 'Name, email, school, and preferences',
                onTap: () => openAccount(context),
              ),
              const SizedBox(height: 10),
              _MenuTile(
                icon: Icons.notifications_rounded,
                tint: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF9B7BE0),
                title: 'Notifications',
                subtitle: 'Spot alerts, waitlist updates, and more',
                onTap: () => openNotifications(context),
              ),
              const SizedBox(height: 10),
              _MenuTile(
                icon: Icons.settings_rounded,
                tint: const Color(0xFFE5F8EE),
                iconColor: const Color(0xFF2EAE6A),
                title: 'App Settings',
                subtitle: 'Theme, map preferences, and privacy',
                onTap: () => openSettings(context),
              ),
              const SizedBox(height: 10),
              _MenuTile(
                icon: Icons.chat_bubble_rounded,
                tint: const Color(0xFFFFF1DE),
                iconColor: const Color(0xFFF0A02A),
                title: 'Help & Feedback',
                subtitle: 'Tell us what you think!',
                onTap: () => openFeedback(context),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton.icon(
                  onPressed: () => _confirmSignOut(context, store),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.blush,
                    foregroundColor: AppColors.coralDeep,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    'Sign Out',
                    style: nunito(
                      size: 16,
                      weight: FontWeight.w800,
                      color: AppColors.coralDeep,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Rest well. Study well.',
                    style: nunito(
                      size: 13,
                      weight: FontWeight.w800,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmSignOut(BuildContext context, SpotStore store) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign out?', style: nunito(size: 20, weight: FontWeight.w800)),
        content: Text(
          'You can come back whenever you are ready to study.',
          style: nunito(weight: FontWeight.w700, color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Stay',
              style: nunito(weight: FontWeight.w800, color: AppColors.muted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Sign Out',
              style: nunito(weight: FontWeight.w800, color: AppColors.coral),
            ),
          ),
        ],
      ),
    );
    if (leave == true) store.signOut();
  }
}

class _ProfileTag extends StatelessWidget {
  const _ProfileTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.coral),
          const SizedBox(width: 4),
          Text(label, style: nunito(size: 12, weight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.tint,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color tint;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: cardDecoration(radius: 16),
      child: Column(
        children: [
          Icon(icon, color: tint, size: 18),
          const SizedBox(height: 2),
          Text(value, style: nunito(size: 18, weight: FontWeight.w800)),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: nunito(
              size: 10,
              weight: FontWeight.w700,
              height: 1.15,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.tint,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color tint;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: cardDecoration(radius: 18),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: nunito(size: 15, weight: FontWeight.w800)),
                    Text(
                      subtitle,
                      style: nunito(
                        size: 12,
                        weight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
