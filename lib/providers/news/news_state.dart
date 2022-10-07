import 'package:equatable/equatable.dart';

import '../../models/news_model.dart';

class NewsState extends Equatable {
  final List<News> newsList;
  final bool watched;

  NewsState({required this.newsList, this.watched = true});

  factory NewsState.initial() {
    return NewsState(newsList: [], watched: true);
  }

  @override
  List<Object?> get props => [newsList];

  @override
  bool? get stringify => true;

  NewsState copyWith({List<News>? newsList, bool? watched}) {
    return NewsState(
        newsList: newsList ?? this.newsList, watched: watched ?? this.watched);
  }
}
