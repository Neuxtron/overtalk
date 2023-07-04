import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overtalk/models/diskusi_model.dart';
import 'package:overtalk/models/user_model.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/includes/isian.dart';
import 'package:overtalk/global.dart';

class BukaDiskusi extends StatefulWidget {
  const BukaDiskusi({
    super.key,
  });

  @override
  State<BukaDiskusi> createState() => _BukaDiskusiState();
}

class _BukaDiskusiState extends State<BukaDiskusi> {
  final _email = FirebaseAuth.instance.currentUser!.email!;
  final Repository repository = Repository();

  TextEditingController judulController = TextEditingController();
  TextEditingController kontenController = TextEditingController();
  String error = "";
  final List<PlatformFile> _attachments = [];
  bool _loading = false;

  void bukaDiskusi() async {
    setState(() {
      _loading = true;
      error = "";
    });
    if (kontenController.text == "") {
      error = "Konten tidak bisa kosong";
    }
    if (judulController.text == "") {
      error = "Judul tidak bisa kosong";
    }
    setState(() {});

    UserModel user = await repository.getUser(_email);

    if (error == "") {
      DiskusiModel model = DiskusiModel(
        id: -1,
        idUser: user.id,
        judul: judulController.text.trim(),
        konten: kontenController.text.trim(),
        createdAt: DateTime.now(),
      );
      final response = await repository.bukaDiskusi(model);

      if (response != false) {
        for (var file in _attachments) {
          uploadFile(file, response);
        }
        if (context.mounted) Navigator.pop(context);
      } else {
        error = "Gagal membuka diskusi";
        setState(() {});
      }
    }

    setState(() {
      _loading = false;
    });
  }

  void attach() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result == null) return;
    List<PlatformFile> files = result.files;
    setState(() {
      _attachments.addAll(files);
    });
  }

  Future<String> uploadFile(PlatformFile file, int id) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("attachments/${id}_${judulController.text.trim()}/${file.name}");
    final uploadTask = ref.putFile(File(file.path!));

    final snapshot = await uploadTask.whenComplete(() {});
    final fileUrl = await snapshot.ref.getDownloadURL();
    return fileUrl;
  }

  @override
  void dispose() {
    super.dispose();
    judulController.dispose();
    kontenController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,

      //--- AppBar ---//
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: GlobalColors.onBackground,
          ),
          iconSize: 25,
        ),
        leadingWidth: 40,
        title: const Text(
          "Buka Diskusi",
          style: TextStyle(color: GlobalColors.onBackground),
        ),
      ),

      //--- Body ---//
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              //--- Penulisan Eror ---//
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),

              //--- Input Judul ---//
              Isian(
                labelText: "Judul Diskusi",
                controller: judulController,
                keyboardype: TextInputType.name,
              ),

              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 4 / 1,
                  crossAxisSpacing: 5,
                ),
                itemCount: _attachments.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _attachments[index].name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _attachments.remove(_attachments[index]);
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),

              //--- Input Konten ---//
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: kontenController,
                  maxLines: null,
                  style: const TextStyle(color: GlobalColors.onBackground),
                  cursorColor: GlobalColors.onBackground,
                  decoration: InputDecoration(
                    labelText: "Konten",
                    suffixIcon: IconButton(
                      iconSize: 30,
                      color: Colors.grey,
                      onPressed: attach,
                      padding: const EdgeInsets.only(right: 10),
                      icon: const Icon(Icons.attachment_rounded),
                    ),
                    labelStyle: const TextStyle(color: GlobalColors.prettyGrey),
                    alignLabelWithHint: true,
                    floatingLabelStyle:
                        const TextStyle(color: GlobalColors.onBackground),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: GlobalColors.prettyGrey,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: GlobalColors.prettyGrey,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),

              //--- Tombol Kirim ---//
              Container(
                height: 42,
                margin: const EdgeInsets.fromLTRB(70, 40, 70, 0),
                decoration: BoxDecoration(
                  color: _loading
                      ? GlobalColors.primaryColor.withOpacity(0.5)
                      : GlobalColors.primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: InkWell(
                  onTap: _loading ? () {} : bukaDiskusi,
                  child: const Center(
                    child: Text(
                      "Buka Diskusi",
                      style: TextStyle(
                        color: GlobalColors.onPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
