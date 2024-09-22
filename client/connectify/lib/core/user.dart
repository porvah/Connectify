final String tableUser = 'user';
final String columnId = 'id';
final String columnEmail = 'email';
final String columnPhone = 'phone';
final String columnLogged = 'logged';
final String columnToken = 'token';
class User{
  int? id;
  String? email;
  String? phone;
  int? logged;
  String? token;


  User(this.email, this.phone, this.logged);


  Map<String, Object?> toMap(){
    Map<String, Object?> map = <String, Object?>{
      columnEmail: email,
      columnPhone: phone,
      columnLogged: logged
    };
    if(id != null){
      map[columnId] = id;
    }
    if(token != null){
      map[columnToken] = token;
    }
    return map;
  }

  
  User.fromMap(Map<String, Object?> map){
    id = map[columnId] as int;
    email = map[columnEmail] as String;
    phone = map[columnPhone] as String;
    logged = map[columnLogged] as int;
  }
}