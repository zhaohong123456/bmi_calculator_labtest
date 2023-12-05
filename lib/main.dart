import 'package:bmi_calculator/Controller/sqlite_db.dart';
import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  TextEditingController nameController = TextEditingController();
  TextEditingController heightController  = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bmiController = TextEditingController();

  String gender ="";
  String bmiValue ="BMI Value";
  double bmi =0.0;
  static const String SQLiteTable ="bmi";

  void _displayBMI(double bmi){
    String bmiString ="";
    if(gender=="male") {
      if (bmi < 18.5) {
        bmiString = "Underweight. Careful during strong wind!";
      }
      else if (bmi >= 18.5 && bmi <= 24.9) {
        bmiString = "That’s ideal! Please maintain";
      }
      else if (bmi >= 25.0 && bmi <= 29.9) {
        bmiString = "Overweight! Work out please";
      }
      else {
        bmiString = "Whoa Obese! Dangerous mate!";
      }
    }

    else if(gender == "female"){
      if (bmi < 16) {
        bmiString = "Underweight. Careful during strong wind!";
      }
      else if (bmi >= 16.0 && bmi <= 22.0) {
        bmiString = "That’s ideal! Please maintain";
      }
      else if (bmi >= 22.0 && bmi <= 27.0) {
        bmiString = "Overweight! Work out please";
      }
      else {
        bmiString = "Whoa Obese! Dangerous mate!";
      }
    }


    setState(() {
      bmiValue = bmiString;
      bmiController.text = bmi.toString();
    });

  }
  Future<bool> _insertDatabase() async{
    String username = nameController.text;
    String height = heightController.text;
    String weight = weightController.text;
    String genderValue = gender;
    String bmi_status = bmiValue;

    Map<String, dynamic> toJson()=>{'username': username,
      'height':height,
      'weight':weight,
      'gender':genderValue,
      'bmi_status': bmi_status


    };

    if(await SQLiteDB().insert(SQLiteTable, toJson())!=0){
      return true;
    }
    else{
      return false;
    }
  }


  Future loadAll() async{

    List<Map<String, dynamic>> result = await SQLiteDB().queryAll(SQLiteTable);
    int lastIndex = result.length-1;
    nameController.text=result[lastIndex]["username"];
    heightController.text=result[lastIndex]["height"];
    weightController.text=result[lastIndex]["weight"];
    gender=result[lastIndex]["gender"];
    bmiValue=result[lastIndex]["bmi_status"];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAll();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child:
            Column(
              children: [

                //name textfield
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Your Fullname",
                  ),
                ),

                //height textfield
                TextField(
                  controller: heightController,
                  decoration: InputDecoration(
                    labelText: "height in cm; eg:170",
                  ),
                ),

                //weight textfield
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: "Weight in KG",
                  ),
                ),
//bmi textfield
                TextField(
                  controller: bmiController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "BMI",
                  ),
                ),


                SizedBox(height: 16,),
                Text(bmiValue),
                //radio button

                //male  radio button
                ListTile(title: const Text("Male"),
                  leading: Radio(value: "male",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });

                    },

                  ),
                ),

                //female radio button
                ListTile(title: const Text("Female"),
                  leading: Radio(value: "female",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });

                    },

                  ),
                ),

                ElevatedButton(onPressed: (){
                  double height = 0.00;
                  double weight = 0.00;
                  double totalBMI = 0.00;

                  height = double.parse(heightController.text)/100;
                  weight = double.parse(weightController.text);

                  totalBMI = weight/(height*height);

                  _displayBMI(totalBMI);
                  _insertDatabase();

                },
                    child: Text("Calculate BMI and Save"))
              ],
            )),
      ),
    );
  }
}