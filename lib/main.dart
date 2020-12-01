import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fun_auth/authentication_service.dart';

void main() async {
  // ignore: unused_local_variable
  FirebaseAuth auth;
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp defaultApp = await Firebase.initializeApp();
  auth = FirebaseAuth.instanceFor(app: defaultApp);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _auth.currentUser != null
          ? MyHomePage(title: 'Flutter Demo Home Page')
          : LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Fun App!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            OutlinedButton(
              onPressed: () async {
                await AuthService().handleGoogleSignOut().then(
                      (_) => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      ),
                    );
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  await AuthService()
                      .signInWithEmailAndPassword(
                          emailController.text, passwordController.text)
                      .then(
                        (_) => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        ),
                      );
                },
                child: Text('Login'),
              ),
              OutlinedButton(
                onPressed: () async {
                  await AuthService()
                      .signUpWithEmailAndPassword(
                          emailController.text, passwordController.text)
                      .then(
                        (_) => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        ),
                      );
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
