import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../logic/mqtt_cubit.dart';
import '../../dashboard/ui/widgets/status_card.dart';

class MqttView extends StatelessWidget {
  const MqttView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
        ),
        title: Text(
          'MQTT Control',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<MqttCubit, MqttState>(
            builder: (context, state) {
              final color =
                  state.connectionState == MqttConnectionState.connected
                  ? Colors.green
                  : Colors.red;
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.connectionState.name.toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MqttCubit, MqttState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Real-time Mosquitto Bridge',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.85,
                  children: [
                    StatusCard(
                      title: 'MQTT Students',
                      value: state.students,
                      unit: 'Count',
                      icon: Icons.people,
                      gradient: const [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
                    ),
                    StatusCard(
                      title: 'MQTT Temp',
                      value: state.temp,
                      unit: '°C',
                      icon: Icons.thermostat,
                      gradient: const [Color(0xFFFF9A8B), Color(0xFFFF6A88)],
                    ),
                    StatusCard(
                      title: 'MQTT Humidity',
                      value: state.humidity,
                      unit: '%',
                      icon: Icons.water_drop,
                      gradient: const [Color(0xFF84FAB0), Color(0xFF8FD3F4)],
                    ),
                    StatusCard(
                      title: 'Mode',
                      value: state.mode,
                      unit: '',
                      icon: Icons.settings_input_component,
                      gradient: const [Color(0xFF89f7fe), Color(0xFF66a6ff)],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildControlSection(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlSection(BuildContext context, MqttState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Control Center',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          _buildControlButton(
            title: 'Operation Mode',
            currentValue: state.mode,
            options: ['AUTO', 'MANUAL'],
            onChanged: (val) =>
                context.read<MqttCubit>().publish('smartclassroom/mode', val),
          ),
          const Divider(height: 32),
          _buildControlButton(
            title: 'Lighting System',
            currentValue: state.light,
            options: ['ON', 'OFF'],
            onChanged: (val) =>
                context.read<MqttCubit>().publish('smartclassroom/light', val),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String title,
    required String currentValue,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((opt) {
            final isSelected = currentValue == opt;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () => onChanged(opt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? const Color(0xFF2196F3)
                        : Colors.grey[100],
                    foregroundColor: isSelected ? Colors.white : Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    opt,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
