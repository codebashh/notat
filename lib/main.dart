import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/configs/core_theme.dart' as theme;
import 'package:noteapp/cubits/camera_cubit/cubit.dart';
import 'package:noteapp/cubits/local_database_cubit/cubit.dart';
import 'package:noteapp/cubits/note_page_cubit/cubit.dart';
import 'package:flutter/services.dart';
import 'package:noteapp/cubits/notebook_cubit/cubit.dart';
import 'package:noteapp/cubits/notes_cubit/cubit.dart';
import 'package:noteapp/cubits/phone_auth/cubit.dart';
import 'package:noteapp/cubits/sections_cubit/cubit.dart';
import 'package:noteapp/screens/camera_screen/camera.dart';
import 'package:noteapp/screens/camera_screen/image_captured.dart';
import 'package:noteapp/screens/camera_screen/video_captured.dart';
import 'package:noteapp/screens/note_detail/note_detail.dart';
import 'package:noteapp/screens/notes/notes.dart';
import 'package:noteapp/screens/phone_auth/phone_authentication.dart';
import 'package:noteapp/screens/section_search_page/section_search_page.dart';
import 'package:noteapp/screens/sections/sections.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/screens/splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp/providers/app_provider.dart';
import 'package:noteapp/screens/drawer_screen/drawer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  debugPrint("${cameras.length} cameras found");
  await EasyLocalization.ensureInitialized();

  // hive
  await Hive.initFlutter();

  await Hive.openBox('app');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
      ],
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => NotepageCubit()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        BlocProvider(create: (context) => LocalDatabaseCubit()),
        BlocProvider(create: (context) => CameraCubit()..initCamera()),
        BlocProvider(create: (context) => NotebookCubit()),
        BlocProvider(create: (context) => SectionsCubit()),
        BlocProvider(create: (context) => NotesCubit()),
        BlocProvider(create: (context) => PhoneAuthCubit()),
      ],
      child: Consumer<AppProvider>(
        builder: ((context, value, child) => MaterialChild(provider: value)),
      ),
    );
  }
}

class MaterialChild extends StatelessWidget {
  final AppProvider provider;
  const MaterialChild({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: theme.themeLight,
      darkTheme: theme.themeDark,
      themeMode: provider.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/splash',
      routes: {
        '/camera': (context) => const Camera(),
        '/home': (context) => const DrawerScreen(),
        '/notes': (context) => const NotesScreen(),
        '/splash': (context) => const SplashScreen(),
        '/sections': (context) => const SectionsScreen(),
        '/noteDetail': (context) => const NoteDetailScreen(),
        '/imageCaptured': (context) => const ImageCaptured(),
        '/videoCaptured': (context) => const VideoCaptured(),
        '/sectionSearchPage': (context) => const SectionSearchPage(),
        '/phoneAuthPage': (context) => const PhoneAuthentication(),
      },
    );
  }
}
