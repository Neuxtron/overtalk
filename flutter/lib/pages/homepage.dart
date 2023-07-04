import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtalk/global.dart';
import 'package:overtalk/includes/draweritem.dart';
import 'package:overtalk/models/diskusi_model.dart';
import 'package:overtalk/models/user_model.dart';
import 'package:overtalk/pages/halamandiskusi.dart';
import 'package:overtalk/pages/setelan.dart';
import 'package:overtalk/repository.dart';

import 'bukadiskusi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _email = FirebaseAuth.instance.currentUser!.email!;

  List<DiskusiModel> dataDiskusi = [];
  Repository repository = Repository();
  String halaman = "forum";
  String judulHalaman = "OverTalk";
  UserModel? _user;
  List<UserModel> _listUsers = [];

  void getCurrentUser() async {
    _user = await repository.getUser(_email);
    setState(() {});
  }

  void getUsers() async {
    _listUsers = await repository.getUsers();
    setState(() {});
  }

  void getDiskusi() async {
    dataDiskusi = await repository.getDiskusi();
    setState(() {});
  }

  void ubahHalaman(halamanBaru) {
    halaman = halamanBaru;
    scaffoldKey.currentState!.closeEndDrawer();
    if (halaman == "forum") {
      judulHalaman = "OverTalk";
    } else if (halaman == "bookmarks") {
      judulHalaman = "Bookmarks";
    }
  }

  void hapusDiskusi(String id) async {
    final response = await repository.hapusDiskusi(id);
    if (response) {
      refresh();
      setState(() {});
    }
  }

  void refresh() {
    getDiskusi();
    getUsers();
    getCurrentUser();
    // TODO: Foreground Messaging
    FirebaseMessaging.onMessage.listen(notifyUser);
  }

  Future<void> notifyUser(RemoteMessage message) async {}

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: GlobalColors.primaryColor,
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //
            //
            //--- Foto Profil ---//
            SizedBox(
              height: 210,
              width: double.infinity,
              child: ColoredBox(
                color: GlobalColors.hotPink.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 30),
                      child: CircleAvatar(
                        backgroundColor: GlobalColors.primaryColor,
                        backgroundImage: NetworkImage(_user?.fotoUrl ??
                            "https://firebasestorage.googleapis.com/v0/b/overtalk-ffb9f.appspot.com/o/profile_pictures%2Fdefault_profile.jpg?alt=media&token=dc816f76-6954-4cdc-b472-7b0ecec6e1ca"),
                        radius: 40,
                      ),
                    ),
                    Text(
                      _user?.nama ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //--- Navigasi Halaman ---//
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //
                  //
                  //--- Tombol Forum ---//
                  DrawerItem(
                    text: "Forum",
                    selected: halaman == "forum",
                    onTap: () {
                      setState(() {
                        ubahHalaman("forum");
                      });
                    },
                  ),

                  //--- Tombol Bookmarks ---//
                  DrawerItem(
                    text: "Bookmarks",
                    selected: halaman == "bookmarks",
                    onTap: () {
                      setState(() {
                        ubahHalaman("bookmarks");
                      });
                    },
                  ),

                  //--- Tombol Settings ---//
                  DrawerItem(
                    text: "Settings",
                    margin: const EdgeInsets.only(top: 10, bottom: 250),
                    onTap: () {
                      scaffoldKey.currentState!.closeEndDrawer();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Setelan(
                            user: _user,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      //--- Tombol Refresh ---//
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: "refresh", // Biar gk error
            onPressed: refresh,
            mini: true,
            child: const Icon(Icons.refresh),
          ),

          //--- Buka Diskusi ---//
          FloatingActionButton(
            heroTag: "bukaDiskusi", // Biar gk error
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BukaDiskusi(),
                ),
              ).then((value) => refresh());
            },
            child: const Icon(
              Icons.add_comment,
              size: 27,
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          Transform.translate(
            offset: const Offset(150, -170),
            child: ClipOval(
              child: Container(
                height: 300,
                width: 350,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF78BC),
                  borderRadius: BorderRadius.all(Radius.elliptical(500, 500)),
                ),
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              //--- AppBar ---//
              SliverAppBar(
                expandedHeight: 150,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(bottom: 30, left: 30),
                  title: Text(
                    judulHalaman,
                    style: const TextStyle(
                      fontFamily: 'Arial Rounded',
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              //--- Body ---//
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),

                    //--- ListView ---//
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 30, bottom: 100),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dataDiskusi.length,
                      itemBuilder: (context, index) {
                        String judul = dataDiskusi[index].judul;
                        int idUser = dataDiskusi[index].idUser;
                        String pembuka = "Unknown User";
                        String? token;
                        bool tampil = false;
                        List bookmarks = _user?.bookmarks ?? [];

                        for (var element in _listUsers) {
                          if (idUser == element.id) {
                            pembuka = element.nama;
                            token = element.token;
                          }
                        }

                        String createdAt = DateFormat("dd MMMM yyyy")
                            .format(dataDiskusi[index].createdAt);

                        final String today =
                            DateFormat("dd MMMM yyyy").format(DateTime.now());
                        if (createdAt == today) {
                          createdAt = "Hari ini";
                        }

                        if (halaman == "bookmarks") {
                          for (var element in bookmarks) {
                            if (element == dataDiskusi[index].id) {
                              tampil = true;
                            }
                          }
                        } else if (halaman == "forum") {
                          tampil = true;
                        }

                        if (tampil) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),

                            //--- Dekorasi Item ---//
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: GlobalColors.primaryColor,
                                  width: 1.5,
                                )),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 18),

                              //--- Navigasi Item ---//
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Diskusi(
                                      diskusi: dataDiskusi[index],
                                      pembuka: pembuka,
                                      bookmarks: bookmarks,
                                      token: token,
                                    ),
                                  ),
                                ).then((value) => refresh());
                              },

                              //--- Judul Item ---//
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Text(
                                  judul,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: GlobalColors.onBackground,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),

                              //--- Pembuka Item ---//
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "By: $pembuka",
                                    style: const TextStyle(
                                      color: GlobalColors.prettyGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),

                                  //--- Created At Item ---//
                                  Text(
                                    createdAt,
                                    style: const TextStyle(
                                      color: GlobalColors.prettyGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              //--- Icon Panah ---//
                              trailing: const Icon(
                                Icons.keyboard_arrow_right,
                                color: GlobalColors.grey7,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
