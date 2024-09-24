import 'package:flutter/material.dart';

enum Job { 
  doctor(title:"Doctor", image: "assets/images/pic2.png", color: Colors.green),
  teacher(title: "Teacher", image: "assets/images/pic6.png", color: Colors.purple), 
  nurse(title: "Nurse", image: "assets/images/pic3.png", color: Colors.pink),
  police(title: "Police", image: "assets/images/pic1.png", color: Colors.blue);

  const Job({required this.title, required this.image, required this.color});
  final String title;
  final String image;
  final Color color;
 }

class Person {
  Person({required this.name, required this.age, required this.job});
  String name;
  int age;
  Job job;
}

List<Person> data = [
  Person(name: "Kong", age: 30, job: Job.doctor),
  Person(name: "Somxay", age: 25, job: Job.teacher),
];
