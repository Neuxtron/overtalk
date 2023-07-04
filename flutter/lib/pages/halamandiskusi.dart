import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final String? token;

  const Diskusi({
    super.key,
    required this.diskusi,
    required this.pembuka,
    required this.bookmarks,
    required this.token,
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
  List<Reference> _attachments = [];
  bool _bookmarked = false;
  UserModel? _user;

  void getUsers() async {
    listUsers = await repository.getUsers();
    setState(() {});
  }

  void getUser() async {
    _user = await repository.getUser(_email);
    setState(() {});
  }

  void getReplies() async {
    replies = await repository.getReplies(widget.diskusi.id);
    setState(() {});
  }

  void getAttachments() async {
    final ref = "/attachments/${getAttachpentsPath()}";
    final files = await FirebaseStorage.instance.ref(ref).listAll();
    _attachments.addAll(files.items);

    setState(() {});
  }

  String getAttachpentsPath() {
    String path = "${widget.diskusi.id}_${widget.diskusi.judul}";
    return path;
  }

  void reply() async {
    final String reply = replyController.text;
    replyController.text = "";

    UserModel user = await repository.getUser(_email);

    final response = await repository.reply(
      widget.diskusi,
      user,
      reply,
      widget.token,
    );

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
    user.bookmarks = bookmarks;

    final response = await repository.updateUser(user);
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

  void vote(Replies reply, String value) async {
    if (value == "up") {
      if (reply.upVotes.contains(_user?.id)) {
        reply.upVotes.remove(_user?.id);
      } else {
        reply.upVotes.add(_user?.id);
        reply.downVotes.remove(_user?.id);
      }
    } else if (value == "down") {
      if (reply.downVotes.contains(_user?.id)) {
        reply.downVotes.remove(_user?.id);
      } else {
        reply.downVotes.add(_user?.id);
        reply.upVotes.remove(_user?.id);
      }
    }

    await repository.vote(reply);
    getReplies();
  }

  void openFile(String src) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewFoto(src: src),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getReplies();
    getBookmark();
    getUsers();
    getUser();
    getAttachments();
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

                  //--- Attachments ---//
                  GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        child: InkWell(
                          onTap: () async {
                            final src =
                                await _attachments[index].getDownloadURL();
                            openFile(src);
                          },
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
                            ],
                          ),
                        ),
                      );
                    },
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

                  //--- Jarak ---//
                  const SizedBox(height: 10),
                  const Text(
                    "Replies",
                    style: TextStyle(
                      fontSize: 18,
                      color: GlobalColors.onBackground,
                    ),
                  ),

                  //--- List Replies ---/
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    padding: const EdgeInsets.only(bottom: 50),
                    itemBuilder: (context, index) {
                      Replies reply = replies[index];
                      String nama = "Anonymous";
                      String fotoUrl =
                          "gs://overtalk-ffb9f.appspot.com/profile_pictures/default_profile.jpg";
                      int upVotes = reply.upVotes.length;
                      int downVotes = reply.downVotes.length;
                      bool upVote = false;
                      bool downVote = false;

                      for (var user in listUsers) {
                        if (replies[index].idUser == user.id) {
                          nama = user.nama;
                          fotoUrl = user.fotoUrl;
                        }
                      }

                      if (reply.upVotes.contains(_user?.id)) upVote = true;
                      if (reply.downVotes.contains(_user?.id)) downVote = true;

                      return Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade400,
                              backgroundImage: NetworkImage(fotoUrl),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      style: const TextStyle(
                                          color: GlobalColors.grey9),
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(reply.createdAt),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: GlobalColors.grey9,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      reply.reply,
                                      style: const TextStyle(),
                                    ),

                                    //--- DownVote ---//
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            vote(reply, "down");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_drop_down,
                                                  size: 30,
                                                  color: downVote
                                                      ? Colors.red
                                                      : GlobalColors.grey9,
                                                ),
                                                Text(
                                                  "  $downVotes ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: downVote
                                                        ? Colors.red
                                                        : GlobalColors.grey9,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        //--- UpVote ---//
                                        InkWell(
                                          onTap: () {
                                            vote(reply, "up");
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_drop_up,
                                                  size: 30,
                                                  color: upVote
                                                      ? Colors.green
                                                      : GlobalColors.grey9,
                                                ),
                                                Text(
                                                  "  $upVotes ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: upVote
                                                        ? Colors.green
                                                        : GlobalColors.grey9,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: GlobalColors.grey9,
                        height: 1,
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
                      fit: BoxFit.cover,
                      image: NetworkImage(_user?.fotoUrl ??
                          "gs://overtalk-ffb9f.appspot.com/profile_pictures/default_profile.jpg"),
                      width: 45,
                      height: 45,
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

class ViewFoto extends StatelessWidget {
  final String src;
  const ViewFoto({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(child: Image.network(src)),
    );
  }
}
