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
  });

  // Factory method to create an Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String,
      category: json['category'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
      price: json['price']?.toDouble(),
      availableTickets: json['availableTickets'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
    );
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
}
