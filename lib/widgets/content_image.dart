import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ContentImage extends StatelessWidget {
  final String url;

  ContentImage({this.url});

  @override
  Widget build(BuildContext context) {
    return this.url != null
        ? CachedNetworkImage(
            useOldImageOnUrlChange: true,
            // maxWidthDiskCache: 400,
            // memCacheWidth: 400,
            imageUrl: this.url != null ? this.url : '',
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                // child: Image.asset(
                //   'assets/placeholders/content_placeholder_grey_v.jpg',
                //   gaplessPlayback: true,
                //   fit: BoxFit.cover,
                // ),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                // child: Image.asset(
                //   'assets/placeholders/content_placeholder_grey_v.jpg',
                //   gaplessPlayback: true,
                //   fit: BoxFit.cover,
                // ),
              );
            },
          )
        : Container(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey[200],
              // child: Image.asset(
              //   'assets/placeholders/content_placeholder_grey_v.jpg',
              //   gaplessPlayback: true,
              //   fit: BoxFit.cover,
              // ),
            ),
          );
  }
}
