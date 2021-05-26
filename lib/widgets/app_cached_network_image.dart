import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String imageURL;
  final BoxFit fit;
  final Color color;
  AppCachedNetworkImage({
    this.imageURL,
    this.fit,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: color == null ? null : color,
          image: DecorationImage(
            image: imageProvider,
            fit: fit == null ? BoxFit.fill : fit,
          ),
        ),
      ),
      placeholder: (context, url) => const SizedBox(
        child: const CircularProgressIndicator(),
        width: 10,
        height: 10,
      ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/icons/more.png',
        fit: BoxFit.fill,
      ),
    );
  }
}
