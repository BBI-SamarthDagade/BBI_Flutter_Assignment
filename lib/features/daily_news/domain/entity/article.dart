import 'package:equatable/equatable.dart';

class Article extends Equatable{

  final String? title; 
  final String? description;
  final String? urlToImage;

  
  const Article({
     this.title,
     this.description,
     this.urlToImage,
    
  });
  
  factory Article.fromJson(Map<String, dynamic> map){
     return Article(
        title : map['title'] ?? " ",
        description : map['description'] ?? " ",
        urlToImage: map['urlToImage'] ?? " ",
     );
  }

  //add all the paramaters we want to compart by Equatable
  @override
  // TODO: implement props
  List<Object?> get props {
      return [
      title,
      description,
      urlToImage,
    ];
  }
}