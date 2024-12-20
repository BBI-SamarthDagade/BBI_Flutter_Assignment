// import 'package:flutter/material.dart';

// class ArticleCard extends StatelessWidget {
//   final dynamic article;
//   final String placeholderImage;

//   const ArticleCard({
//     Key? key,
//     required this.article,
//     this.placeholderImage = 'https://via.placeholder.com/150',
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//          color: Theme.of(context).cardColor,
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             offset: Offset(2, 2),
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(15.0),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: Image.network(
//             article.urlToImage ?? placeholderImage,
//             width: 60,
//             height: 60,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return Image.network(
//                 placeholderImage,
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//               );
//             },
//           ),
//         ),
//         title: Text(
//           article.title ?? 'No Title',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16.0,
//             color: Theme.of(context).textTheme.bodyLarge?.color,
//           ),
//         ),
//         subtitle: Text(
//           article.description ?? 'No Description',
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color: Theme.of(context).textTheme.bodyMedium?.color,
//           ),
//         ),
//         onTap: () {
//           // Add navigation to a detailed view here if needed
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ArticleCard extends StatefulWidget {
  final dynamic article;
  final String placeholderImage;

  const ArticleCard({
    Key? key,
    required this.article,
    this.placeholderImage = 'https://via.placeholder.com/150',
  }) : super(key: key);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isExpanded = false; // Track the expanded/collapsed state
  FocusNode _focusNode = FocusNode(); // Create a FocusNode to manage focus
  bool _showTooltip = false; // Variable to control tooltip visibility

  @override
  void initState() {
    super.initState();
    // Add a listener to show tooltip when the card gains focus
    _focusNode.addListener(() {
      setState(() {
        _showTooltip = _focusNode.hasFocus; // Update tooltip visibility
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on the current theme
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Colors.grey[850] : Colors.white;
    final shadowColor = isDarkTheme ? Colors.black45 : Colors.black26;
    final textColor = isDarkTheme ? Colors.white : Colors.black;

    return Focus(
      focusNode: _focusNode, // Assign the FocusNode
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // Toggle expanded state
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(10.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.article.urlToImage ?? widget.placeholderImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            widget.placeholderImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    title: Text(
                      widget.article.title ?? 'No Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      widget.article.description ?? 'No Description',
                      maxLines:
                          _isExpanded ? null : 2, // Show full text if expanded
                      overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    const SizedBox(
                        height: 8.0), // Space before the expanded content
                  Center(
                    child: IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded; // Toggle expanded state
                        });
                      },
                    ),
                  ),
                  // Show tooltip below the card when focused
                  if (_showTooltip)
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Tooltip(
                        message: 'Click to see more',
                        preferBelow: true,
                        child:
                            Container(), // Dummy container for tooltip to display
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
