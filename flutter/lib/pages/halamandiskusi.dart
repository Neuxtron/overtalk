import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtalk/models/diskusiModel.dart';
import 'package:overtalk/models/userModel.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/global.dart';

class Diskusi extends StatefulWidget {
  final UserModel user;
  final DiskusiModel diskusi;

  const Diskusi({
    super.key,
    required this.user,
    required this.diskusi,
  });

  @override
  State<Diskusi> createState() => _DiskusiState();
}

class _DiskusiState extends State<Diskusi> {
  final Repository repository = Repository();
  TextEditingController replyController = TextEditingController();
  List replies = [];
  bool bookmarked = false;

  void getReplies() async {
    List<DiskusiModel> listDiskusi = await repository.getDiskusi();
    for (var element in listDiskusi) {
      if (element.id == widget.diskusi.id) {
        replies = element.replies;
        setState(() {});
      }
    }
  }

  void reply() async {
    final String reply = replyController.text;
    replyController.text = "";
    getReplies();
    Map<String, String> pesan = {
      "nama": widget.user.nama,
      "reply": reply,
    };

    replies.add(pesan);
    final response = await repository.updateReplies(widget.diskusi.id, replies);

    if (response) getReplies();
  }

  void toggleBookmark() async {
    if (bookmarked) {
      List bookmarks = widget.user.bookmarks;
      bookmarks.removeWhere((element) => element == widget.diskusi.id);
      final response =
          await repository.updateBookmarks(widget.user.id, bookmarks);

      if (response) {
        bookmarked = false;
        setState(() {});
      }
    } else {
      List bookmarks = widget.user.bookmarks;
      bookmarks.add(widget.diskusi.id);
      final response =
          await repository.updateBookmarks(widget.user.id, bookmarks);

      if (response) {
        bookmarked = true;
        setState(() {});
      }
    }
  }

  void getBookmark() {
    for (var element in widget.user.bookmarks) {
      print(widget.user.bookmarks);
      print(widget.diskusi.id);
      if (element == widget.diskusi.id) {
        bookmarked = true;
        setState(() {});
        print(bookmarked);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getReplies();
    getBookmark();
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
        leading: Padding(
          padding: const EdgeInsets.only(right: 7),
          child: IconButton(
            splashRadius: 25,
            onPressed: toggleBookmark,
            icon: Icon(
              bookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: GlobalColors.onBackground,
              size: 30,
            ),
          ),
        ),

        //--- Tombol Bookmark ---//
        actions: [
          IconButton(
            splashRadius: 25,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: GlobalColors.onBackground,
              size: 40,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //--- Judul Diskusi ---//
                  Text(
                    widget.diskusi.judul,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.onBackground,
                    ),
                  ),

                  //--- Pembuka Diskusi ---//
                  Text(
                    widget.diskusi.pembuka,
                    style: TextStyle(color: GlobalColors.prettyGrey),
                  ),

                  //--- Created At Diskusi ---//
                  Text(
                    DateFormat("dd MMMM yyyy").format(widget.diskusi.createdAt),
                    style: TextStyle(color: GlobalColors.prettyGrey),
                  ),

                  //--- Konten Diskusi ---//
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.diskusi.konten,
                        style: TextStyle(
                          color: GlobalColors.text,
                        ),
                      ),
                    ),
                  ),

                  //--- Garis Abu2 dan Tulisan Replies ---//
                  Divider(
                    color: GlobalColors.prettyGrey,
                    thickness: 1,
                    height: 50,
                  ),
                  Text(
                    "Replies",
                    style: TextStyle(
                      fontSize: 18,
                      color: GlobalColors.onBackground,
                    ),
                  ),

                  //--- Jarak ---//
                  SizedBox(height: 30),

                  //--- List Replies ---/
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    padding: EdgeInsets.only(bottom: 50),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //--- Nama Yang Reply ---//
                          Text(
                            replies[index]["nama"],
                            style: TextStyle(fontSize: 12),
                          ),

                          //--- Isi Reply ---//
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 5, bottom: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: GlobalColors.prettyGrey,
                              ),
                            ),
                            child: Text(replies[index]["reply"]),
                          ),
                        ],
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
                      image: NetworkImage(""),
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
                      margin: EdgeInsets.only(left: 12),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      decoration: BoxDecoration(
                        color: GlobalColors.backgroundColor,
                        border: Border.all(color: GlobalColors.prettyGrey),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: TextField(
                        maxLines: null,
                        controller: replyController,
                        style: TextStyle(
                          fontSize: 14,
                          color: GlobalColors.text,
                        ),
                        decoration: InputDecoration(
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
                    icon: Icon(
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
