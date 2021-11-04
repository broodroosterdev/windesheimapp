import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wind/utils/html_transform.dart';

class FileEmbedElementPart extends StatelessWidget {
  final FileEmbedElement element;

  const FileEmbedElementPart(this.element, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          if (await canLaunch(element.url)) {
            await launch(element.url);
          }
        },
        leading: Icon(Icons.insert_drive_file, size:24),
        title: Text(
          element.filename,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        subtitle: Text(
          element.url,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        trailing: Icon(Icons.open_in_new),

      )
    );
  }
}
