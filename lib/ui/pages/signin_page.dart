part of 'pages.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final ctrlEmail = TextEditingController();
  final ctrlPassword = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    ctrlEmail.dispose();
    ctrlPassword.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("Sign in"),
          ),
          body: Stack(children: [
            Container(
                margin: EdgeInsets.all(10),
                child: ListView(children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                          controller: ctrlEmail,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              labelText: 'Email',
                              hintText: "Write your active email",
                              border: OutlineInputBorder())),
                      SizedBox(height: 20),
                      TextFormField(
                          controller: ctrlPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.vpn_key),
                              labelText: 'Password',
                              border: OutlineInputBorder())),
                      SizedBox(height: 20),
                      RaisedButton.icon(
                        icon: Icon(Icons.file_download),
                        label: Text("Sign in"),
                        textColor: Colors.white,
                        color: Colors.blue[500],
                        onPressed: () async {
                          if (ctrlEmail.text == "" || ctrlPassword.text == "") {
                            Fluttertoast.showToast(
                              msg: "Please Fill all fields !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            String result = await AuthServices.signIn(
                                ctrlEmail.text, ctrlPassword.text);
                            if (result == "success") {
                              Fluttertoast.showToast(
                                msg: "Sign in successful",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return MainMenu();
                              }));
                            } else {
                              Fluttertoast.showToast(
                                msg: result,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 25),
                      RichText(
                          text: TextSpan(
                              text: 'Not Registered ? Sign Up',
                              style: TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SignUpPage();
                                  }));
                                }))
                    ],
                  )
                ])),
            isLoading == true
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: SpinKitFadingCircle(
                      size: 50,
                      color: Colors.blue,
                    ))
                : Container()
          ]),
        ));
  }
}
