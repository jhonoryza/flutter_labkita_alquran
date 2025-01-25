import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_labkita_alquran/helper.dart';
import 'package:permission_handler/permission_handler.dart';

// Event
abstract class PermissionEvent {}

class RequestPermissionEvent extends PermissionEvent {}

class OpenAppSettingsEvent extends PermissionEvent {}

class QiblaEvent extends PermissionEvent {}

class UpdateQiblaEvent extends QiblaEvent {
  final double qiblaDegree;

  UpdateQiblaEvent(this.qiblaDegree);
}

// State
abstract class PermissionState {}

class PermissionInitialize extends PermissionState {}

class PermissionGranted extends PermissionState {}

class PermissionDenied extends PermissionState {}

class PermissionPermanentlyDenied extends PermissionState {}

class QiblaAcquired extends PermissionState {
  double qiblaDegree;

  QiblaAcquired({required this.qiblaDegree});
}

// Bloc
class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionInitialize()) {
    on<RequestPermissionEvent>(_onRequestPermission);
    on<OpenAppSettingsEvent>(_onOpenAppSettings);
    on<UpdateQiblaEvent>(
      (event, emit) {
        emit(
          QiblaAcquired(qiblaDegree: event.qiblaDegree),
        );
      },
    );
  }

  Future<void> _onOpenAppSettings(
      OpenAppSettingsEvent event, Emitter<PermissionState> emit) async {
    await openAppSettings();
  }

  Future<void> _onRequestPermission(
    RequestPermissionEvent event,
    Emitter<PermissionState> emit,
  ) async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      emit(PermissionGranted());
      double degree = await getQiblaDirection();
      emit(QiblaAcquired(qiblaDegree: degree));
    } else if (status.isDenied) {
      emit(PermissionDenied());
    } else if (status.isPermanentlyDenied) {
      emit(PermissionPermanentlyDenied());
    }
  }
}
