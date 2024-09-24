// import 'package:flutter/material.dart';

// class Item extends StatefulWidget {
//   const Item({super.key});

//   @override
//   State<Item> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<Item> {
//   int quantity = 1;

//   void addQuantity() {
//     setState(() {
//       quantity += 1;
//     });
//   }

//   void subtractQuantity() {
//     setState(() {
//       quantity = quantity <= 0 ? 0 : quantity - 1;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("$quantity", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
//           const SizedBox(height: 20,),
//           OutlinedButton(
//             onPressed: addQuantity,
//             child: const Text("+", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//           ),
//           const SizedBox(height: 20,),
//           OutlinedButton(
//             onPressed: subtractQuantity,
//             child: const Text("-", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:myproject/models/person.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/screens/addPresentation.dart';
import 'package:myproject/screens/addform.dart';
import 'package:myproject/screens/loginPage.dart';


class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Item> {

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     SizedBox(
    //         height: 350,
    //         child: Center(
    //           child: Image.asset(
    //             'assets/images/systory_logo.png', // Path to your image
    //             width: 250,  // You can adjust the width and height as needed
    //             height: 250,
    //             fit: BoxFit.cover, // This ensures the image fits within its boundaries
    //           ),
    //         ),
    //     ),
    //     Container(
    //         height: 540,
    //         decoration: const BoxDecoration(
    //           borderRadius: BorderRadius.only(
    //             topRight: Radius.circular(80), // Radius for the right side
    //           ),
    //           color: Color(0xFF00ACC1),  
    //         ),
    //         child: Center(
    //            child: Padding(
    //             padding: const EdgeInsets.all(30),  // Correct use of Padding widget
    //               child: Column(
    //                 children: [
    //                   TextFormField(
    //                     decoration: InputDecoration(
    //                       label: Text(
    //                         "ບັນຊີຜູ້ໃຊ້", 
    //                         style: GoogleFonts.notoSansLao(
    //                           textStyle: const TextStyle(
    //                             fontSize: 20,
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.white
    //                           )
    //                         ),
    //                       ),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return "ກະລຸນາປ້ອນຊື່ຂອງທ່ານ";
    //                       }
    //                       return null;
    //                     },
    //                     onSaved: (value) {
    //                       _name = value!;
    //                     },
    //                   ),
    //                   const SizedBox(height: 30),
    //                   TextFormField(
    //                     keyboardType: TextInputType.visiblePassword,
    //                     decoration: InputDecoration(
    //                       label: Text(
    //                         "ລະຫັດຜ່ານ", 
    //                         style: GoogleFonts.notoSansLao(
    //                           textStyle: const TextStyle(
    //                             fontSize: 20,
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.white
    //                           )
    //                         ),
    //                       ),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return "ກະລຸນາປ້ອນອາຍຸຂອງທ່ານ";
    //                       }
    //                       return null;
    //                     },
    //                     onSaved: (value) {
    //                       _age = int.tryParse(value.toString()) ?? 0;
    //                     },
    //                   ),
    //                   const SizedBox(height: 20),
    //                   FilledButton(
    //                     onPressed: () {},
    //                     style: FilledButton.styleFrom(backgroundColor: Colors.blue),
    //                     child: const Text(
    //                       "ບັນທຶກ", 
    //                       style: TextStyle(fontSize: 20),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //            ),
    //         ),
    //     ),
    //   ]
    // );

      return Scaffold(
      appBar: AppBar(
        title: const Text('Systory Library'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with your login screen
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Background color for the body
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: data[index].job.color,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[index].name,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Text(
                              "Age: ${data[index].age}, Job: ${data[index].job.title}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Image.asset(
                          data[index].job.image,
                          width: 70,
                          height: 70,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: IconButton(
                icon: const Icon(Icons.add, size: 40, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const AddPresentation()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}