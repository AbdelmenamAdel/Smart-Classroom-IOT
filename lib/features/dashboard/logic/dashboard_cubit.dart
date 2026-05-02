import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/classroom_model.dart';
import '../data/repositories/dashboard_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  StreamSubscription? _subscription;

  DashboardCubit(this._repository) : super(DashboardInitial());

  void startMonitoring() {
    emit(DashboardLoading());
    _subscription?.cancel();
    
    // Listen to classroom data
    _subscription = _repository.classroomStream().listen(
      (classroom) {
        final currentState = state;
        List<Map<dynamic, dynamic>> currentHistory = [];
        if (currentState is DashboardLoaded) {
          currentHistory = currentState.history;
        }
        
        emit(DashboardLoaded(classroom, history: currentHistory));
        
        // Record history (simplified: record on every change)
        _repository.recordHistory(classroom);
      },
      onError: (error) {
        emit(DashboardError(error.toString()));
      },
    );

    // Listen to history
    _repository.historyStream().listen((history) {
      final currentState = state;
      if (currentState is DashboardLoaded) {
        emit(DashboardLoaded(currentState.classroom, history: history));
      }
    });
  }

  Future<void> toggleLight() async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      final newStatus = !currentState.classroom.light;
      try {
        await _repository.updateLight(newStatus);
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
