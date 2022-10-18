import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

enum ContentStatus { none, loading, loaded }

class ContentState extends Equatable {
  final ContentStatus contentStatus;

  final Map? contents;

  ContentState({
    required this.contentStatus,
    this.contents,
  });

  factory ContentState.unknown() {
    return ContentState(contentStatus: ContentStatus.none);
  }

  @override
  List<Object?> get props => [contentStatus, contents];

  @override
  bool get stringify => true;

  ContentState copyWith({
    ContentStatus? contentStatus,
    Map? contents,
  }) {
    return ContentState(
      contentStatus: contentStatus ?? this.contentStatus,
      contents: contents ?? this.contents,
    );
  }
}
