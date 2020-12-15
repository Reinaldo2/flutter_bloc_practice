import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_practice/ui/pages/pages.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
     
      if(FirebaseAuth.instance.currentUser != null){
        return MaterialApp(
        home: MainMenu(),
        );
      }else{return MaterialApp(
        home: SignInPage(),
        );
      }
      
  }
}
