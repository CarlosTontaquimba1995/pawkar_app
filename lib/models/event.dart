class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final String category;
  final bool isFeatured;
  final double? price;
  final int availableTickets;
  final String? imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.category,
    this.isFeatured = false,
    this.price,
    this.availableTickets = 0,
    this.imageUrl,
  }) : assert(id.isNotEmpty, 'Event id cannot be empty'),
       assert(title.isNotEmpty, 'Event title cannot be empty'),
       assert(description.isNotEmpty, 'Event description cannot be empty'),
       assert(location.isNotEmpty, 'Event location cannot be empty'),
       assert(category.isNotEmpty, 'Event category cannot be empty'),
       assert(availableTickets >= 0, 'Available tickets cannot be negative'),
       assert(price == null || price > 0, 'Price must be positive or null');

  // Factory method to create an Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'] as String?;
      final title = json['title'] as String?;
      final description = json['description'] as String?;
      final dateTimeStr = json['dateTime'] as String?;
      final location = json['location'] as String?;
      final category = json['category'] as String?;

      if (id == null || id.isEmpty) {
        throw ArgumentError('Event id cannot be null or empty');
      }
      if (title == null || title.isEmpty) {
        throw ArgumentError('Event title cannot be null or empty');
      }
      if (description == null || description.isEmpty) {
        throw ArgumentError('Event description cannot be null or empty');
      }
      if (dateTimeStr == null) {
        throw ArgumentError('Event dateTime cannot be null');
      }
      if (location == null || location.isEmpty) {
        throw ArgumentError('Event location cannot be null or empty');
      }
      if (category == null || category.isEmpty) {
        throw ArgumentError('Event category cannot be null or empty');
      }

      return Event(
        id: id,
        title: title,
        description: description,
        dateTime: DateTime.parse(dateTimeStr),
        location: location,
        category: category,
        isFeatured: (json['isFeatured'] as bool?) ?? false,
        price: json['price'] != null ? (json['price'] as num).toDouble() : null,
        availableTickets: (json['availableTickets'] as int?) ?? 0,
        imageUrl: (json['imageUrl'] as String?)?.isNotEmpty == true
            ? json['imageUrl'] as String
            : null,
      );
    } catch (e) {
      throw ArgumentError('Invalid Event JSON: $e');
    }
  }

  // Convert an Event to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'category': category,
      'isFeatured': isFeatured,
      'price': price,
      'availableTickets': availableTickets,
      'imageUrl': imageUrl,
    };
  }

  // Helper method to check if the event is upcoming
  bool get isUpcoming => dateTime.isAfter(DateTime.now());

  // Helper method to get formatted date
  String get formattedDate {
    return '${_getDayName(dateTime.weekday)}, ${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
  }

  // Helper method to get formatted time
  String get formattedTime {
    final hour = dateTime.hour % 12;
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }

  // Helper methods for date formatting
  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  String toString() =>
      'Event(id: $id, title: $title, category: $category, isFeatured: $isFeatured)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
