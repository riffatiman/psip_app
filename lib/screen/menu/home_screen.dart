import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:psip_app/model/user_model.dart';
import 'package:psip_app/screen/menu/tribun%20menu/select_tribun.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      user = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 90,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            title: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Selamat datang,\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text:
                        snapshot.data!['displayName'].toUpperCase() ?? '******',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Color.fromRGBO(196, 13, 15, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(
                    FluentIcons.cart_24_filled,
                    color: Color.fromRGBO(196, 13, 15, 1),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Jadwal',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('match')
                    .where(
                      'dateTime',
                      isGreaterThan: DateFormat('yyyy-MM-dd HH:mm').format(
                        DateTime.now().add(
                          const Duration(hours: 12),
                        ),
                      ),
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 10,
                            child: const Center(
                              child: Text('Belum ada jadwal pertandingan'),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                if (snapshot.hasData) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      bottom: 10,
                                    ),
                                    height: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              1), // Adjust shadow color and opacity
                                          blurRadius: 1,
                                          spreadRadius: -0.5,
                                          offset: const Offset(0,
                                              1.5), // Adjust the position of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('logo')
                                                .doc(snapshot.data!.docs[index]
                                                    ['home'])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(
                                                      snapshot.data!['logoUrl'],
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4.5,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '${snapshot.data!['nameTeam']}\n${snapshot.data!['homeTown']}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        height: 0.9,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['event'],
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    196, 13, 15, 1),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('EEEE, dd MMMM yyyy',
                                                      'id')
                                                  .format(
                                                DateFormat('yyyy-MM-dd HH.mm',
                                                        'id')
                                                    .parse(
                                                  snapshot.data!.docs[index]
                                                      ['dateTime'],
                                                ),
                                              ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              'KICK OFF',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    196, 13, 15, 1),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('HH:mm WIB', 'id')
                                                  .format(
                                                DateFormat('yyyy-MM-dd HH.mm',
                                                        'id')
                                                    .parse(
                                                  snapshot.data!.docs[index]
                                                      ['dateTime'],
                                                ),
                                              ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            ElevatedButton(
                                              onPressed: snapshot
                                                              .data!.docs[index]
                                                          ['open'] ==
                                                      false
                                                  ? null
                                                  : () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return SelectTribun(
                                                              data: snapshot
                                                                  .data!
                                                                  .docs[index],
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                disabledBackgroundColor:
                                                    const Color.fromRGBO(
                                                        196, 13, 15, 0.5),
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        196, 13, 15, 1),
                                                fixedSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  40,
                                                ),
                                              ),
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                            ['open'] ==
                                                        false
                                                    ? 'SEGERA'
                                                    : 'BELI TIKET',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('logo')
                                                .doc(snapshot.data!.docs[index]
                                                    ['away'])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(
                                                      snapshot.data!['logoUrl'],
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4.5,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '${snapshot.data!['nameTeam']}\n${snapshot.data!['homeTown']}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        height: 0.9,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
