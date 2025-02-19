import 'package:mongo_dart/mongo_dart.dart';

class LostFoundItem {
  final String id;
  final String from;
  final String lostOrFound;
  final String name;
  final String description;
  final List<String> images;
  final DateTime date;
  final String phoneNo;

  LostFoundItem({
    required this.id,
    required this.from,
    required this.lostOrFound,
    required this.name,
    required this.description,
    required this.images,
    required this.date,
    required this.phoneNo,
  });

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: (json['_id'] as ObjectId).oid,
      from: json['from'],
      lostOrFound: json['lostOrFound'],
      name: json['name'],
      description: json['description'],
      images: List<String>.from(json['images']),
      date: json['date'],
      phoneNo: json['phoneNo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'lostOrFound': lostOrFound,
      'name': name,
      'description': description,
      'images': images,
      'date': date,
      'phoneNo': phoneNo,
    };
  }
}
