part of 'pages.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final ctrlName = TextEditingController();
  final ctrlPrice = TextEditingController();
  bool isLoading = false;

  PickedFile imageFile;
  final ImagePicker imagePicker = ImagePicker();

  Future chooseImage() async {
    final selectedImage = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      imageFile = selectedImage;
    });
  }

  @override
  void dispose() {
    ctrlName.dispose();
    ctrlPrice.dispose();
    super.dispose();
  }

  void clearForm() {
    ctrlName.clear();
    ctrlPrice.clear();
    setState(() {
      imageFile = null;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data Page"),
        centerTitle: true,
        leading: Container(),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: ctrlName,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add_box),
                          labelText: 'Product Name',
                          hintText: "Write your Product name",
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ctrlPrice,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                          labelText: 'Price',
                          hintText: "Write your Product's Price",
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    imageFile == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton.icon(
                                  onPressed: () {
                                    chooseImage();
                                  },
                                  icon: Icon(Icons.image),
                                  label: Text("Choose from gallery")),
                              Text("File not Found"),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton.icon(
                                  onPressed: () {
                                    chooseImage();
                                  },
                                  icon: Icon(Icons.image),
                                  label: Text("Rechoose from gallery")),
                              Semantics(
                                child: Image.file(
                                  File(imageFile.path),
                                  width: 100,
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: 40),
                    RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Text("Add Product"),
                      onPressed: () async {
                        if (ctrlName.text == "" ||
                            ctrlPrice.text == "" ||
                            imageFile == null) {
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
                          Products product =
                              Products("", ctrlName.text, ctrlPrice.text, "");
                          bool result = await ProductServices.addProduct(
                              product, imageFile);
                          if (result == true) {
                            Fluttertoast.showToast(
                              msg: "Add Product Successful !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            clearForm();
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            Fluttertoast.showToast(
                              msg: "Failed! Try Again",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
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
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
              ],
            ),
          ),
          isLoading == true
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SpinKitFadingCircle(
                    size: 50,
                    color: Colors.blue,
                  ))
              : Container()
        ],
      ),
    );
  }
}
