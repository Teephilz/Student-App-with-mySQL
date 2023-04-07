import 'dart:async';

import'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:http/http.dart';
import 'package:students_app/controller/student_controller.dart';
import 'package:students_app/screens/add_page.dart';

import '../models/student_model.dart';
class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {

  List<StudentModel> studentsList=[];
  StreamController _streamController=StreamController();

  Future getAllStudents() async{
    studentsList= await StudentController().getStudents();
    _streamController.add(studentsList);
  }

  deleteStudent(StudentModel model) async{
    await StudentController().deleteStudent(model).then((Success)=>{
      FlutterToastr.show("Student Deleted Successfully", context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.center,
          backgroundColor: Colors.green)
    }).onError((error, stackTrace)=>{
      FlutterToastr.show("Error ocurred", context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.center,
          backgroundColor: Colors.red)}
    );
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      getAllStudents();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students app"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPage()));
      },),
      body: SafeArea(
        child:
        StreamBuilder(
          stream: _streamController.stream,
          builder: (context,snapshots){
            if(snapshots.hasData){
              return ListView.builder(
                itemCount: studentsList.length,
                  itemBuilder: (context, index){
                StudentModel model= studentsList[index];
                return ListTile(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                    AddPage(
                      model: model,
                      index: index,
                    )));
                  },
                  leading: CircleAvatar(child: Text(model.Name[0]),),
                title: Text(model.Name),
                  subtitle: Text(model.Email),
                  trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: (){
                    deleteStudent(model);
                  },),
                );
              });
            }
            return Center(child: CircularProgressIndicator(),);

          },
        ),
      ),
    );
  }
}
