 
import 'package:firebase_auth/firebase_auth.dart';
 
class User{
 
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String senha;
 
  User({required this.id, required this.nome, required this.email, required this.telefone, required this.cpf, required this.senha});
 
 
 Map<String,dynamic> toMap(){
   return {
    "nome": nome,
    "email": email,
    "telefone": telefone,
    "cpf": cpf,
    "senha": senha
   };
 }
 
 factory User.fromap(Map<String,dynamic> map, String id){
  return User(
    id: id,
    nome: map["nome"],
    email: map["email"],
    telefone: map["telefone"],
    senha: map["senha"],
    cpf: map["cpf"],
   
  );
 }
 
}