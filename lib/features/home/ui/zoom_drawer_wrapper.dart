import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dashboard/ui/views/dashboard_view.dart';
import '../../mqtt/ui/mqtt_view.dart';

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
          setState(() => currentIndex = index);
          drawerController.close?.call();
        },
      ),
      mainScreen: _getScreen(),
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      drawerShadowsBackgroundColor: Colors.grey[300]!,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: const Color(0xFF2196F3),
    );
  }

  Widget _getScreen() {
    switch (currentIndex) {
      case 0:
        return const DashboardView();
      case 1:
        return const MqttView();
      default:
        return const DashboardView();
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
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.school, size: 35, color: Color(0xFF2196F3)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Smart Classroom',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'IoT Management',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _MenuItem(
              icon: Icons.dashboard_outlined,
              title: 'Firebase Dashboard',
              isSelected: currentIndex == 0,
              onTap: () => onMenuClick(0),
            ),
            _MenuItem(
              icon: Icons.settings_remote_outlined,
              title: 'MQTT Control',
              isSelected: currentIndex == 1,
              onTap: () => onMenuClick(1),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'v1.0.0',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ),
          ],
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
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white60,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.white60,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
    );
  }
}
