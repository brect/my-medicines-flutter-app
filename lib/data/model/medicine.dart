class Medicine {
  final int? id;
  final String name;
  final String description;
  final String photoMedicine;
  final String startDate;
  final String startTime;

  Medicine({
    this.id,
    required this.name,
    required this.description,
    required this.photoMedicine,
    required this.startDate,
    required this.startTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photoMedicine': photoMedicine,
      'startDate': startDate,
      'startTime': startTime,
    };
  }
}