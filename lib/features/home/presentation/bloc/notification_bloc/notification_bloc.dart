import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository})
      : super(NotificationsInitial()) {
    on<GetNotificationsEvent>(_onGetNotifications);
  }

  Future<void> _onGetNotifications(
      GetNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationsLoading());
    try {
      final notifications = await notificationRepository.getNotifications();
      print("Fetched Notifications: $notifications"); // ✅ Debugging
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      print("Error Fetching Notifications: $e"); // ✅ Debugging
      emit(NotificationsError(e.toString()));
    }
  }
}
