class Student{
  int ?id;
 late String name,phone;
  Student({this.id, required this.name, required this.phone});
  Map<String,dynamic> tomap(){
    return {
      "name":name,
      "phone":phone
    };
  }
}