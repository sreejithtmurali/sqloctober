import 'package:flutter/material.dart';
import 'package:sqloctober/editstudent.dart';
import 'package:sqloctober/student.dart';

import 'mydbhelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

TextEditingController namecontroller=TextEditingController();
TextEditingController phonecontroller=TextEditingController();
final formkey=GlobalKey<FormState>();
MyDbHelper myDbHelper=MyDbHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
              ElevatedButton(onPressed: () async {
                if(formkey.currentState!.validate()){
                  Student s=Student(name: namecontroller.text, phone: phonecontroller.text);
                 await myDbHelper.insertStudent(s).then((onValue){
                    if(onValue>0){
                      namecontroller.clear();
                      phonecontroller.clear();
                      setState(() {

                      });
                    }
                  });
                }
              }, child: Text("Insert")),
            //  FutureBuilder(future: null, builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  },
             FutureBuilder(
               future: myDbHelper.getallStudents(),
               builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                 if(snapshot.hasData){
                               return ListView.builder(itemCount: snapshot.data!.length,
                                 shrinkWrap: true,
                                 itemBuilder: (BuildContext context, int index) {
                                   Student s=Student(id:snapshot.data![index]['id'],name: snapshot.data![index]['name'], phone: snapshot.data![index]['phone']);
                                   return ListTile(
                                     onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                         return Editstudent(student:s);
                                       }));
                                     },
                                     leading: Text('${s.id}'),
                                     title: Text('${s.name}'),
                                     subtitle: Text('${s.phone}'),
                                     trailing: IconButton(
                                         onPressed: () async {
                                           await myDbHelper.deleteStudent(s);
                                           setState(() {
                                           });
                                         },
                                         icon: Icon(Icons.delete,color: Colors.red,)
                                     ),
                                   );
                                 },
                               );
                 }
                 else if(snapshot.hasError){
                            return Center(child: Text("error"),);
                 }
                 else{
                        return Center(child: CircularProgressIndicator(),);
                 }

               }, )




            ],
          ),
        ),
      ),

    );
  }
}
