import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/mqtt_cubit.dart';
import '../../../core/constants/constants.dart';

class MqttSimulatorView extends StatefulWidget {
  const MqttSimulatorView({super.key});

  @override
  State<MqttSimulatorView> createState() => _MqttSimulatorViewState();
}

class _MqttSimulatorViewState extends State<MqttSimulatorView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MqttCubit, MqttState>(
      builder: (context, state) {
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
              'IoT Simulator',
              style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(),
                const SizedBox(height: 32),
                _buildSimulatorControl(
                  title: 'Simulate Temperature',
                  value: state.simTemp.toStringAsFixed(1),
                  unit: '°C',
                  icon: Icons.thermostat,
                  color: Colors.orange,
                  child: Slider(
                    value: state.simTemp,
                    min: 0,
                    max: 50,
                    activeColor: Colors.orange,
                    onChanged: (val) => context.read<MqttCubit>().updateSimulatedValues(temp: val),
                    onChangeEnd: (val) => context.read<MqttCubit>().publish(AppConstants.topicTemp, val.toStringAsFixed(1)),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSimulatorControl(
                  title: 'Simulate Humidity',
                  value: state.simHumidity.toInt().toString(),
                  unit: '%',
                  icon: Icons.water_drop,
                  color: Colors.blue,
                  child: Slider(
                    value: state.simHumidity,
                    min: 0,
                    max: 100,
                    activeColor: Colors.blue,
                    onChanged: (val) => context.read<MqttCubit>().updateSimulatedValues(humidity: val),
                    onChangeEnd: (val) => context.read<MqttCubit>().publish(AppConstants.topicHumidity, val.toInt().toString()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSimulatorControl(
                  title: 'Simulate Students',
                  value: state.simStudents.toString(),
                  unit: 'Count',
                  icon: Icons.people,
                  color: Colors.purple,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (state.simStudents > 0) {
                            final newVal = state.simStudents - 1;
                            context.read<MqttCubit>().updateSimulatedValues(students: newVal);
                            context.read<MqttCubit>().publish(AppConstants.topicStudents, newVal.toString());
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline, size: 32),
                      ),
                      const SizedBox(width: 20),
                      Text('${state.simStudents}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          final newVal = state.simStudents + 1;
                          context.read<MqttCubit>().updateSimulatedValues(students: newVal);
                          context.read<MqttCubit>().publish(AppConstants.topicStudents, newVal.toString());
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 32),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF2196F3)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Use this screen to push dummy data to MQTT. The values will update on the "MQTT Control" screen.',
              style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF1565C0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatorControl({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 12),
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ],
              ),
              Text('$value $unit', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
