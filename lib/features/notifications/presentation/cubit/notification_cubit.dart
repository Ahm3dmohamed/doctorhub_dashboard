import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository) : super(const NotificationInitial());

  Future<void> loadNotifications() async {
    emit(const NotificationLoading());
    final res = await _repository.getNotifications();
    res.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(notifications: notifications)),
    );
  }

  Future<void> createNotification(NotificationEntity notif) async {
    final res = await _repository.createNotification(notif);
    res.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => loadNotifications(),
    );
  }

  Future<void> markAsRead(String id) async {
    final res = await _repository.markAsRead(id);
    res.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => loadNotifications(),
    );
  }

  Future<void> markAllAsRead() async {
    final res = await _repository.markAllAsRead();
    res.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => loadNotifications(),
    );
  }

  Future<void> deleteNotification(String id) async {
    final res = await _repository.deleteNotification(id);
    res.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => loadNotifications(),
    );
  }
}
