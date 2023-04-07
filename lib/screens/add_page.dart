import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:students_app/controller/student_controller.dart';
import 'package:students_app/models/student_model.dart';
import 'package:students_app/screens/students.dart';
import 'package:students_app/widget/textfielWidget.dart';
class AddPage extends StatefulWidget {
  final StudentModel? model;
  final index;
  AddPage({this.model, this.index});
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool isEditedMode= false;
  GlobalKey<FormState>formKey=GlobalKey();
  TextEditingController nameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController addressController= TextEditingController();
  TextEditingController idController= TextEditingController();

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
    await StudentController().updateStudent(model). then((Success)=> {
      FlutterToastr.show("Student Record Updated Successfully", context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.center,
          backgroundColor: Colors.green),
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=> StudentsPage()
      )).onError((error, stackTrace) =>{
        FlutterToastr.show("Student Record Update failed", context,
            duration: FlutterToastr.lengthLong,
            position: FlutterToastr.center,
            backgroundColor: Colors.red),
      })
    }
    );
  }


  @override
  void initState() {
   if(widget.index !=null){
     isEditedMode=true;
     nameController.text= widget.model?.Name;
     emailController.text= widget.model?.Email;
     addressController.text= widget.model?.Address;
     idController.text= widget.model?.id;
   }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text( isEditedMode? "Update Student":"Add Student"),
      centerTitle: true,),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(child: Text("Student Registration", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
            CustomTextField(
              controller: nameController,
              validator: (value){
                if(value.toString().isEmpty){
                  return 'kindly enter your name';
                }
              },
              label: "Enter your name",
              inputType: TextInputType.text,

            ),
            CustomTextField(
              controller: emailController,
              validator: (value){
                if(value.toString().isEmpty){
                  return 'kindly enter your email';
                }
              },
              label: "Enter your email",
              inputType: TextInputType.emailAddress,

            ),
            CustomTextField(
              controller: addressController,
              validator: (value){
                if(value.toString().isEmpty){
                  return 'kindly enter your address';
                }
              },
              label: "Enter your address",
              inputType: TextInputType.text,

            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(300,60),
              elevation: 10),
                onPressed: () {
                if(isEditedMode ==false){
                  if (formKey.currentState!.validate()) {
                    StudentModel model = StudentModel(
                      Name: nameController.text,
                      Email: emailController.text,
                      Address: addressController.text,
                    );
                    AddStudent(model);
                    nameController.clear();
                    emailController.clear();
                    addressController.clear();
                  }
                }
                else if(isEditedMode ==true){

                  if (formKey.currentState!.validate()) {
                    StudentModel model = StudentModel(
                      Name: nameController.text,
                      Email: emailController.text,
                      Address: addressController.text,
                    );
                    UpdateStudent(model);
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
  }
}
