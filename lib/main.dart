import 'package:flutter/material.dart';
 import 'package:tflite_flutter/tflite_flutter.dart';
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
        // the application has a blue toolbar. Then, without quitting the app,
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
      home: const MyHomePage(title: 'Regression Model'),
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

  late Interpreter interpreter;
  var result = "results to be shown here...";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/linear.tflite');
  }

  performAction(){
    int value = int.parse(textEditingController.text);
    // For ex: if input tensor shape [1,1] and type is float32
    var input = [value];

    // if output tensor shape [1,1] and type is float32
    var output = List.filled(1, 0).reshape([1,1]);

    // inference
    interpreter.run(input, output);

    // print the output
    print(output);
    setState(() {
      result = output[0][0].toStringAsFixed(2);
    });
  }


  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          margin: EdgeInsets.only(left: 40,right: 40),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(controller: textEditingController,decoration: InputDecoration(hintText: "Type Number"),),
              ElevatedButton(onPressed: (){
                performAction();
              }, child: Text('Get')),
              Text(
                '$result',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
