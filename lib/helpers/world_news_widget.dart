import 'package:flutter/material.dart';
import 'package:newzia/constant.dart';
import 'package:newzia/helpers/published_time.dart';
import 'package:newzia/screens/arcticle_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class WorldNewsView extends StatelessWidget {
  const WorldNewsView({
    super.key,
    required this.title,
    required this.articleUrl,
    required this.isBookmarked,
    required this.source,
    required this.urlToImage,
    required this.publishAt,
    required this.onPressed,
  });
  final String articleUrl, urlToImage, title, source, publishAt;
  final void Function() onPressed;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(
                articleUrl: articleUrl,
              ),
            ),
          );
        },
        child: Stack(children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: CachedNetworkImage(
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              key: UniqueKey(),
              cacheManager: CacheManager(
                  Config('key', stalePeriod: const Duration(days: 1))),
              imageUrl: urlToImage,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  kNewziaBlue.withOpacity(1),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kNewziaRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: onPressed,
                            icon: isBookmarked
                                ? const Icon(
                                    Icons.bookmark_remove_outlined,
                                    color: kNewziaSurfaceWhite,
                                  )
                                : const Icon(
                                    Icons.bookmark_added_rounded,
                                    color: kNewziaSurfaceWhite,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Text(
                      maxLines: 3,
                      title,
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: kNewziaSurfaceWhite,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'From $source',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: kNewziaSurfaceWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          PublishAt.getPublishTime(publishAt),
                          style: TextStyle(
                            color: kNewziaBackgroundWhite,
                            fontSize:
                                Theme.of(context).textTheme.bodySmall!.fontSize,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
