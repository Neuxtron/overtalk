import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtalk/api/modelDiskusi.dart';
import 'package:overtalk/api/modelUser.dart';
import 'package:overtalk/api/repository.dart';
import 'package:overtalk/bukadiskusi.dart';
import 'package:overtalk/halamandiskusi.dart';
import 'package:overtalk/setelan.dart';
import 'package:overtalk/themes/global.dart';
import 'package:overtalk/includes/draweritem.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Diskusi> dataDiskusi = [];
  Repository repository = Repository();
  String halaman = "forum";
  String judulHalaman = "OverTalk";
  List bookmarks = [];

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

  void getBookmarks() async {
    final List<User> listUsers = await repository.getUsers();
    for (var element in listUsers) {
      if (element.id == widget.user.id) {
        bookmarks = element.bookmarks;
      }
    }
  }

  void hapusDiskusi(String id) async {
    final response = await repository.hapusDiskusi(id);
    print("hai");
    if (response) {
      refresh();
      setState(() {});
    }
  }

  void refresh() {
    getDiskusi();
    getBookmarks();
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: GlobalColors().backgroundColor,

      //--- Sidebar ---//
      endDrawer: Drawer(
        backgroundColor: GlobalColors.primaryColor,
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
                color: GlobalColors.prettyBlack,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20, top: 30),
                      child: CircleAvatar(
                        backgroundColor: GlobalColors.primaryColor,
                        backgroundImage: AssetImage("assets/profile.jpg"),
                        radius: 40,
                      ),
                    ),
                    Text(
                      widget.user.nama,
                      style: TextStyle(
                        color: Colors.white,
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
                    margin: EdgeInsets.only(top: 10, bottom: 250),
                    onTap: () {
                      scaffoldKey.currentState!.closeEndDrawer();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Setelan(
                            user: widget.user,
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

      //--- AppBar ---//
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GlobalColors.primaryColor,
        title: Text(judulHalaman),
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
            child: Icon(Icons.refresh),
          ),

          //--- Buka Diskusi ---//
          FloatingActionButton(
            heroTag: "bukaDiskusi", // Biar gk error
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BukaDiskusi(
                    user: widget.user,
                  ),
                ),
              ).then((value) => refresh());
            },
            child: Icon(
              Icons.add_comment,
              size: 27,
            ),
          ),
        ],
      ),

      //--- Listview ---//
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 100),
        itemCount: dataDiskusi.length,
        itemBuilder: (context, index) {
          String id = dataDiskusi[index].id;
          String judul = dataDiskusi[index].judul;
          String pembuka = dataDiskusi[index].pembuka;
          bool tampil = false;

          String createdAt =
              DateFormat("dd MMMM yyyy").format(dataDiskusi[index].createdAt);

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
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

              //--- Dekorasi Item ---//
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: GlobalColors.primaryColor,
                    width: 1.5,
                  )),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 18),

                //--- Navigasi Item ---//
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HalamanDiskusi(
                        user: widget.user,
                        diskusi: dataDiskusi[index],
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
                    style: TextStyle(
                      color: GlobalColors().onBackground,
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
                      style: TextStyle(
                        color: GlobalColors.prettyGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),

                    //--- Created At Item ---//
                    Text(
                      createdAt,
                      style: TextStyle(
                        color: GlobalColors.prettyGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                //--- Icon Panah ---//
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: GlobalColors.grey7,
                ),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
