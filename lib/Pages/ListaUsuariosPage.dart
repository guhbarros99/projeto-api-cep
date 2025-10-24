import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Importe seu modelo de usuário se quiser converter os dados
// import 'package:projeto_2/Models/user_model.dart';

class ListaUsuariosPage extends StatelessWidget {
  ListaUsuariosPage({Key? key}) : super(key: key);

  // 1. Crie a referência do Stream para a coleção 'usuarios'
  final Stream<QuerySnapshot> _usuariosStream = FirebaseFirestore.instance
      .collection('usuarios')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Usuários")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usuariosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // 2. Trate o estado de erro
          if (snapshot.hasError) {
            return Center(child: Text('Algo deu errado: ${snapshot.error}'));
          }

          // 3. Trate o estado de carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 4. Verifique se há dados, mas a lista está vazia
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum usuário cadastrado.'));
          }

          // 5. Se tudo deu certo e tem dados, construa a lista
          if (snapshot.hasData) {
            // Usar ListView.builder é mais eficiente para listas longas
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // Pega o documento atual
                DocumentSnapshot document = snapshot.data!.docs[index];

                // Pega os dados do documento como um Map
                // O 'as Map<String, dynamic>' é importante
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                // --- Opcional: Converter para seu Model ---
                // Se seu User.model tiver um factory constructor tipo `User.fromMap(map, id)`
                // User user = User.fromMap(data, document.id);
                // ------------------------------------------

                // Exibindo os dados do Map diretamente
                String nome = data['nome'] ?? 'Nome não informado';
                String email = data['email'] ?? 'Email não informado';
                String telefone = data['telefone'] ?? 'Telefone não informado';
                String cpf = data['cpf'] ?? 'CPF não informado';
                String primeiraLetra = nome.isNotEmpty
                    ? nome[0].toUpperCase()
                    : '?';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(primeiraLetra),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    subtitle: Row(
                      children: [
                        Column(children: [ Text(" Nome: gi${nome}"), Text(email), Text(telefone), Text(cpf) ]),
                      ],
                    ),

                    onTap: () {
                      // Aqui você pode adicionar uma ação ao clicar,
                      // como navegar para uma tela de detalhes do usuário
                      print('Clicou no usuário: ${document.id}');
                    },
                  ),
                );
              },
            );
          }

          // Estado padrão (embora os outros devam cobrir)
          return Center(child: Text("Carregando..."));
        },
      ),
    );
  }
}
