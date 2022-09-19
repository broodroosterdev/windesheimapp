import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreviewTile extends StatefulWidget {
  final String url;

  const LinkPreviewTile({Key? key, required this.url}) : super(key: key);

  @override
  _LinkPreviewTileState createState() => _LinkPreviewTileState();
}

class _LinkPreviewTileState extends State<LinkPreviewTile> {
  late Future<WebInfo> future;
  late Uri uri;

  @override
  void initState() {
    super.initState();
    uri = Uri.parse(widget.url);
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
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  developer.log("Cant launch ${widget.url}",
                      time: DateTime.now(),
                      name: "link_preview -> ListTile.onTap");
                }
              },
              leading: SizedBox(
                width: 50,
                height: 50,
                child: isReady
                    ? Image.network(snapshot.data!.icon)
                    : const Icon(Icons.link, size: 30),
              ),
              title: isReady
                  ? Text(snapshot.data!.title != ""
                      ? snapshot.data!.title
                      : "Link openen")
                  : const Text("Link laden"),
              subtitle: isReady ? Text(snapshot.data!.domain) : Text(uri.host),
              trailing: const Icon(Icons.open_in_new),
            ),
          );
        });
  }
}
