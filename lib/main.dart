import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/spot_store.dart';
import 'screens/shell.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const StudySpotApp());
}

class StudySpotApp extends StatefulWidget {
  const StudySpotApp({super.key});

  @override
  State<StudySpotApp> createState() => _StudySpotAppState();
}

class _StudySpotAppState extends State<StudySpotApp> {
  final SpotStore _store = SpotStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreScope(
      store: _store,
      child: MaterialApp(
        title: 'StudyNest',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const AppShell(),
      ),
    );
  }
}
