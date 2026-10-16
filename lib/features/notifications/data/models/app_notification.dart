import 'package:equatable/equatable.dart';

/// A promotional notification. Firebase-ready: a remote payload can be parsed
/// with [AppNotification.fromJson] then handed to the notifications provider.
class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.imageUrl,
    required this.createdAt,
    this.read = false,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String imageUrl;
  final DateTime createdAt;
  final bool read;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: '${json['id']}',
        titleEn: json['titleEn'] as String? ?? '',
        titleAr: json['titleAr'] as String? ?? '',
        bodyEn: json['bodyEn'] as String? ?? '',
        bodyAr: json['bodyAr'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
        read: json['read'] as bool? ?? false,
      );

  factory AppNotification.fromApiJson(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? '';
    final body = json['body'] as String? ?? '';
    return AppNotification(
      id: '${json['id']}',
      titleEn: title,
      titleAr: title,
      bodyEn: body,
      bodyAr: body,
      imageUrl: '',
      createdAt: DateTime.parse(json['createdDate'] as String),
    );
  }

  String title(bool isArabic) => isArabic ? titleAr : titleEn;
  String body(bool isArabic) => isArabic ? bodyAr : bodyEn;

  AppNotification copyWith({bool? read}) => AppNotification(
    id: id,
    titleEn: titleEn,
    titleAr: titleAr,
    bodyEn: bodyEn,
    bodyAr: bodyAr,
    imageUrl: imageUrl,
    createdAt: createdAt,
    read: read ?? this.read,
  );

  @override
  List<Object?> get props => [id, read];
}
