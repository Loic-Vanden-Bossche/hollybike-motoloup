
import 'dart:developer';
import 'dart:math' show Random;

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../auth/services/auth_persistence.dart';
import '../../auth/types/auth_session.dart';
import '../../event/types/event_status_state.dart';
import '../../shared/utils/dates.dart';
import '../../shared/websocket/recieve/websocket_added_to_event.dart';
import '../../shared/websocket/recieve/websocket_event_deleted.dart';
import '../../shared/websocket/recieve/websocket_event_published.dart';
import '../../shared/websocket/recieve/websocket_event_status_updated.dart';
import '../../shared/websocket/recieve/websocket_event_updated.dart';
import '../../shared/websocket/recieve/websocket_removed_from_event.dart';
import '../../shared/websocket/recieve/websocket_subscribed.dart';
import '../../shared/websocket/websocket_client.dart';
import '../../shared/websocket/websocket_message.dart';

@pragma('vm:entry-point')
class BackgroundNotificationHandler {
  static void initialize(ServiceInstance service,FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    bool initializing = true;

    final authPersistence = AuthPersistence();

    WebsocketClient? webSocket;

    Future<void> connectWebSocket(String token, String host) async {
      webSocket?.close();

      webSocket = WebsocketClient(
        session: AuthSession(
          token: token,
          host: host,
          refreshToken: '',
          deviceId: '',
        ),
      );

      await webSocket?.connect();

      webSocket?.pingInterval(10);

      webSocket?.subscribe('notification');

      webSocket?.listen((message) async {
        int? notifBackId;

        switch (message.data.type) {
          case 'subscribed':
            onSubscribed(message.data);
            break;
          case 'EventStatusUpdateNotification':
            notifBackId = await onEventStatusUpdated(
              message.data,
              flutterLocalNotificationsPlugin,
            );
            break;
          case 'AddedToEventNotification':
            notifBackId = await onAddedToEvent(
              message.data,
              flutterLocalNotificationsPlugin,
            );
            break;
          case 'RemovedFromEventNotification':
            notifBackId = await onRemovedFromEvent(
              message.data,
              flutterLocalNotificationsPlugin,
            );
            break;
          case 'DeleteEventNotification':
            notifBackId = await onEventDeleted(
              message.data,
              flutterLocalNotificationsPlugin,
            );
            break;
          case 'UpdateEventNotification':
            notifBackId = await onEventUpdated(
              message.data,
              flutterLocalNotificationsPlugin,
            );
            break;
          case 'NewEventNotification':
            notifBackId = await onEventPublished(
              message.data,
              flutterLocalNotificationsPlugin,
            );
            break;
          default:
            log(
              'Unknown message type: ${message.data.type}',
              name: 'Notifications',
            );
            break;
        }

        if (notifBackId != null) {
          webSocket?.sendReadNotification('notification', notifBackId);
        }
      });

      void retryConnection() {
        Future.delayed(const Duration(seconds: 10), () async {
          try {
            log('Retrying connection', name: 'Notifications');

            final currentSession = await authPersistence.currentSession;

            if (currentSession == null) {
              return;
            }

            connectWebSocket(currentSession.token, currentSession.host);
          } catch (e) {
            log(
              'Error: $e',
              stackTrace: StackTrace.current,
              name: 'Notifications',
            );
            retryConnection(); // Retry again if an error occurs
          }
        });
      }

      webSocket?.onDisconnect(() {
        log('Notification websocket disconnected', name: 'Notifications');

        webSocket = null;

        retryConnection();
      });
    }

    service.on('connect').listen((event) {
      if (initializing) {
        return;
      }

      final token = event?['token'] as String;
      final host = event?['host'] as String;

      connectWebSocket(token, host);
    });

    service.on('stopService').listen((event) {
      webSocket?.close();
      service.stopSelf();
    });

    final currentSession = await authPersistence.currentSession;

    if (currentSession != null) {
      connectWebSocket(currentSession.token, currentSession.host);
    }

    initializing = false;
  }

  static void onSubscribed(
      WebsocketBody event,
      ) async {
    final data = event as WebsocketSubscribed;

    if (data.subscribed) {
      log('Subscribed to notifications', name: 'Notifications');
    } else {
      log('Failed to subscribe to notifications', name: 'Notifications');
    }
  }

  static Future<int> onEventStatusUpdated(
      WebsocketBody event,
      FlutterLocalNotificationsPlugin notificationPlugin,
      ) async {
    final data = event as WebsocketEventStatusUpdated;

    log('Event status updated: ${data.name}, ${data.status}');

    const notificationDetails = AndroidNotificationDetails(
      'hollybike-event-updated-notifications',
      'Mise à jour des événements',
      channelDescription:
      'Canal de notifications de Hollybike pour le status des événements',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    final title = event.status == EventStatusState.canceled
        ? 'L\'événement ${event.name} a été annulé'
        : 'Le statut de l\'événement ${event.name} a été mis à jour';

    await notificationPlugin.show(
      Random().nextInt(100),
      event.name,
      title,
      const NotificationDetails(
        android: notificationDetails,
      ),
    );

    return data.notificationId;
  }

  static Future<int> onAddedToEvent(
      WebsocketBody event,
      FlutterLocalNotificationsPlugin notificationPlugin,
      ) async {
    final data = event as WebsocketAddedToEvent;

    log('Added to event: ${data.name}', name: 'Notifications');

    const notificationDetails = AndroidNotificationDetails(
      'hollybike-event-participation-notifications',
      'Participation aux événements',
      channelDescription:
      'Canal de notifications de Hollybike pour vos participations aux événements',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    await notificationPlugin.show(
      Random().nextInt(100),
      data.name,
      'Vous avez été ajouté à l\'événement ${data.name}',
      const NotificationDetails(
        android: notificationDetails,
      ),
    );

    return data.notificationId;
  }

  static Future<int> onRemovedFromEvent(
      WebsocketBody event,
      FlutterLocalNotificationsPlugin notificationPlugin,
      ) async {
    final data = event as WebsocketRemovedFromEvent;

    log('Removed from event: ${data.name}', name: 'Notifications');

    const notificationDetails = AndroidNotificationDetails(
      'hollybike-event-participation-notifications',
      'Participation aux événements',
      channelDescription:
      'Canal de notifications de Hollybike pour vos participations aux événements',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    await notificationPlugin.show(
      Random().nextInt(100),
      data.name,
      'Vous avez été retiré de l\'événement ${data.name}',
      const NotificationDetails(
        android: notificationDetails,
      ),
    );

    return data.notificationId;
  }

  static Future<int> onEventDeleted(
      WebsocketBody event,
      FlutterLocalNotificationsPlugin notificationPlugin,
      ) async {
    final data = event as WebsocketEventDeleted;

    log('Event deleted: ${data.name}', name: 'Notifications');

    const notificationDetails = AndroidNotificationDetails(
      'hollybike-event-deletion-notifications',
      'Suppression des événements',
      channelDescription:
      'Canal de notifications de Hollybike pour la suppression des événements',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    await notificationPlugin.show(
      Random().nextInt(100),
      data.name,
      'L\'événement ${data.name} a été supprimé',
      const NotificationDetails(
        android: notificationDetails,
      ),
    );

    return data.notificationId;
  }

  static Future<int> onEventUpdated(
      WebsocketBody event,
      FlutterLocalNotificationsPlugin notificationPlugin,
      ) async {
    final data = event as WebsocketEventUpdated;

    log('Event updated: ${data.name}', name: 'Notifications');

    const notificationDetails = AndroidNotificationDetails(
      'hollybike-event-updated-notifications',
      'Mise à jour des événements',
      channelDescription:
      'Canal de notifications de Hollybike pour les mises à jour des événements',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    await notificationPlugin.show(
      Random().nextInt(100),
      data.name,
      'L\'événement ${data.name} a été mis à jour',
      const NotificationDetails(
        android: notificationDetails,
      ),
    );

    return data.notificationId;
  }

  static Future<int> onEventPublished(
      WebsocketBody event,
      FlutterLocalNotificationsPlugin notificationPlugin,
      ) async {
    final data = event as WebsocketEventPublished;

    log('New event: ${data.name}', name: 'Notifications');

    const notificationDetails = AndroidNotificationDetails(
      'hollybike-event-creation-notifications',
      'Création des événements',
      channelDescription:
      'Canal de notifications de Hollybike pour la création des événements',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    await notificationPlugin.show(
      Random().nextInt(100),
      data.name,
      'Nouvel événement ${data.name} publié, prévu pour ${formatTimeDate(data.start.toLocal())}',
      const NotificationDetails(
        android: notificationDetails,
      ),
    );

    return data.notificationId;
  }
}