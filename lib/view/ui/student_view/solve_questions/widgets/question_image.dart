import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class QuestionImage extends StatelessWidget {
  final String? img;
  const QuestionImage(this.img, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: img == null ? false : true,
      child: InteractiveViewer(
        child: CachedNetworkImage(
          imageUrl: img ?? '',
          progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
            padding: const EdgeInsets.all(10),
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            size: 30,
          ),
        ),
      ),
    );
  }
}
