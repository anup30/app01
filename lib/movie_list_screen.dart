import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance; // https://firebase.google.com/docs/storage/flutter/start
  final List<Movie> movieList =[];
  @override
  void initState() {
    super.initState();
    _getMovieList();
  }
  void _getMovieList(){
    _firebaseFirestore.collection('movies').get().then((value){ // <--- where from ? , class 2, Getting all documents from one collection
      //print(value); //Instance of '_JsonQuerySnapshot'
      movieList.clear();
      for(QueryDocumentSnapshot doc in value.docs){ // or var doc, class 2 <---
        print(doc.data()); // prints my firestore 'movies' data
        movieList.add(
            Movie.fromJson(doc.id, doc.data() as Map<String,dynamic>)
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movies"),backgroundColor: Colors.blue),
      body: ListView.separated(
        itemCount: movieList.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text(movieList[index].name),
            subtitle: Text(movieList[index].languages),
            leading: Text(movieList[index].rating),
            trailing: Text(movieList[index].year),
          );
        },
        separatorBuilder:(_,__)=> const Divider(),
      ),
    );
  }
}

class Movie{  // model/pojo class
  final String id, name, languages, year, rating, earning;
  Movie({
    required this.id,
    required this.name,
    required this.languages,
    required this.year,
    required this.rating,
    required this.earning,
  });
  factory Movie.fromJson(String id, Map<String, dynamic> json){
    return Movie(
        id: id,
        name: json['name'],
        languages: json['languages'],
        year: json['year'],
        rating: json['rating'],
        earning: json['earning']??'Unknown',
    );
  }
}