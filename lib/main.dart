import 'dart:math';

import 'package:facebook_clone/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xff2f477a),
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(App());
}

const Color facebookBlue = Color(0xff4267b2);
const Color borderGrey = Color(0xffdcdee3);
const String avatarUrl =
    "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png";

const List<String> storiesImgs = [
  "https://images.unsplash.com/photo-1491753122500-3047f3d7270e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
  "https://images.unsplash.com/photo-1566178077342-300aa756792e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=613&q=80",
  "https://images.unsplash.com/photo-1566206199489-f6604b30c0b1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
  "https://images.unsplash.com/photo-1566205190430-536f5c93d8ca?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
];

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalKey _key1;

  @override
  void initState() {
    _key1 = GlobalKey();

    tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () =>
              Future.delayed(Duration(seconds: 1), () => this.setState(() {})),
          child: CustomScrollView(
            slivers: <Widget>[
              buildSliverAppBar(),
              buildUserInputAndStories(),
              FeedPage(),
            ],
          ),
        )),
      ),
    );
  }

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      backgroundColor: facebookBlue,
      bottom: buildTabBar(),
      titleSpacing: 0,
      forceElevated: false,
      elevation: 1,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(Icons.camera_alt, color: Colors.white, size: 22),
          ),
          Container(
            width: 300,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: borderGrey),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 19,
                ),
                contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: notification(SvgPicture.asset(
              "assets/messenger.svg",
              width: 22,
              height: 22,
              color: Colors.white,
            )),
          ),
        ],
      ),
    );
  }

  Stack notification(Widget backChild) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        backChild,
        Positioned(
          left: 14,
          bottom: 10,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${Random().nextInt(25) + 1}',
                style: TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  SliverList buildUserInputAndStories() {
    return SliverList(
      key: _key1,
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17.5),
                    border: Border.all(color: Color(0xffededed), width: 1),
                    image: DecorationImage(
                      image: NetworkImage(
                        avatarUrl,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "What's on your mind",
                        hintStyle: TextStyle(color: Color(0xff26303b)),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffacacac)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/gallery.svg",
                      width: 20,
                      height: 20,
                      color: Color(0xff26303b),
                    ),
                    Text("Photo", style: TextStyle(color: Color(0xff26303b))),
                  ],
                )
              ],
            ),
          ),
          buildFeedStories(),
        ],
      ),
    );
  }

  Container buildFeedStories() {
    return Container(
      color: borderGrey,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 170,
        child: Container(
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(5, (index) {
              final storieImg = storiesImgs[Random().nextInt(storiesImgs.length)];
              return Container(
                width: 90,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: NetworkImage(index == 0 ? avatarUrl : storieImg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildStoriesAvatar(index),
                    Container(
                      margin: const EdgeInsets.only(left: 5, bottom: 5),
                      child: Text(
                        index == 0 ? "Add to Story" : 'User $index',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  PreferredSize buildTabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: Container(
        color: Colors.white,
        child: TabBar(
          controller: tabController,
          labelColor: Color(0xff3f4b58),
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: SvgPicture.asset(
                "assets/feed.svg",
                width: 22,
                height: 22,
                color: Color(0xff3f4b58),
              ),
            ),
            Tab(
              icon: SvgPicture.asset("assets/friends.svg",
                  width: 22, height: 22, color: Color(0xff3f4b58)),
            ),
            Tab(
              icon: notification(Icon(Icons.live_tv)),
            ),
            Tab(
              icon: SvgPicture.asset("assets/notification.svg",
                  width: 21, height: 21, color: Color(0xff3f4b58)),
            ),
            Tab(
              icon: Icon(Icons.menu),
            ),
          ],
        ),
      ),
    );
  }

  Container buildStoriesAvatar(final int index) {
    final isUserStories = index == 0;
    return Container(
      margin: const EdgeInsets.only(left: 5, top: 5),
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        border: !isUserStories ? Border.all(color: facebookBlue, width: 2) : null,
        color: isUserStories ? Colors.white : null,
        shape: BoxShape.circle,
      ),
      child: isUserStories
          ? Icon(
              Icons.add,
              color: facebookBlue,
              size: 25,
            )
          : Padding(
              padding: const EdgeInsets.all(1),
              child: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
            ),
    );
  }
}

class FeedPage extends StatelessWidget {
  final _key2 = GlobalKey();
  final List<String> _feedImgs = [
    "https://images.unsplash.com/photo-1465189684280-6a8fa9b19a7a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1464039397811-476f652a343b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1348&q=80",
    "https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
    "https://images.unsplash.com/photo-1502657877623-f66bf489d236?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjIyNjY2fQ&auto=format&fit=crop&w=1350&q=80",
    "https://images.unsplash.com/photo-1494253188410-ff0cdea5499e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjExMzk2fQ&auto=format&fit=crop&w=1350&q=80",
    "https://images.unsplash.com/photo-1502481851512-e9e2529bfbf9?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
  ];

  final List<String> _reactions = [
    "assets/like.png",
    "assets/sad.png",
    "assets/love.png",
    "assets/grr.png",
    "assets/wow.png",
    "assets/haha.png",
  ];

  @override
  Widget build(BuildContext context) {
    return SliverList(
      key: _key2,
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final isGroupPost = Random().nextInt(2) == 1;
          final photo = Random().nextInt(2) == 1;
          final user = usernames[Random().nextInt(usernames.length)];
          final group = groups[Random().nextInt(groups.length)];

          return buildFeedPost(user,
              "Fugiat tempor qui occaecat adipisicing eiusmod aliqua quis occaecat. Excepteur laboris exercitation aliqua excepteur et incididunt ut eu irure est consectetur quis. Ullamco fugiat ullamco anim exercitation Lorem aute velit deserunt proident amet Lorem. Minim incididunt nostrud adipisicing reprehenderit labore eu commodo aute Lorem veniam duis.",
              isGroupPost: isGroupPost, groupName: group, photo: photo);
        },
      ),
    );
  }

  Widget buildFeedPost(
    final String username,
    final String text, {
    final bool isGroupPost = false,
    final String groupName,
    final bool photo,
  }) {
    final photoUrl = _feedImgs[Random().nextInt(_feedImgs.length)];
    final postReactions =
        List.generate(3, (_) => _reactions[Random().nextInt((5))]).toSet().toList();
    final showComment = Random().nextInt(200) % 2 == 1;

    return Container(
      color: borderGrey,
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                    radius: 18,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...(isGroupPost
                            ? [
                                Icon(
                                  Icons.play_arrow,
                                  size: 15,
                                  color: Color(0xff9197a3),
                                ),
                                Text(
                                  groupName,
                                  softWrap: true,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ]
                            : [Container()]),
                      ],
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Text('${Random().nextInt(59) + 1} min'),
                        SizedBox(width: 3),
                        Icon(
                          Icons.brightness_1,
                          size: 4,
                          color: Color(0xff46515d),
                        ),
                        SizedBox(width: 3),
                        Icon(
                          Icons.public,
                          size: 14,
                          color: Color(0xff46515d),
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.only(left: 9),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 14, right: 9),
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(
                text,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.left,
              ),
            ),
            photo
                ? SizedBox(
                    height: 300,
                    child: Image.network(
                      photoUrl,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : Container(),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  buildPostReactions(postReactions),
                  Text(
                    '${Random().nextInt(300)} Comments  ${Random().nextInt(300)} Shares',
                  )
                ],
              ),
            ),
            Divider(color: borderGrey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset("assets/thumb-up.svg", width: 20, height: 20),
                    // Icon(Icons.thumb_up),
                    SizedBox(width: 6),
                    Text("Like")
                  ],
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset("assets/comment.svg", width: 20, height: 20),
                    SizedBox(width: 6),
                    Text("Comment")
                  ],
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset("assets/share.svg", width: 20, height: 20),
                    SizedBox(width: 6),
                    Text("Share")
                  ],
                ),
              ],
            ),
            ...(showComment
                ? [Divider(color: borderGrey), buildPostComment()]
                : [Container()]),
          ],
        ),
      ),
    );
  }

  Container buildPostComment() {
    final user = usernames[Random().nextInt(usernames.length)];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 16,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xfff2f3f5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: '$user\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "Proident tempor occaecat ad ea cillum aute excepteur sunt excepteur est in sit. Nisi voluptate do id pariatur esse ex cupidatat veniam nostrud minim eu. Do aute cillum qui irure officia qui duis adipisicing sit amet consequat. Pariatur consectetur eiusmod mollit sunt esse ullamco quis sunt dolor anim est dolore aute.",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 9),
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 16,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: 40,
                  child: TextField(
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      hintStyle: TextStyle(color: Color(0xff4e5762)),
                      filled: true,
                      fillColor: Color(0xfff2f3f5),
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          SizedBox(width: 10),
                          Icon(Icons.sentiment_satisfied),
                          SizedBox(width: 10),
                        ],
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Row buildPostReactions(List<String> postReactions) {
    int i = 0;
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ...postReactions
                .map<Widget>(
                  (reaction) => Container(
                    margin: EdgeInsets.only(left: i++ * 11.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    width: 15,
                    height: 15,
                    child: Image.asset(reaction),
                  ),
                )
                .toList()
                .reversed,
          ],
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          '${Random().nextInt(300) + 15}',
        ),
      ],
    );
  }
}
