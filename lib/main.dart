import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Screen1(),
    );
  }
}
const List<String> list = <String>['HR', 'Finance', 'Marketing', 'House-keeping'];
class Screen1 extends StatefulWidget {
  const Screen1({super.key});
  @override
  State<Screen1> createState() => _Screen1State();
}
class _Screen1State extends State<Screen1> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? phone;
  String? age;
  String? Department;
  String dropdownValue = list.first;
  Widget _buildname(){
    return TextFormField(
      decoration: InputDecoration(  border: OutlineInputBorder(),labelText: ' Name ', hintText: 'enter name '),
      //maxLength: 30,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Name';
        }
        return null;
      },
      onSaved: (value) {
        name = value;
      },
    );
  }
  Widget _buildphone(){
    return TextFormField(
      decoration: InputDecoration(  border: OutlineInputBorder(),labelText: ' Contact number', hintText: 'enter your contact number'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter contact number';
        }
        return null;
      },
      onSaved: (value) {
        phone = value;
      },
    );
  }
  Widget _buildage(){
    return TextFormField(
      decoration: InputDecoration(  border: OutlineInputBorder(),labelText: 'age ', hintText: 'enter age '),
      //maxLength: 30,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter age';
        }
        return null;
      },
      onSaved: (value) {
        age = value;
      },
    );
  }
  Widget _builddepartment(){
    return  DropdownButton<String>(
      isExpanded: true,
        value: dropdownValue,
        hint: Text("Select department"),
        icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
    style: const TextStyle( color: Colors.black),
    underline: Container(
    height: 2,
    color: Colors.blue,
    ),
    onChanged: (String? value) {
    // This is called when the user selects an item.
    setState(() {
    dropdownValue = value!;
    });
    },
    items: list.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
      child: Text(value),
    );
    }).toList(),
    );
  }
  var image;

  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var image1 = await picker.getImage(source: media);

    setState(() {
      image = File(image1!.path);
    });

  }
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
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
        title: const Text('Screen 1'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(height: 20,),
              _buildname(),
                  SizedBox(height: 20,),
                  _buildphone(),
                  SizedBox(height: 20,),
                  _buildage(),
                  SizedBox(height: 20,),
                  _builddepartment(),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          myAlert();
                        },
                        child: Text('Upload Photo'),
                      ),
                      SizedBox(width: 30,),
                      image != null
                          ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(

                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.fitHeight,
                            width: 100,
                            height: 150,
                          ),
                        ),
                      )
                          : Text( "No Image",  style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              controller: _formKey.currentState!.save();
              print(name);
              print(age);
              print(phone);
              print(dropdownValue);
              print(image!.path);
              posttest(name,age,phone,dropdownValue,image!.path);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
      bottomNavigationBar: bottom(context),
    );
  }
posttest(name,age,phone,department,img) async {
    var url = Uri.parse('http://192.168.0.129:8080/screen1');

  var response =
  await http.post(url, body: {
    "name":name,"phone":phone,
    "age":age,"department":department ,
    "image_path":img});

}

}
class Screen2 extends StatefulWidget {
  final  data;
  const Screen2({ Key? key,this.data}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {

  @override
  Widget build(BuildContext context) {

    final  names = json.decode(widget.data) as List;
print(names);
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen 2"),
        centerTitle: true,

      ),
      body:
      (names.length>0) ?ListView.builder(
          shrinkWrap: true,
          itemCount: names.length,
          itemBuilder: (context,index){
            return ListTile(
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Screen3(name:names[index]["name"],age:names[index]["age"],dep:names[index]["department"],phone:names[index]["phone"],path:names[index]["image_path"])));
              },
              title: Container(
                child: Stack(
                  children: [
                     Row(
                       children: [
                         ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Image.file(
                            //to show image, you type like this.
                            File(names[index]["image_path"]),
                            fit: BoxFit.cover,
                            width:80,
                            height: 80,
                          ),
                    ),
                         SizedBox(width:50),
                         Center(
                           child: Text("${names[index]['name']}",style: TextStyle(color: Colors.black87,fontWeight:  FontWeight.bold,fontSize: 20,),
                             textDirection: TextDirection.rtl ,
                           ),
                         ),
                       ],
                     ),


                  ],
                ),
              ),

            );
          }
      ):Center(child: Text("No Data", style: TextStyle(color: Colors.red,fontSize: 20),
      ),
      ),
      bottomNavigationBar: bottom(context),
    );
  }
}


class Screen3 extends StatefulWidget {
  final name,age,dep,phone,path;
  const Screen3({Key? key, this.name,this.age,this.dep,this.phone,this.path}) : super(key: key);

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Screen 3"),
        centerTitle: true,

      ),
      body:Column(
        children: [
          SizedBox(height:20),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.file(
                //to show image, you type like this.
                File(widget.path),
                fit: BoxFit.cover,
                width:150,
                height: 150,
              ),
            ),
          ),
          SizedBox(height:50),
          Center(
            child: Text("${widget.name}",style: TextStyle(color: Colors.black87,fontWeight:  FontWeight.bold,fontSize: 20,),
              textDirection: TextDirection.rtl ,
            ),
          ), SizedBox(height:20),
          Center(
            child: Text("Age: ${widget.age}",style: TextStyle(color: Colors.black87,fontSize: 20,),
              textDirection: TextDirection.rtl ,
            ),
          ), SizedBox(height:10),
          Center(
            child: Text("Mobile:${widget.phone}",style: TextStyle(color: Colors.black87,fontSize: 20,),
              textDirection: TextDirection.rtl ,
            ),
          ), SizedBox(height:10),
          Center(
            child: Text("Department:${widget.dep}",style: TextStyle(color: Colors.black87,fontSize: 20,),
              textDirection: TextDirection.rtl ,
            ),
          ), SizedBox(height:10),
        ],
      ),
      bottomNavigationBar: bottom(context),
    );
  }
}


 bottom(context){
   return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.screen_lock_landscape),
        label: 'Screen 1',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.screen_lock_landscape),
        label: 'Screen 2',
      ),
    ],
    onTap: (int index) {
      switch (index) {
        case 0:  Navigator.push(
            context, MaterialPageRoute(builder: (_) => Screen1()));
        break;
        case 1:  posttest2(context);
        break;
      }} );


 }
posttest2(context)async{
  var url = Uri.parse('http://192.168.0.129:8080/screen2');

  var response =
  await http.post(url);
  print(response.body);
  Navigator.push(
      context, MaterialPageRoute(builder: (_) => Screen2 (data:response.body,)));

}
