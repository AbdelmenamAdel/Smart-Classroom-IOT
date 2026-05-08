import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:equatable/equatable.dart';

class MqttState extends Equatable {
  final String students;
  final String temp;
  final String humidity;
  final String mode;
  final String light;
  final MqttConnectionState connectionState;

  const MqttState({
    this.students = "0",
    this.temp = "--",
    this.humidity = "--",
    this.mode = "AUTO",
    this.light = "OFF",
    this.connectionState = MqttConnectionState.disconnected,
  });

  MqttState copyWith({
    String? students,
    String? temp,
    String? humidity,
    String? mode,
    String? light,
    MqttConnectionState? connectionState,
  }) {
    return MqttState(
      students: students ?? this.students,
      temp: temp ?? this.temp,
      humidity: humidity ?? this.humidity,
      mode: mode ?? this.mode,
      light: light ?? this.light,
      connectionState: connectionState ?? this.connectionState,
    );
  }

  @override
  List<Object> get props => [students, temp, humidity, mode, light, connectionState];
}

class MqttCubit extends Cubit<MqttState> {
  MqttServerClient? client;

  MqttCubit() : super(const MqttState());

  Future<void> connect() async {
    client = MqttServerClient('192.168.1.5', 'flutter_client');
    client!.port = 1883;
    client!.keepAlivePeriod = 20;
    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
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
    client!.subscribe("smartclassroom/#", MqttQos.atLeastOnce);

    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final topic = c[0].topic;

      if (topic == "smartclassroom/students") {
        emit(state.copyWith(students: payload));
      } else if (topic == "smartclassroom/temp") {
        emit(state.copyWith(temp: payload));
      } else if (topic == "smartclassroom/humidity") {
        emit(state.copyWith(humidity: payload));
      } else if (topic == "smartclassroom/current_mode") {
        emit(state.copyWith(mode: payload));
      } else if (topic == "smartclassroom/light_status") {
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

  @override
  Future<void> close() {
    client?.disconnect();
    return super.close();
  }
}
