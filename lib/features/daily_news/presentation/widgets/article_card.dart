import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final dynamic article;
  final String placeholderImage;

  const ArticleCard({
    Key? key,
    required this.article,
    this.placeholderImage = 'https://via.placeholder.com/150',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
         color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            article.urlToImage ?? placeholderImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                placeholderImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        title: Text(
          article.title ?? 'No Title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          article.description ?? 'No Description',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        onTap: () {
          // Add navigation to a detailed view here if needed
        },
      ),
    );
  }
}

