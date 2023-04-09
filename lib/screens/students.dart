import 'dart:async';
import'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:http/http.dart';
import 'package:students_app/controller/student_controller.dart';
import '../models/student_model.dart';
import '../widget/textfielWidget.dart';
class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  GlobalKey<FormState>formKey=GlobalKey();
  TextEditingController nameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController addressController= TextEditingController();
  TextEditingController idController= TextEditingController();

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


  AddStudent(StudentModel model) async{
    showDialog(
        context: context,
        builder: (context){
          return Center(child: CircularProgressIndicator());
        });
    await StudentController().addStudent(model).then((Success){
      FlutterToastr.show("Student Registered Successfully", context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.center,
          backgroundColor: Colors.green);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=>StudentsPage()));
    });

  }

  UpdateStudent(StudentModel model) async{
    await StudentController().updateStudent(model). then((Success){
      FlutterToastr.show("Student Record Updated Successfully", context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.center,
          backgroundColor: Colors.green);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=> StudentsPage()
          ));
    }
    );
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      getAllStudents();
    });

    super.initState();
  }

  showForm( bool isEditedMode, StudentModel? model){
     var id;
    if (isEditedMode == true){
      id= model!.id;
      nameController.text= model.Name.toString();
      emailController.text= model.Email.toString();
      addressController.text= model.Address.toString();
    } else{
      nameController.text="";
      emailController.text="";
      addressController.text="";
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context){
       return Container(
         padding: EdgeInsets.fromLTRB(10, 10, 10,
             MediaQuery.of(context).viewInsets.bottom),
         child: Form(
           key: formKey,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Center(child: Text( isEditedMode== false? "Student Registration" : "Edit Student Record", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
              SizedBox(height: 15,),
               CustomTextField(
                 controller: nameController,
                 validator: (value){
                   if(value.toString().isEmpty){
                     return 'kindly enter the name';
                   }
                 },
                 label: "Enter name",
                 inputType: TextInputType.text,

               ),
               CustomTextField(
                 controller: emailController,
                 validator: (value){
                   if(value.toString().isEmpty){
                     return 'kindly enter the email';
                   }
                 },
                 label: "Enter  email",
                 inputType: TextInputType.emailAddress,

               ),
               CustomTextField(
                 controller: addressController,
                 validator: (value){
                   if(value.toString().isEmpty){
                     return 'kindly enter the address';
                   }
                 },
                 label: "Enter  address",
                 inputType: TextInputType.text,

               ),

               ElevatedButton(
                   style: ElevatedButton.styleFrom(fixedSize: Size(300,60),
                       elevation: 10),
                   onPressed: () {
                     if(isEditedMode ==false){
                       if (formKey.currentState!.validate()) {
                         StudentModel Mymodel = StudentModel(
                           Name: nameController.text,
                           Email: emailController.text,
                           Address: addressController.text,
                         );
                         AddStudent(Mymodel);
                         nameController.clear();
                         emailController.clear();
                         addressController.clear();
                       }
                     }
                     else if(isEditedMode ==true){

                       if (formKey.currentState!.validate()) {
                         StudentModel Mymodel = StudentModel(
                           id: id,
                           Name: nameController.text,
                           Email: emailController.text,
                           Address: addressController.text,
                         );
                         UpdateStudent(Mymodel);
                         nameController.clear();
                         emailController.clear();
                         addressController.clear();
                       }
                     }
                   },

                   child: Text(isEditedMode? "Update":"Save"))



             ],
           ),
         ),
       );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students app"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        showForm(false, null);
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
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(model.Name[0]),),
                    title: Text(model.Name),
                      subtitle: Text(model.Email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: (){
                            showForm(true, model);
                          },
                              icon: Icon(Icons.edit, color: Colors.black,)),
                          IconButton(icon: Icon(Icons.delete, color: Colors.red,),
                          onPressed: (){
                            showDialog(context: context,
                                builder: (context){
                              return AlertDialog(
                                content: Text("Are you sure you want to delete this student record?"),
                                actions: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text("cancel", style: TextStyle(color: Colors.blue),)),

                                  TextButton(onPressed: (){
                                    deleteStudent(model);
                                    Navigator.pop(context);
                                  }, child: Text("ok", style: TextStyle(color: Colors.blue)))
                                ],
                              );

                                });

                          },),
                        ],
                      ),
                    ),
                  ),
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
