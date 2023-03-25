import 'package:equatable/equatable.dart';

class Tasks extends Equatable {
  final int? id;
  final String? title;
  final int? isCompleted;
  final int? isFavorites;
  final String? date;
  final String? startTime;
  final String? endTime;
  final int? color;
  final int? remind;
  final String? repeat;

  const Tasks({
    this.id,
    required this.title,
    required this.isCompleted,
    required this.isFavorites,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.remind,
    required this.repeat,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    isCompleted,
    isFavorites,
    date,
    startTime,
    endTime,
    color,
    remind,
    repeat,
  ];
}


class TaskModel extends Tasks {
  const TaskModel({
    required super.id,
    required super.title,
    required super.isCompleted,
    required super.isFavorites,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.color,
    required super.remind,
    required super.repeat,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      isFavorites: json['isFavorites'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      color: json['color'],
      remind: json['remind'],
      repeat: json['repeat'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['isCompleted'] = isCompleted;
    data['isFavorites'] = isFavorites;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['color'] = color;
    data['remind'] = remind;
    data['repeat'] = repeat;
    return data;
  }
}
