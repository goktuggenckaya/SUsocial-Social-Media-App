class Users{
  final bool private;
  final bool disabled;
  final String? user_id;
  final String? about;
  final String? email;
  late final List? followers;
  late final List? following;
  final List? pendingfollowers;
  final String? image_path;
  final String? name;
  final String? username;
  Users(this.user_id, this.about, this.email, this.followers, this.following, this.image_path, this.name,this.username, this.pendingfollowers, this.private, this.disabled);
}