import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_bloc.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_event.dart';
import 'package:uhl_link/features/home/presentation/bloc/notification_bloc/notification_state.dart';

class NotificationsPage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;
  const NotificationsPage({super.key, required this.isGuest, required this.user});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      if (mounted && context.read<NotificationBloc>().state is! NotificationsLoaded) {
        context.read<NotificationBloc>().add(GetNotificationsEvent());
      }
    });
  }

  List<NotificationEntity> notifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Notifications", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotificationsLoaded) {
                notifications = state.notifications;
                return ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    final notification = notifications[index];
                    return Card(
                      color: Theme.of(context).cardColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.height * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Title: ${notification.title['text'] ?? 'No Title'}",
                                style: Theme.of(context).textTheme.labelSmall),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Text("By: ${notification.by['name'] ?? 'Unknown'}",
                                style: Theme.of(context).textTheme.labelSmall),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Text("Description: ${notification.description['content'] ?? 'No Description'}",
                                style: Theme.of(context).textTheme.labelSmall),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            if (notification.image != null &&
                                notification.image is Map<String, dynamic> &&
                                notification.image?['url'] != null &&
                                (notification.image?['url'] as String).isNotEmpty)
                              Image.network(
                                notification.image!['url'],
                                height: MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                                },
                              )
                            else
                              const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                );
              } else if (state is NotificationsError) {
                return Center(
                  child: Text("Error loading notifications: ${state.message}",
                      style: Theme.of(context).textTheme.bodyMedium),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}