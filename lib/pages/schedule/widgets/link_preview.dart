import 'package:flutter/material.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreviewTile extends StatefulWidget {
  final String url;

  LinkPreviewTile({Key? key, required this.url}) : super(key: key);

  @override
  _LinkPreviewTileState createState() => _LinkPreviewTileState();
}

class _LinkPreviewTileState extends State<LinkPreviewTile> {
  late Future<WebInfo> future;

  @override
  void initState() {
    super.initState();
    future = LinkPreview.scrapeFromURL(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<WebInfo> snapshot) {
          bool errorOrNull = snapshot.hasError || snapshot.data == null;
          bool isReady = snapshot.hasData && !errorOrNull;
          return Card(
            child: ListTile(
              onTap: () async {
                if (await canLaunch(widget.url))
                  await launch(widget.url);
                else
                  print("Cant launch");
              },
              leading: SizedBox(
                width: 50,
                height: 50,
                child: isReady
                    ? Image.network(snapshot.data!.icon)
                    : Icon(Icons.link, size: 30),
              ),
              title: isReady ? Text(snapshot.data!.title) : Text("Link laden"),
              subtitle: isReady ? Text(snapshot.data!.domain) : Text(Uri.parse(widget.url).host),
              trailing: Icon(Icons.open_in_new),
            ),
          );
        });
  }
}
