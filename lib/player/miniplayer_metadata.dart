import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//MiniPlayer data
class MiniplaterMetadata extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;
  final String studio;

  const MiniplaterMetadata({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.studio,
  });

  @override
  Widget build(BuildContext context) {
    //Take the screen size to adjust on Tablet and Smartphone
    double deviceHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 4),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: deviceHeight > 816.0 ? 80 : 60,
              width: deviceHeight > 816.0 ? 80 : 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: deviceHeight > 816.0 ? 400 : 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: deviceHeight > 816.0 ? 20 : 14,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                artist,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: deviceHeight > 816.0 ? 18 : 14,
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
