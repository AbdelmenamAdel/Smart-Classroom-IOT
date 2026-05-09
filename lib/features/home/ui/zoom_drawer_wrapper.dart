import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dashboard/ui/views/dashboard_view.dart';
import '../../mqtt/ui/mqtt_view.dart';
import '../../mqtt/ui/mqtt_simulator_view.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int currentIndex = 0;
  final drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: drawerController,
      menuScreen: MenuScreen(
        currentIndex: currentIndex,
        onMenuClick: (index) {
          if (currentIndex != index) {
            setState(() => currentIndex = index);
          }
          drawerController.close?.call();
        },
      ),
      mainScreen: _getScreen(),
      borderRadius: 40.0,
      showShadow: true,
      angle: -10.0,
      drawerShadowsBackgroundColor: Colors.white.withOpacity(0.2),
      slideWidth: MediaQuery.of(context).size.width * 0.75,
      menuBackgroundColor: const Color(0xFF2196F3),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 30,
          spreadRadius: 5,
        ),
      ],
      mainScreenTapClose: true, // Close drawer when tapping on main screen
    );
  }

  Widget _getScreen() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _getScreenFromIndex(),
    );
  }

  Widget _getScreenFromIndex() {
    switch (currentIndex) {
      case 0:
        return const DashboardView(key: ValueKey('dashboard'));
      case 1:
        return const MqttView(key: ValueKey('mqtt'));
      case 2:
        return const MqttSimulatorView(key: ValueKey('simulator'));
      default:
        return const DashboardView(key: ValueKey('dashboard'));
    }
  }
}

class MenuScreen extends StatelessWidget {
  final int currentIndex;
  final Function(int) onMenuClick;

  const MenuScreen({
    super.key,
    required this.currentIndex,
    required this.onMenuClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Smart Classroom',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Ultimate Control',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _MenuItem(
                icon: Icons.dashboard_rounded,
                title: 'Live Dashboard',
                isSelected: currentIndex == 0,
                onTap: () => onMenuClick(0),
              ),
              const SizedBox(height: 8),
              _MenuItem(
                icon: Icons.settings_remote_rounded,
                title: 'MQTT Control',
                isSelected: currentIndex == 1,
                onTap: () => onMenuClick(1),
              ),
              const SizedBox(height: 8),
              _MenuItem(
                icon: Icons.sim_card_rounded,
                title: 'MQTT Simulator',
                isSelected: currentIndex == 2,
                onTap: () => onMenuClick(2),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.white24, thickness: 1),
                    const SizedBox(height: 16),
                    Text(
                      'DEVELOPED BY',
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Abdelmoneim Adel',
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: ListTile(
          onTap: () {
            onTap();
            ZoomDrawer.of(context)?.close();
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          leading: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white54,
            size: 24,
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
        ),
      ),
    );
  }
}
