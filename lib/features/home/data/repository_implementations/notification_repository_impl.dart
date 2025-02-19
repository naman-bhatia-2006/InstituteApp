import 'package:uhl_link/features/home/domain/entities/notifications_entity.dart';
import 'package:uhl_link/features/home/domain/repositories/notification_repository.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  late mongo.Db _db;
  late mongo.DbCollection _collection;
  bool _isInitialized = false; // Track initialization state

  NotificationRepositoryImpl();

  Future<void> _initializeDB() async {
    try {
      await dotenv.load(fileName: "institute.env"); // ✅ Explicitly specify file
      print("Dotenv loaded successfully"); // ✅ Debugging

      String? dbUri = dotenv.env['DB_CONNECTION_URL'];
      if (dbUri == null || dbUri.isEmpty) {
        throw Exception("DB_CONNECTION_URL is missing or empty in .env file");
      }

      print("Connecting to MongoDB with URI: $dbUri"); // ✅ Debugging
      _db = await mongo.Db.create(dbUri);
      await _db.open();
      _collection = _db.collection('Notifications');
      _isInitialized = true; // ✅ Mark as initialized
      print("Connected to MongoDB successfully!");
    } catch (e) {
      print("MongoDB Connection Error: $e"); // ✅ Debugging
      throw Exception("Database initialization failed: $e");
    }
  }


  @override
  Future<List<NotificationEntity>> getNotifications() async {
    await _initializeDB(); // Ensure DB is initialized before accessing `_collection`
    try {
      final notifications = await _collection.find().toList();
      print("Raw MongoDB Data: $notifications"); // ✅ Debugging

      return notifications.map((json) {
        print("Notification Image Data: ${json['image']}"); // ✅ Print Image Data
        return NotificationEntity.fromJson(json);
      }).toList();
    } catch (e) {
      print("Error Fetching from MongoDB: $e"); // ✅ Debugging
      throw Exception('Failed to fetch notifications: $e');
    }
  }


  @override
  Future<void> addNotification(NotificationEntity notification) async {
    await _initializeDB(); // Ensure DB is initialized before inserting data
    try {
      final result = await _collection.insertOne(notification.toMap());
      if (result.isSuccess) {
        print("Notification added successfully: ${notification.toMap()}");
      } else {
        throw Exception("Failed to add notification");
      }
    } catch (e) {
      print("Error Adding Notification: $e"); // Debugging
      throw Exception('Failed to add notification: $e');
    }
  }
}
