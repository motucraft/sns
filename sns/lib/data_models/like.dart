class LikeResult {
  final List<Like> likes;
  final bool isLikedToThisPost;

  LikeResult({required this.likes, required this.isLikedToThisPost});
}

class Like {
  String likeId;
  String postId;
  String likeUserId;
  DateTime likeDateTime;

//<editor-fold desc="Data Methods">

  Like({
    required this.likeId,
    required this.postId,
    required this.likeUserId,
    required this.likeDateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Like &&
          runtimeType == other.runtimeType &&
          likeId == other.likeId &&
          postId == other.postId &&
          likeUserId == other.likeUserId &&
          likeDateTime == other.likeDateTime);

  @override
  int get hashCode =>
      likeId.hashCode ^
      postId.hashCode ^
      likeUserId.hashCode ^
      likeDateTime.hashCode;

  @override
  String toString() {
    return 'Like{' +
        ' likeId: $likeId,' +
        ' postId: $postId,' +
        ' likeUserId: $likeUserId,' +
        ' likeDateTime: $likeDateTime,' +
        '}';
  }

  Like copyWith({
    String? likeId,
    String? postId,
    String? likeUserId,
    DateTime? likeDateTime,
  }) {
    return Like(
      likeId: likeId ?? this.likeId,
      postId: postId ?? this.postId,
      likeUserId: likeUserId ?? this.likeUserId,
      likeDateTime: likeDateTime ?? this.likeDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'likeId': this.likeId,
      'postId': this.postId,
      'likeUserId': this.likeUserId,
      'likeDateTime': this.likeDateTime.toUtc().toIso8601String(),
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      likeId: map['likeId'] as String,
      postId: map['postId'] as String,
      likeUserId: map['likeUserId'] as String,
      likeDateTime: DateTime.parse(map['likeDateTime'] as String).toLocal(),
    );
  }

//</editor-fold>
}
