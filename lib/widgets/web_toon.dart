import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/screens/detail_screen.dart';

import '../model/webtoon.dart';

class Webtoon extends StatefulWidget {
  const Webtoon({
    super.key,
    required this.webtoon,
  });

  final WebToonModel webtoon;

  @override
  State<Webtoon> createState() => _WebtoonState();
}

class _WebtoonState extends State<Webtoon> {
  bool isLiked = false;

  late SharedPreferences pref;

  Future initPref() async {
    pref = await SharedPreferences.getInstance();
    final likedToons = pref.getStringList("likedToons");
    if (likedToons != null) {
      if (likedToons.contains(widget.webtoon.id)) {
        isLiked = true;
      }
      setState(() {});
    } else {
      pref.setStringList("likedToons", []);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPref();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            allowSnapshotting: false,
            builder: (context) => DetailScreen(
              webtoon: widget.webtoon,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: widget.webtoon.id,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          offset: const Offset(2, 0),
                          color: Colors.black.withOpacity(0.5),
                        )
                      ]),
                  width: 250,
                  child: Image.network(widget.webtoon.thumb),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.green[400],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.webtoon.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
