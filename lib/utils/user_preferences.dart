import 'package:cs310group1/model/users.dart';



//static implementation of user, wont be needed when we easily and succesfully fetch all the information from firestore
// done for view trying purposes


class UserPreferences {
  static const myUser = Userz(
    id: "123421",
    username: "smth",
    imagePath: 'https://ih1.redbubble.net/image.1046392278.3346/pp,840x830-pad,1000x1000,f8f8f8.jpg',
    name :'DEFAULT PERSON',
    email: 'defaultIAm@sabanciuniv.edu',
    about: 'A default person just for trying our CS310 project',
  );

}