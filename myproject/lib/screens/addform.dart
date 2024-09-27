import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myproject/models/person.dart';
import 'package:myproject/screens/library_list.dart';
import 'package:http/http.dart' as http;
import 'dart:async'; // For concurrency support
import 'dart:isolate'; // For creating threads

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _age = 20;
  Job _job = Job.police;

    String _howToUseDes = '';
  String _exampleDes = '';
  String _suggestionDes = '';

  Future<void> addUser() async {
    var url = 'http://10.0.2.2:3000/add-library';
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'how_touse': _howToUseDes,
        'example': _exampleDes,
        'suggestion': _job.title,
      }),
    );
    if (response.statusCode == 200) {
      print('User added');
    } else {
      print('Failed to add user');
    }
    // const url = 'http://10.0.2.2:3000/test';
    // final uri = Uri.parse(url);

    // try {

    // final response = await http.get(uri);
    // var list = json.decode(response.body);

    // print("response ${response.body}");
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ແບບຟອມບັນທຶກຂໍ້ມູນ"),
        automaticallyImplyLeading: true, // Ensures the back button appears
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    label: Text(
                  "ຊື່",
                  style: TextStyle(fontSize: 20),
                )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "ກະລຸນາປ້ອນຊື່ຂອງທ່ານ";
                  }
                  return null;
                },
                onSaved: (value) {
                  _howToUseDes = value!;
                },
              ),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      label: Text(
                    "ອາຍຸ",
                    style: TextStyle(fontSize: 20),
                  )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ກະລຸນາປ້ອນອາຍຸຂອງທ່ານ";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _exampleDes = value!;
                  }),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                  value: _job,
                  decoration: const InputDecoration(
                      label: Text(
                    "ອາຊີບ",
                    style: TextStyle(fontSize: 20),
                  )),
                  items: Job.values.map((key) {
                    return DropdownMenuItem(
                      value: key,
                      child: Text(key.title),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _job = value!;
                    });
                  }),
              const SizedBox(
                height: 50,
              ),
              FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      addUser();
                      data.add(Person(name: _name, age: _age, job: _job));
                      _formKey.currentState!.reset();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) => const LibraryList()));
                    }
                  },
                  style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "ບັນທຶກ",
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
