import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newzia/constant.dart';
import 'package:newzia/helpers/published_time.dart';
import 'package:newzia/screens/arcticle_view.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({
    super.key,
    required this.articleTitle,
    required this.articleSource,
    required this.articleUrl,
    required this.imageUrl,
    required this.isBookmarked,
    required this.publishAt,
    required this.onPressed,
  });

  final String articleUrl, imageUrl, articleSource, articleTitle, publishAt;
  final bool isBookmarked;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: kNewziaGray, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: 80,
              height: 100,
              margin: const EdgeInsets.only(right: 10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                key: UniqueKey(),
                cacheManager: CacheManager(
                    Config('key', stalePeriod: const Duration(days: 1))),
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From $articleSource',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: kNewziaLynch,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    articleTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: kNewziaBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        PublishAt.getPublishTime(publishAt),
                        style:
                            const TextStyle(color: kNewziaLynch, fontSize: 11),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        tooltip: isBookmarked
                            ? 'Remove from bookmark'
                            : 'Add to bookmark',
                        onPressed: onPressed,
                        icon: isBookmarked
                            ? const Icon(
                                Icons.bookmark_remove_outlined,
                                size: 20,
                                color: kNewziaRed,
                              )
                            : const Icon(
                                Icons.bookmark_added_rounded,
                                size: 20,
                                color: kNewziaRed,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
