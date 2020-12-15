import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc_practice/models/models.dart';
import 'package:image_picker/image_picker.dart';

class ProductServices {
  static CollectionReference productCollection =
      FirebaseFirestore.instance.collection("product");
  static DocumentReference productDoc;

  static Reference ref;
  static UploadTask uploadTask;
  static FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://flutterpractice-37557.appspot.com/');

  static String imgUrl;

  static Future<bool> addProduct(Products product, PickedFile imgFile) async {
    await Firebase.initializeApp();

    productDoc = await productCollection.add({
      'id': "",
      'name': product.name,
      'price': product.price,
      'image': "",
    });

    if (productDoc.id != null) {
      ref = FirebaseStorage.instance
          .ref()
          .child("images")
          .child(productDoc.id + ".png");
      uploadTask = ref.putFile(File(imgFile.path));

      await uploadTask.whenComplete(() => ref.getDownloadURL().then(
            (value) => imgUrl = value,
          ));

      productCollection.doc(productDoc.id).update({
        'id': productDoc.id,
        'image': imgUrl,
      });

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateProduct(Products product) async {
    await productCollection.doc(product.id).update(
      {'name': product.name, 'price': product.price},
    );
    return true;
  }

  static Future<void> deleteProduct(Products product) async {
    await productCollection.doc(product.id).delete();
    storage.ref().child('images/' + product.id + '.png').delete();
  }
}
