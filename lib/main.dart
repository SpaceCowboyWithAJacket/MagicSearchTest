import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
var userInput;
String inputIntoSearch = "";
List<Widget> childs = [];
String clickedOn = "";


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
	return const MaterialApp(
  	debugShowCheckedModeBanner: false,
  	home: HomePage() 
	);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
	super.key,
  });
 
  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class  _MyHomePageState extends State<HomePage> {

  @override
  void initState() {
  super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
	return  Scaffold(
    
    appBar: AppBar (
      toolbarHeight: 75,
      backgroundColor: Colors.blueGrey,
      title: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              onFieldSubmitted: (input) {
                inputIntoSearch = input;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchedPage()),
                ); 
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                iconColor: Colors.white,
                hintText: "Search" ,
                hintStyle:TextStyle(color: Colors.white)
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ElevatedButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdvancedSearchPage()),
              ); 
            }, 
            child: Text("Advanced Search"), 
          ),
        ),
      ],
    ),
  	body: Text("New Commit Test")
	);
  }
}

class SearchedPage extends StatefulWidget{
  const SearchedPage({
  super.key,
  });

  @override
  _SearchedPage createState() => _SearchedPage();
}

class _SearchedPage extends State<SearchedPage> {
  List<String> searchList = [""];

  Future<int> getWebsiteData() async {
    List<Widget> tempChilds = [];
    final url =  Uri.parse('https://api.scryfall.com/cards/search?q=$inputIntoSearch');
    //final url = Uri.parse('https://api.scryfall.com/cards/search?q=c%3Ablue+pow%3D7+oracle%3Areturn');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html
        .querySelectorAll('html > body')
        .map((element) => element.innerHtml.trim())
        .toList();
    for (final title in titles) {
      var bobs = title.split('","normal":"');
      bobs.removeAt(0);
      for (int i = 0; i < bobs.length; i++) { 
        var bobettes = bobs[i].split('","large":"');
        bobs[i] = bobettes[0];
      }
      userInput = bobs;
      for (var i = 0; i < userInput.length; i++) { 
        tempChilds.add(
          Container(
            child: ElevatedButton(
              onPressed: () {
                clickedOn = bobs[i];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IndividualSearchedPage()),
                ); 
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
                overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
              ),
              child: Image( 
                image: NetworkImage(bobs[i])),
            )
          )
        );
      }
      childs = tempChilds;
      print("Printed");
      }
      return titles.length;
  }

  @override
  void initState() {
	super.initState();
  }

  @override
  Widget build(BuildContext context) {
	  return  FutureBuilder (
      future: getWebsiteData(), 
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar (
              toolbarHeight: 75,
              backgroundColor: Colors.blueGrey,
              title: Text("")),
            body: GridView.count(crossAxisCount: 2, children: childs,)
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("error"));
        } else {
          return Center(child: Text("Loading"));
        }
      }

      /**/
  	);
  }
}

class IndividualSearchedPage extends StatefulWidget{
  const IndividualSearchedPage({
  super.key,
  });

  @override
  _IndividualSearchedPage createState() => _IndividualSearchedPage();
}

class _IndividualSearchedPage extends State<IndividualSearchedPage> {

  @override
  void initState() {
	super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Center(
            child: Container(
              child: Image(
                image: NetworkImage(clickedOn)
              ),
            )
          ),
        ],
      )
    );
  }

}

class AdvancedSearchPage extends StatefulWidget{
  const AdvancedSearchPage({
  super.key,
  });

  @override
  _AdvancedSearchPage createState() => _AdvancedSearchPage();
}

class _AdvancedSearchPage extends State<AdvancedSearchPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController oracleController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  void UserInput() {
    //Name
    if (nameController.text != "") {}
    inputIntoSearch = nameController.text;
    //Oracle Text
    if (oracleController.text != "") {
      var voText = oracleController.text.split(" ");
      String oText = "";
      for (int i = 0; i<voText.length; i++) {
        oText += "+oracle%3A";
        oText += voText[i];
      }
      inputIntoSearch += oText;
    }
    //Type of Card
    if (typeController.text != "") {
      var vtText = typeController.text.split(" ");
      String tText = "";
      for (int i = 0; i<vtText.length; i++) {
        tText += "+type%3A";
        tText += vtText[i];
      }
      inputIntoSearch += tText;
    }
    //Color - including NEED TO FIX THIS NEED TO FIX THIS NEED TO FIX THIS
    if (colorController.text != "") {
      inputIntoSearch += "+colors%3A";
      inputIntoSearch += colorController.text;
    }
    //Go to searched page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchedPage()),
    ); 
  }
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Card Name"),
                TextFormField(
                  controller: nameController,
                  onFieldSubmitted: (value) {
                    UserInput();
                  },
                ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Oracle"),
                TextFormField(
                  controller: oracleController,
                  onFieldSubmitted: (value) {
                    UserInput();
                  },
                ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Type"),
                TextFormField(
                  controller: typeController,
                  onFieldSubmitted: (value) {
                    UserInput();
                  },
                ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Color - Including (Only one color for now) (Fix later put in checkboxes instead)"),
                TextFormField(
                  controller: colorController,
                  onFieldSubmitted: (value) {
                    UserInput();
                  },
                ),
              ],
            )
          ),
        ElevatedButton(
          onPressed: () {
            UserInput();
          },
          child: Text("Search")
        )
        ],
      )
    );
  }
}