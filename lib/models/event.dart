class Event {
  final int id;
  final String name;
  final String description;
  final String date;
  final String location;
  final String? image;
  final String? timeStart;
  final String? timeEnd;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    this.image,
    this.timeStart,
    this.timeEnd,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: json['date'],
      location: json['location'],
      image: json['image'],
      timeStart: json['time_start'],
      timeEnd: json['time_end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date,
      'location': location,
      'image': image,
      'time_start': timeStart,
      'time_end': timeEnd,
    };
  }
}
