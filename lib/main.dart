import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'features/dashboard/data/repositories/dashboard_repository.dart';
import 'features/dashboard/logic/dashboard_cubit.dart';
import 'features/home/ui/zoom_drawer_wrapper.dart';
import 'features/mqtt/logic/mqtt_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SmartClassroomApp());
}

class SmartClassroomApp extends StatelessWidget {
  const SmartClassroomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => DashboardRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DashboardCubit(context.read<DashboardRepository>())
                  ..startMonitoring(),
          ),
          BlocProvider(create: (context) => MqttCubit()..connect()),
        ],
        child: MaterialApp(
          title: 'Smart Classroom',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2196F3),
              primary: const Color(0xFF2196F3),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          home: const MainWrapper(),
        ),
      ),
    );
  }
}
