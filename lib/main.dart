import 'package:ad_english_dictionary/presentations/ai_translator/bloc/translator_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'core/routes/routes.dart';
import 'core/routes/routes_name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.themeData,
        initialRoute: RoutesName.splashPage,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
