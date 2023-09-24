class Post{
  final String? post_id;
  final String? user_id;
  final String? caption;
  final String? image_link;
  final List? like_id;
  final List? comments;
  final dynamic date;
  final String? reshared_by;

  Post(this.post_id, this.like_id, this.image_link, this.comments, this.user_id, this.caption, this.date, this.reshared_by);
}