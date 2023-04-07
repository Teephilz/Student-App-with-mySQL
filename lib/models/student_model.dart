class StudentModel{
  final Name;
  final Email;
  final Address;
  final id;

  StudentModel({
    this.Name,
    this.Email,
    this.Address,
    this.id
});

  factory StudentModel.fromJson(Map<String,dynamic> json){
    return StudentModel(
      Name: json["Name"],
      Email: json["Email"],
      Address: json["Address"],
      id: json["id"]
    );
  }

  Map<String,dynamic>toJsonAdd(){
    return{
      "Name":Name,
     "Email": Email,
      "Address": Address
    };
  }

  Map<String,dynamic> toJsonDelete_and_Update(){
    return{
      "id":id,
      "Name":Name,
      "Email": Email,
      "Address": Address
    };
  }
}