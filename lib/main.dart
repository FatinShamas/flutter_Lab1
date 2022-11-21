import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Georgia',
      ),
      home: const MyHomePage(
        title: 'Movies App',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editTexting_ = TextEditingController();
  //declare var, string
  String desc = "";
  String title_ = "";
  String rel = "";
  var posterImg = "";
  String plot = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 165, 22, 201),
              Color.fromARGB(255, 54, 144, 204)
            ]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('MOVIES OUT'),
          backgroundColor:
              const Color.fromARGB(255, 146, 10, 123).withOpacity(0.7),
        ),
        body: Center(
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Search Movies\n",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextField(
                  controller: editTexting_,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'eg: Harry Potter', //hint dalam box search
                      suffixIcon: IconButton(
                          onPressed: () => editTexting_.clear(),
                          icon: const Icon(Icons.clear)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                  keyboardType: TextInputType.text,
                ),
                ElevatedButton(
                  onPressed: getmovie,
                  child: const Text("Search"),
                ),

                Text(
                  title_,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
                Text(
                  desc,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                //Image Network
                Image.network(posterImg, height: 290, width: 250,
                    errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                      'assets/images/moviewall.jpg');
                }),
                Text(
                  plot,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getmovie() async {
    ProgressDialog progDialog = ProgressDialog(context,
        message: const Text(
          "Progress",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Georgia',
          ),
        ),
        title: const Text("Searching..."));
    progDialog.show();

    var newText = editTexting_.text; //tukar
    var apiid = "7973b2bf";
    var url = Uri.parse('https://www.omdbapi.com/?t=$newText&apikey=$apiid');
    var response = await http.get(url);
    var rescode = response.statusCode;

    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        var title = parsedJson["Title"];
        var rel = parsedJson["Released"];
        var genre = parsedJson["Genre"];
        var direc = parsedJson["Director"];
        var actor = parsedJson["Actors"];
        var runtime = parsedJson["Runtime"];
        var plot1 = parsedJson["Plot"];
        var poster = parsedJson["Poster"];

        // var ratings = parsedJson["Ratings"]; //incase: [""]

        title_ = "\nTitle: $title, ($rel)";

        posterImg = "$poster";

        desc =
            "\nGenre: $genre \nDirector: $direc \nActors: $actor \nRuntime: $runtime \n";

        plot = "\nPlot: $plot1";

        Fluttertoast.showToast(
          msg: "Movie Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 20,
          backgroundColor: const Color.fromARGB(255, 46, 43, 43),
          textColor: Colors.white,
          fontSize: 25,
        );
      });
    } else {
      setState(() {
        desc = "NO RECORD";
      });
    }

    progDialog.dismiss();
  }
}
