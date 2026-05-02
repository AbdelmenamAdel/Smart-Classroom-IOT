import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_classroom/features/auther/auther_media.dart';
import '../../logic/dashboard_cubit.dart';
import '../widgets/status_card.dart';
import '../widgets/history_chart.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is DashboardLoaded) {
              final classroom = state.classroom;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Smart Classroom',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Live Dashboard',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      color: const Color(0xFF1D1D1D),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AutherMedia(),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "assets/images/Men3em.png",
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.85,
                          ),
                      delegate: SliverChildListDelegate([
                        StatusCard(
                          title: 'Temperature',
                          value: classroom.temp.toStringAsFixed(1),
                          unit: '°C',
                          icon: Icons.thermostat,
                          gradient: const [
                            Color(0xFFFF9A8B),
                            Color(0xFFFF6A88),
                          ],
                        ),
                        StatusCard(
                          title: 'Humidity',
                          value: classroom.humidity.toString(),
                          unit: '%',
                          icon: Icons.water_drop,
                          gradient: const [
                            Color(0xFF84FAB0),
                            Color(0xFF8FD3F4),
                          ],
                        ),
                        StatusCard(
                          title: 'Students',
                          value: classroom.students.toString(),
                          unit: 'Count',
                          icon: Icons.people,
                          gradient: const [
                            Color(0xFFA18CD1),
                            Color(0xFFFBC2EB),
                          ],
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.read<DashboardCubit>().toggleLight(),
                          child: StatusCard(
                            title: 'Light Status',
                            value: classroom.light ? 'ON' : 'OFF',
                            unit: '',
                            icon: classroom.light
                                ? Icons.lightbulb
                                : Icons.lightbulb_outline,
                            gradient: classroom.light
                                ? const [Color(0xFFF6D365), Color(0xFFFDA085)]
                                : const [Color(0xFFBDC3C7), Color(0xFF2C3E50)],
                            isActive: classroom.light,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        HistoryChart(
                          history: state.history,
                          title: 'Temperature Trend',
                          field: 'temp',
                          color: const Color(0xFFFF6A88),
                        ),
                        const SizedBox(height: 20),
                        HistoryChart(
                          history: state.history,
                          title: 'Humidity Trend',
                          field: 'humidity',
                          color: const Color(0xFF8FD3F4),
                        ),
                      ]),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'System Status',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'All sensors are operating normally.',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const Center(child: Text('Connecting to classroom...'));
          },
        ),
      ),
    );
  }
}
