import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:wind/model/news_item.dart';
import 'package:wind/pages/news/widgets/news_tile.dart';
import 'package:wind/pages/news/widgets/skeleton_news_tile.dart';
import 'package:wind/pages/widgets/app_drawer.dart';
import 'package:wind/services/api/news.dart';

import 'news_item_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<NewsItem>> future;

  @override
  void initState() {
    super.initState();
    future = News.getNewsItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nieuws')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: future,
        builder:
            (BuildContext context, AsyncSnapshot<List<NewsItem>> snapshot) {
          bool loading = !snapshot.hasData;
          //loading = true;
          if(loading){
            return skeletonView();
          } else {
            return loadedView(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget loadedView(List<NewsItem> items){
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final NewsItem item = items[index];

        return OpenContainer(
          closedColor: Colors.transparent,
          closedBuilder: (BuildContext context, VoidCallback open){
            return NewsTile(item);
          },
          openBuilder: (BuildContext context, _) {
            return NewsItemPage(item, key: Key(item.id));
          },
        );
      },
    );
  }

  Widget skeletonView(){
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int _){
          return SkeletonNewsTile();
        }
    );
  }

  /*Widget skeletonItem(BuildContext context){
    return SkeletonListTile(
      padding: EdgeInsets.only(left: 1, right: 1, bottom: 6, top: 6),
      leadingStyle: ,
      titleStyle: const SkeletonLineStyle(randomLength: false, width: 220),
      subtitleStyle: const SkeletonLineStyle(randomLength: false, width: 150),
      hasSubtitle: true,
    );
  }*/
}
