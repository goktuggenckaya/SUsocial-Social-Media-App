class myUser{
  final String? user_id;
  final String? username;
  final String? name;
  final String? email;
  final String? about;
  final String? image_path;
  final List? following;
  final List? followers;

  myUser(this.user_id, this.username, this.about, this.email, this.image_path, this.name, this.followers, this.following);
}