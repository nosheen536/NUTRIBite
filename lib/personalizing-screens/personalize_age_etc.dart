// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class PersonalizeJourneyPage extends StatefulWidget {
//   const PersonalizeJourneyPage({super.key});

//   @override
//   State<PersonalizeJourneyPage> createState() => _PersonalizeJourneyPageState();
// }

// class _PersonalizeJourneyPageState extends State<PersonalizeJourneyPage> {
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController weightController = TextEditingController();

//   String selectedWeightUnit = 'kg';
//   String? selectedGender;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? genderError;

//   void _onNextPressed() {
//     setState(() {
//       genderError = selectedGender == null ? 'Please select a gender' : null;
//     });

//     if (_formKey.currentState!.validate() && selectedGender != null) {
//       Navigator.pushNamed(context, '/personalizehealth');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill out all fields before continuing.'),
//           backgroundColor: Colors.redAccent,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               "assets/images/background_designn.jpeg",
//               fit: BoxFit.cover,
//             ),
//           ),
//           SafeArea(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height,
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 30),
//                       const Text(
//                         "Personalize Your Journey",
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w900,
//                           fontFamily: 'Serif',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Tell us a bit about yourself to get\ncustomized meal plans!",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Sans',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 40),

//                       const LabelText(label: "Age"),
//                       const SizedBox(height: 10),
//                       InputBox(
//                         controller: ageController,
//                         inputType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Enter your age';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),

//                       const LabelText(label: "Weight"),
//                       const SizedBox(height: 10),
//                       Stack(
//                         alignment: Alignment.centerRight,
//                         children: [
//                           InputBox(
//                             controller: weightController,
//                             inputType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Enter your weight';
//                               }
//                               return null;
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 15),
//                             child: DropdownButton<String>(
//                               value: selectedWeightUnit,
//                               icon: const Icon(Icons.arrow_drop_down),
//                               underline: const SizedBox(),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black,
//                               ),
//                               dropdownColor:
//                                   const Color.fromRGBO(240, 255, 230, 1),
//                               borderRadius: BorderRadius.circular(12),
//                               items: ['kg', 'pounds']
//                                   .map(
//                                     (unit) => DropdownMenuItem(
//                                       value: unit,
//                                       child: Text(unit),
//                                     ),
//                                   )
//                                   .toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedWeightUnit = value!;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 20),
//                       const LabelText(label: "Gender"),
//                       const SizedBox(height: 5),
//                       Container(
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 2),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: DropdownButtonFormField<String>(
//                           value: selectedGender,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                           hint: const Text("Select Gender"),
//                           dropdownColor:
//                               const Color.fromRGBO(240, 255, 230, 1),
//                           borderRadius: BorderRadius.circular(12),
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                           ),
//                           items: const [
//                             DropdownMenuItem(value: "Male", child: Text("Male")),
//                             DropdownMenuItem(value: "Female", child: Text("Female")),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedGender = value;
//                               genderError = null;
//                             });
//                           },
//                         ),
//                       ),
//                       if (genderError != null)
//                         Padding(
//                           padding: const EdgeInsets.only(left: 12, top: 4),
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               genderError!,
//                               style: const TextStyle(color: Colors.red, fontSize: 13),
//                             ),
//                           ),
//                         ),

//                       const SizedBox(height: 50),
//                       ElevatedButton(
//                         onPressed: _onNextPressed,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               const Color.fromRGBO(186, 216, 135, 1),
//                           side: const BorderSide(color: Colors.black, width: 2),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 15),
//                         ),
//                         child: const Text(
//                           "Next",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w800,
//                             fontFamily: 'Serif',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LabelText extends StatelessWidget {
//   final String label;
//   const LabelText({super.key, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       label,
//       style: const TextStyle(
//         fontSize: 18,
//         fontFamily: 'Serif',
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }

// class InputBox extends StatelessWidget {
//   final TextEditingController controller;
//   final TextInputType inputType;
//   final String? Function(String?)? validator;

//   const InputBox({
//     super.key,
//     required this.controller,
//     required this.inputType,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextFormField(
//           controller: controller,
//           keyboardType: inputType,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//           ],
//           validator: validator,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//             isDense: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//           ),
//           style: const TextStyle(
//             height: 1.2,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class PersonalizeJourneyPage extends StatefulWidget {
//   const PersonalizeJourneyPage({super.key});

//   @override
//   State<PersonalizeJourneyPage> createState() => _PersonalizeJourneyPageState();
// }

// class _PersonalizeJourneyPageState extends State<PersonalizeJourneyPage> {
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController weightController = TextEditingController();

//   String selectedWeightUnit = 'kg';
//   String? selectedGender;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? genderError;

//   void _onNextPressed() {
//     setState(() {
//       genderError = selectedGender == null ? 'Please select a gender' : null;
//     });

//     if (_formKey.currentState!.validate() && selectedGender != null) {
//       Navigator.pushNamed(context, '/personalizehealth');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill out all fields before continuing.'),
//           backgroundColor: Colors.redAccent,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color.fromRGBO(245, 255, 235, 1),
//                     Color.fromRGBO(210, 235, 175, 1),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SafeArea(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height,
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 30),
//                       const Text(
//                         "Personalize Your Journey",
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w900,
//                           fontFamily: 'Serif',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Tell us a bit about yourself to get\ncustomized meal plans!",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Sans',
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 40),

//                       const LabelText(label: "Age"),
//                       const SizedBox(height: 10),
//                       InputBox(
//                         controller: ageController,
//                         inputType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Enter your age';
//                           }
//                           final age = int.tryParse(value);
//                           if (age == null || age < 10 || age > 65) {
//                             return 'Age must be between 10 and 65';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),

//                       const LabelText(label: "Weight"),
//                       const SizedBox(height: 10),
//                       Stack(
//                         alignment: Alignment.centerRight,
//                         children: [
//                           InputBox(
//                             controller: weightController,
//                             inputType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Enter your weight';
//                               }
//                               final weight = int.tryParse(value);
//                               if (weight == null || weight < 15 || weight >= 400) {
//                                 return 'Weight must be between 15 and 399';
//                               }
//                               return null;
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 15),
//                             child: DropdownButton<String>(
//                               value: selectedWeightUnit,
//                               icon: const Icon(Icons.arrow_drop_down),
//                               underline: const SizedBox(),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black,
//                               ),
//                               dropdownColor: const Color.fromRGBO(
//                                 240,
//                                 255,
//                                 230,
//                                 1,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                               items: ['kg', 'pounds']
//                                   .map((unit) => DropdownMenuItem(
//                                         value: unit,
//                                         child: Text(unit),
//                                       ))
//                                   .toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedWeightUnit = value!;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 20),
//                       const LabelText(label: "Gender"),
//                       const SizedBox(height: 5),
//                       Container(
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 2),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: DropdownButtonFormField<String>(
//                           value: selectedGender,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                           hint: const Text("Select Gender"),
//                           dropdownColor: const Color.fromRGBO(240, 255, 230, 1),
//                           borderRadius: BorderRadius.circular(12),
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                           ),
//                           items: const [
//                             DropdownMenuItem(
//                               value: "Male",
//                               child: Text("Male"),
//                             ),
//                             DropdownMenuItem(
//                               value: "Female",
//                               child: Text("Female"),
//                             ),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedGender = value;
//                               genderError = null;
//                             });
//                           },
//                         ),
//                       ),
//                       if (genderError != null)
//                         Padding(
//                           padding: const EdgeInsets.only(left: 12, top: 4),
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               genderError!,
//                               style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                         ),

//                       const SizedBox(height: 50),
//                       ElevatedButton(
//                         onPressed: _onNextPressed,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color.fromRGBO(
//                             186,
//                             216,
//                             135,
//                             1,
//                           ),
//                           side: const BorderSide(color: Colors.black, width: 2),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 15,
//                           ),
//                         ),
//                         child: const Text(
//                           "Next",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w800,
//                             fontFamily: 'Serif',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LabelText extends StatelessWidget {
//   final String label;
//   const LabelText({super.key, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       label,
//       style: const TextStyle(
//         fontSize: 18,
//         fontFamily: 'Serif',
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }

// class InputBox extends StatelessWidget {
//   final TextEditingController controller;
//   final TextInputType inputType;
//   final String? Function(String?)? validator;

//   const InputBox({
//     super.key,
//     required this.controller,
//     required this.inputType,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextFormField(
//           controller: controller,
//           keyboardType: inputType,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//           ],
//           validator: validator,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 14,
//             ),
//             isDense: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: const BorderSide(color: Colors.black, width: 2),
//             ),
//           ),
//           style: const TextStyle(height: 1.2, fontSize: 16),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PersonalizeJourneyPage extends StatefulWidget {
  const PersonalizeJourneyPage({super.key});

  @override
  State<PersonalizeJourneyPage> createState() => _PersonalizeJourneyPageState();
}

class _PersonalizeJourneyPageState extends State<PersonalizeJourneyPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String selectedWeightUnit = 'kg';
  String? selectedGender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? genderError;

  DateTime? _lastBackPressed;

  void _onNextPressed() {
    setState(() {
      genderError = selectedGender == null ? 'Please select a gender' : null;
    });

    if (_formKey.currentState!.validate() && selectedGender != null) {
      Navigator.pushNamed(context, '/personalizehealth');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields before continuing.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (_lastBackPressed == null || now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press again to exit app'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
     SystemNavigator.pop();
  return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(245, 255, 235, 1),
                      Color.fromRGBO(210, 235, 175, 1),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          "Personalize Your Journey",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Serif',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Tell us a bit about yourself to get\ncustomized meal plans!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Sans',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        const LabelText(label: "Age"),
                        const SizedBox(height: 10),
                        InputBox(
                          controller: ageController,
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 10 || age > 65) {
                              return 'Age must be between 10 and 65';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const LabelText(label: "Weight"),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            InputBox(
                              controller: weightController,
                              inputType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your weight';
                                }
                                final weight = int.tryParse(value);
                                if (weight == null || weight < 15 || weight >= 400) {
                                  return 'Weight must be between 15 and 399';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: DropdownButton<String>(
                                value: selectedWeightUnit,
                                icon: const Icon(Icons.arrow_drop_down),
                                underline: const SizedBox(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                dropdownColor: const Color.fromRGBO(240, 255, 230, 1),
                                borderRadius: BorderRadius.circular(12),
                                items: ['kg', 'pounds']
                                    .map((unit) => DropdownMenuItem(
                                          value: unit,
                                          child: Text(unit),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedWeightUnit = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const LabelText(label: "Gender"),
                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedGender,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            hint: const Text("Select Gender"),
                            dropdownColor: const Color.fromRGBO(240, 255, 230, 1),
                            borderRadius: BorderRadius.circular(12),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "Male",
                                child: Text("Male"),
                              ),
                              DropdownMenuItem(
                                value: "Female",
                                child: Text("Female"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                                genderError = null;
                              });
                            },
                          ),
                        ),
                        if (genderError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                genderError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _onNextPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(186, 216, 135, 1),
                            side: const BorderSide(color: Colors.black, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Serif',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String label;
  const LabelText({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'Serif',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String? Function(String?)? validator;

  const InputBox({
    super.key,
    required this.controller,
    required this.inputType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          validator: validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
          style: const TextStyle(height: 1.2, fontSize: 16),
        ),
      ],
    );
  }
}
