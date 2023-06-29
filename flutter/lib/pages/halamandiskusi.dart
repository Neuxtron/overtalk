import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtalk/models/diskusi_model.dart';
import 'package:overtalk/models/replies_model.dart';
import 'package:overtalk/models/user_model.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/global.dart';

class Diskusi extends StatefulWidget {
  final DiskusiModel diskusi;
  final String pembuka;
  final List bookmarks;

  const Diskusi({
    super.key,
    required this.diskusi,
    required this.pembuka,
    required this.bookmarks,
  });

  @override
  State<Diskusi> createState() => _DiskusiState();
}

class _DiskusiState extends State<Diskusi> {
  final _email = FirebaseAuth.instance.currentUser!.email!;
  final Repository repository = Repository();
  final _scrollController = ScrollController();
  TextEditingController replyController = TextEditingController();

  List<Replies> replies = [];
  List<UserModel> listUsers = [];
  bool _bookmarked = false;

  void getUsers() async {
    listUsers = await repository.getUsers();
    setState(() {});
  }

  void getReplies() async {
    replies = await repository.getReplies(widget.diskusi.id);
    setState(() {});
  }

  void reply() async {
    final String reply = replyController.text;
    replyController.text = "";

    UserModel user = await repository.getUser(_email);

    final response = await repository.reply(widget.diskusi.id, user.id, reply);

    if (response) getReplies();
  }

  void toggleBookmark() async {
    UserModel user = await repository.getUser(_email);
    List bookmarks = widget.bookmarks;

    if (_bookmarked) {
      bookmarks.removeWhere((element) => element == widget.diskusi.id);
    } else {
      bookmarks.add(widget.diskusi.id);
    }

    final response =
        await repository.updateUser(user.id, user.nama, _email, bookmarks);
    if (response) {
      setState(() {
        _bookmarked = !_bookmarked;
      });
    }
  }

  void getBookmark() {
    for (var element in widget.bookmarks) {
      if (element == widget.diskusi.id) {
        _bookmarked = true;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getReplies();
    getBookmark();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
    replyController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,

      //--- AppBar ---//
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        //--- Tombol Back ---//
        leading: IconButton(
          splashRadius: 25,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: GlobalColors.onBackground,
            size: 40,
          ),
        ),

        //--- Tombol Bookmark ---//
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: IconButton(
              splashRadius: 25,
              onPressed: toggleBookmark,
              icon: Icon(
                _bookmarked ? Icons.bookmark : Icons.bookmark_outline,
                color: GlobalColors.onBackground,
                size: 30,
              ),
            ),
          ),
        ],
      ),

      //--- Body ---//
      body: Stack(
        children: [
          //
          //--- Isi Utama ---//
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //--- Judul Diskusi ---//
                  Text(
                    widget.diskusi.judul,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.onBackground,
                    ),
                  ),

                  //--- Pembuka Diskusi ---//
                  Text(
                    widget.pembuka,
                    style: const TextStyle(color: GlobalColors.prettyGrey),
                  ),

                  //--- Created At Diskusi ---//
                  Text(
                    DateFormat("dd MMMM yyyy").format(widget.diskusi.createdAt),
                    style: const TextStyle(color: GlobalColors.prettyGrey),
                  ),

                  //--- Konten Diskusi ---//
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.diskusi.konten,
                        style: const TextStyle(
                          color: GlobalColors.text,
                        ),
                      ),
                    ),
                  ),

                  //--- Garis Abu2 dan Tulisan Replies ---//
                  const Divider(
                    color: GlobalColors.prettyGrey,
                    thickness: 1,
                    height: 50,
                  ),
                  const Text(
                    "Replies",
                    style: TextStyle(
                      fontSize: 18,
                      color: GlobalColors.onBackground,
                    ),
                  ),

                  //--- Jarak ---//
                  const SizedBox(height: 30),

                  //--- List Replies ---/
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    padding: const EdgeInsets.only(bottom: 50),
                    itemBuilder: (context, index) {
                      Replies reply = replies[index];
                      String nama = "";

                      for (var element in listUsers) {
                        if (replies[index].idUser == element.id) {
                          nama = element.nama;
                        }
                      }

                      return Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade400,
                                backgroundImage:
                                    const AssetImage("assets/profile.jpg"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      style:
                                          TextStyle(color: GlobalColors.grey9),
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(reply.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: GlobalColors.grey9,
                                        height: 1.5,
                                      ),
                                    ),
                                    Text(
                                      reply.reply,
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ));
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: GlobalColors.grey9,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          //--- Isian Reply ---//
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12),
              child: Row(
                children: [
                  //
                  //--- Foto Profil ---//
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: const NetworkImage(""),
                      width: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/profile.jpg",
                          width: 45,
                        );
                      },
                    ),
                  ),

                  //--- Textbox Reply ---//
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      decoration: BoxDecoration(
                        color: GlobalColors.backgroundColor,
                        border: Border.all(color: GlobalColors.prettyGrey),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: TextField(
                        maxLines: null,
                        controller: replyController,
                        style: const TextStyle(
                          fontSize: 14,
                          color: GlobalColors.text,
                        ),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: EdgeInsets.only(top: 7),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Reply...",
                          hintStyle: TextStyle(color: GlobalColors.prettyGrey),
                        ),
                      ),
                    ),
                  ),

                  //--- Tombol Kirim ---//
                  IconButton(
                    onPressed: reply,
                    icon: const Icon(
                      Icons.send,
                      size: 30,
                      color: GlobalColors.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
