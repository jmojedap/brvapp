class Day {
  final int dayId;
  final String name;
  final String startDate;

  Day({
    this.dayId,
    this.name,
    this.startDate,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      dayId: int.parse(json['id']),
      name: json['period_name'],
      startDate: json['start'],
    );
  }
}
