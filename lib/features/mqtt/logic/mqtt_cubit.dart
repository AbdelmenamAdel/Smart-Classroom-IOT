import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/constants.dart';

class MqttState extends Equatable {
  final String students;
  final String temp;
  final String humidity;
  final String mode;
  final String light;
  final MqttConnectionState connectionState;
  // Simulated values for persistence
  final double simTemp;
  final double simHumidity;
  final int simStudents;

  const MqttState({
    this.students = "0",
    this.temp = "--",
    this.humidity = "--",
    this.mode = "AUTO",
    this.light = "OFF",
    this.connectionState = MqttConnectionState.disconnected,
    this.simTemp = 25.0,
    this.simHumidity = 50.0,
    this.simStudents = 0,
  });

  MqttState copyWith({
    String? students,
    String? temp,
    String? humidity,
    String? mode,
    String? light,
    MqttConnectionState? connectionState,
    double? simTemp,
    double? simHumidity,
    int? simStudents,
  }) {
    return MqttState(
      students: students ?? this.students,
      temp: temp ?? this.temp,
      humidity: humidity ?? this.humidity,
      mode: mode ?? this.mode,
      light: light ?? this.light,
      connectionState: connectionState ?? this.connectionState,
      simTemp: simTemp ?? this.simTemp,
      simHumidity: simHumidity ?? this.simHumidity,
      simStudents: simStudents ?? this.simStudents,
    );
  }

  @override
  List<Object> get props => [
        students,
        temp,
        humidity,
        mode,
        light,
        connectionState,
        simTemp,
        simHumidity,
        simStudents,
      ];
}

class MqttCubit extends Cubit<MqttState> {
  MqttServerClient? client;

  MqttCubit() : super(const MqttState());

  Future<void> connect() async {
    client = MqttServerClient(AppConstants.mqttBrokerIp, AppConstants.mqttClientId);
    client!.port = AppConstants.mqttPort;
    client!.keepAlivePeriod = 20;
    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(AppConstants.mqttClientId)
        .startClean();
    client!.connectionMessage = connMessage;

    try {
      emit(state.copyWith(connectionState: MqttConnectionState.connecting));
      await client!.connect();
    } catch (e) {
      emit(state.copyWith(connectionState: MqttConnectionState.faulted));
      client!.disconnect();
    }
  }

  void _onConnected() {
    emit(state.copyWith(connectionState: MqttConnectionState.connected));
    client!.subscribe(AppConstants.topicFilter, MqttQos.atLeastOnce);

    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final topic = c[0].topic;

      if (topic == AppConstants.topicStudents) {
        emit(state.copyWith(students: payload));
      } else if (topic == AppConstants.topicTemp) {
        emit(state.copyWith(temp: payload));
      } else if (topic == AppConstants.topicHumidity) {
        emit(state.copyWith(humidity: payload));
      } else if (topic == AppConstants.topicCurrentMode) {
        emit(state.copyWith(mode: payload));
      } else if (topic == AppConstants.topicLightStatus) {
        emit(state.copyWith(light: payload));
      }
    });
  }

  void _onDisconnected() {
    emit(state.copyWith(connectionState: MqttConnectionState.disconnected));
  }

  void publish(String topic, String message) {
    if (client?.connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void updateSimulatedValues({double? temp, double? humidity, int? students}) {
    emit(state.copyWith(
      simTemp: temp,
      simHumidity: humidity,
      simStudents: students,
    ));
  }

  @override
  Future<void> close() {
    client?.disconnect();
    return super.close();
  }
}
