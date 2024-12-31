import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqloctober/student.dart';

import 'main.dart';
import 'mydbhelper.dart';

class Editstudent extends StatefulWidget {
  Student student;
   Editstudent({super.key, required this.student});

  @override
  State<Editstudent> createState() => _EditstudentState();
}

class _EditstudentState extends State<Editstudent> {

  TextEditingController namecontroller=TextEditingController();
  TextEditingController phonecontroller=TextEditingController();
  final formkey=GlobalKey<FormState>();
  MyDbHelper myDbHelper=MyDbHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroller.text=widget.student.name;
    phonecontroller.text=widget.student.phone;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
title: Text("edit"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      ),
      body: Center(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: (value){
                  return value!.length>=2?null:"Enter valid name";
                },
                controller: namecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "name",
                    labelText: "name"
                ),
              ),
              TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                validator: (value){
                  return value!.length<10?"Enter valid phone no":null;
                },
                controller: phonecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "phone",
                    labelText: "phone"
                ),
              ),
              ElevatedButton(onPressed: (){
                if(formkey.currentState!.validate()){
                  Student s=Student(id:widget.student.id,name: namecontroller.text, phone: phonecontroller.text);
                  myDbHelper.updateStudent(s).then((onValue){
                    if(onValue>0){
                      namecontroller.clear();
                      phonecontroller.clear();
                      setState(() {

                                            Navigator.pushAndRemoveUntil(
                                              context,
                                                MaterialPageRoute(builder: (BuildContext context) {
                                              return MyHomePage(title: "",);
                                            }),
                                                  (route) => false,
                                            );

                      });
                    }
                  });
                }
              }, child: Text("Update")),
              //  FutureBuilder(future: null, builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  },





            ],
          ),
        ),
      ),

    );
  }
}
