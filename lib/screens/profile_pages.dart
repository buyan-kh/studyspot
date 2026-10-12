import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../theme.dart';
import '../widgets/common.dart';

void openEditProfile(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const EditProfileScreen()),
  );
}

void openAccount(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const AccountScreen()),
  );
}

void openNotifications(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()),
  );
}

void openSettings(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
  );
}

void openFeedback(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const FeedbackScreen()),
  );
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController();
  final _school = TextEditingController();
  final _quote = TextEditingController();
  final _email = TextEditingController();
  final _role = TextEditingController();
  final _city = TextEditingController();
  final _vibe = TextEditingController();
  var _loaded = false;
  String? _nameError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    final profile = StoreScope.of(context).profile;
    _name.text = profile.name;
    _school.text = profile.schoolLine;
    _quote.text = profile.quote;
    _email.text = profile.email;
    _role.text = profile.role;
    _city.text = profile.city;
    _vibe.text = profile.vibe;
    _loaded = true;
  }

  @override
  void dispose() {
    _name.dispose();
    _school.dispose();
    _quote.dispose();
    _email.dispose();
    _role.dispose();
    _city.dispose();
    _vibe.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Name is required.');
      return;
    }
    final store = StoreScope.of(context);
    store.updateProfile(
      store.profile.copyWith(
        name: name,
        schoolLine: _school.text.trim(),
        quote: _quote.text.trim(),
        email: _email.text.trim(),
        role: _role.text.trim(),
        city: _city.text.trim(),
        vibe: _vibe.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PageHeader(title: 'Edit Profile'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const FieldLabel('Name'),
                AppTextField(
                  controller: _name,
                  hint: 'Your name',
                  error: _nameError,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                const FieldLabel('School'),
                AppTextField(
                  controller: _school,
                  hint: 'CS @ SJSU',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                const FieldLabel('Quote'),
                AppTextField(controller: _quote, hint: 'A short line about you'),
                const SizedBox(height: 12),
                const FieldLabel('Email'),
                AppTextField(
                  controller: _email,
                  hint: 'you@sjsu.edu',
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 12),
                const FieldLabel('Role'),
                AppTextField(controller: _role, hint: 'Student'),
                const SizedBox(height: 12),
                const FieldLabel('City'),
                AppTextField(controller: _city, hint: 'San Jose, CA'),
                const SizedBox(height: 12),
                const FieldLabel('Vibe'),
                AppTextField(controller: _vibe, hint: 'INFP'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: PrimaryButton(label: 'Save', onPressed: _save),
          ),
        ],
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = StoreScope.of(context).profile;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PageHeader(
            title: 'Account',
            subtitle: 'Name, email, school, and preferences',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _InfoRow(label: 'Name', value: profile.name),
                _InfoRow(label: 'Email', value: profile.email),
                _InfoRow(label: 'School', value: profile.schoolLine),
                _InfoRow(label: 'Role', value: profile.role),
                _InfoRow(label: 'City', value: profile.city),
                _InfoRow(label: 'Vibe', value: profile.vibe),
                const SizedBox(height: 16),
                SecondaryButton(
                  label: 'Edit Profile',
                  icon: Icons.edit_rounded,
                  onPressed: () => openEditProfile(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: cardDecoration(radius: 16),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: nunito(
                size: 13,
                weight: FontWeight.w700,
                color: AppColors.muted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not set' : value,
              style: nunito(size: 15, weight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final profile = store.profile;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PageHeader(
            title: 'Notifications',
            subtitle: 'Spot alerts, waitlist updates, and more',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _SwitchCard(
                  title: 'Spot alerts',
                  subtitle: 'Seat changes at places you follow',
                  value: profile.notificationsOn,
                  onChanged: (value) => store.updateProfile(
                    profile.copyWith(notificationsOn: value),
                  ),
                ),
                const SizedBox(height: 10),
                _SwitchCard(
                  title: 'Waitlist alerts',
                  subtitle: 'When a full room opens up',
                  value: profile.waitlistAlerts,
                  onChanged: (value) => store.updateProfile(
                    profile.copyWith(waitlistAlerts: value),
                  ),
                ),
                const SizedBox(height: 16),
                if (!profile.notificationsOn)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Spot alerts are off.',
                      textAlign: TextAlign.center,
                      style: nunito(weight: FontWeight.w700, color: AppColors.muted),
                    ),
                  )
                else ...[
                  _NoteCard(
                    icon: Icons.event_seat_rounded,
                    title: 'Seat update',
                    body: 'Dr. Martin Luther King Jr. Library has open seats right now.',
                  ),
                  _NoteCard(
                    icon: Icons.coffee_rounded,
                    title: 'Almost full',
                    body: 'Voyager Craft Coffee is down to 8 seats.',
                  ),
                  if (profile.waitlistAlerts)
                    _NoteCard(
                      icon: Icons.groups_rounded,
                      title: 'Waitlist',
                      body: 'Student Union Study Lounge is full. A waitlist is open.',
                    ),
                  _NoteCard(
                    icon: Icons.flag_rounded,
                    title: 'Weekly goal',
                    body:
                        'You are ${profile.goalDone} of ${profile.goalTotal} check-ins toward this week\'s goal.',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(radius: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.coral),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: nunito(size: 15, weight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: nunito(
                    size: 13,
                    weight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final profile = store.profile;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PageHeader(
            title: 'App Settings',
            subtitle: 'Theme, map preferences, and privacy',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: cardDecoration(radius: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Theme', style: nunito(size: 15, weight: FontWeight.w800)),
                            Text(
                              'Cream',
                              style: nunito(
                                size: 13,
                                weight: FontWeight.w700,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_rounded, color: AppColors.coral),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _SwitchCard(
                  title: 'Show my location',
                  subtitle: 'A dot on the campus map',
                  value: profile.showLocation,
                  onChanged: store.setShowLocation,
                ),
                const SizedBox(height: 10),
                _SwitchCard(
                  title: 'Share spots I add',
                  subtitle: 'Turn off to keep new spots private',
                  value: profile.shareSpots,
                  onChanged: (value) => store.updateProfile(
                    profile.copyWith(shareSpots: value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  const _SwitchCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: cardDecoration(radius: 18),
      child: Row(
        children: [
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
          Switch(
            value: value,
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return Colors.white;
              return AppColors.muted;
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return AppColors.coral;
              return AppColors.line;
            }),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _note = TextEditingController();
  var _sent = false;
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _send() {
    if (_note.text.trim().isEmpty) {
      setState(() => _error = 'Tell us what you think.');
      return;
    }
    setState(() {
      _sent = true;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PageHeader(
            title: 'Help & Feedback',
            subtitle: 'Tell us what you think!',
          ),
          Expanded(
            child: _sent
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Thanks for the note.',
                          style: nunito(size: 22, weight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'It helps the next student find a better seat.',
                          textAlign: TextAlign.center,
                          style: nunito(
                            weight: FontWeight.w700,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      const FieldLabel('Your note'),
                      AppTextField(
                        controller: _note,
                        hint: 'What should StudyNest do better?',
                        maxLines: 5,
                        maxLength: 400,
                        error: _error,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(label: 'Send', onPressed: _send),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
