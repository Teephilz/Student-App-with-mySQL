import 'dart:convert';

import '../models/student_model.dart';
import 'package:http/http.dart' as http;

class StudentController{
  static const VIEW_URL="http://192.168.175.126/students_api/view.php";
  static const CREATE_URL="http://192.168.175.126/students_api/create.php";
  static const DELETE_URL="http://192.168.175.126/students_api/delete.php";
  static const UPDATE_URL="http://192.168.175.126/students_api/update.php";


  Future<List<StudentModel>> getStudents() async{
  final response = await http.get(Uri.parse(VIEW_URL));
  if(response.statusCode== 200){
   final Iterable list= json.decode(response.body);
   return list.map((e) => StudentModel.fromJson(e)).toList();
  }
  else{
    return <StudentModel>[];
  }
}
   Future<String> addStudent(StudentModel model) async{
    final response = await http.post(Uri.parse(CREATE_URL),
    body: model.toJsonAdd());
    if(response.statusCode == 200){
      return response.body;
    }
    else{
      return "Error";
    }
  }

  Future<String> updateStudent(StudentModel model) async{
    final response = await http.post(Uri.parse(UPDATE_URL),
        body: model.toJsonDelete_and_Update());
    if(response.statusCode == 200){
      return response.body;
    }
    else{
      return "Error";
    }
  }
  Future<String> deleteStudent(StudentModel model) async{
    final response = await http.post(Uri.parse(DELETE_URL),
        body: model.toJsonDelete_and_Update());
    if(response.statusCode == 200){
      return response.body;
    }
    else{
      return "Error";
    }
  }
}