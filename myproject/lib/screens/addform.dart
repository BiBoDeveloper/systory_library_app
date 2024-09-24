import 'package:flutter/material.dart';
import 'package:myproject/main.dart';
import 'package:myproject/models/person.dart';
import 'package:myproject/screens/item.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Title",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ແບບຟອມບັນທຶກຂໍ້ມູນ"),
          centerTitle: true,
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
                      label: Text("ຊື່",style: TextStyle(fontSize: 20),)
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "ກະລຸນາປ້ອນຊື່ຂອງທ່ານ";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      label: Text("ອາຍຸ", style: TextStyle(fontSize: 20),)
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "ກະລຸນາປ້ອນອາຍຸຂອງທ່ານ";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _age = int.tryParse(value.toString()) ?? 0;
                  }
                ),
                const SizedBox(height: 20,),
                DropdownButtonFormField(
                  value: _job,
                  decoration: const InputDecoration(
                      label: Text("ອາຊີບ", style: TextStyle(fontSize: 20),)
                  ),
                  items: Job.values.map((key){
                      return DropdownMenuItem(
                        value: key,
                        child: Text(key.title),
                      );
                  }).toList(), 
                  onChanged: (value){
                    setState(() {  
                    _job = value!;
                    });
                  }
                ),
                const SizedBox(height: 50,),
                FilledButton(
                    onPressed: (){
                     if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      data.add(
                        Person(name: _name, age: _age, job: _job)
                      );
                      _formKey.currentState!.reset();
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (ctx) => const Item())
                      );
                     }

                    },
                    style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text("ບັນທຶກ", style: TextStyle(fontSize: 20),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
