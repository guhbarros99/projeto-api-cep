import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_2/models/endereco.dart';
import 'package:projeto_2/Services/via_cep_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  TextEditingController controllerCep = TextEditingController();
  TextEditingController controllerLogradouro = TextEditingController();
  TextEditingController controllerComplemento = TextEditingController();
  TextEditingController controllerBairro = TextEditingController();
  TextEditingController controllerCidade = TextEditingController();
  TextEditingController controllerEstado = TextEditingController();
  Endereco? endereco; // Variavel pode receber null "?"
  bool isLoading = false;

  ViaCepService viaCepService = ViaCepService();

  Future<void> buscarCep(String cep) async {
    clearControllers();
    setState(() {
      isLoading = true;
    });
    try {
      Endereco? response = await viaCepService.buscarEndereco(cep);

      if (response?.localidade == null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: Icon(Icons.warning, color: Color(0x0017FFFF)),
              title: Text("Atenção"),
              content: Text("Cep não encontrado"),
            );
          },
        );
        controllerCep.clear();
        return;
      }
      setState(() {
        endereco = response;
      });

      setControllerCep(endereco!);
    } catch (erro) {
      throw Exception("Erro ao buscar CEP: $erro");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setControllerCep(Endereco endereco) {
    controllerCep.text = endereco.cep!;
    controllerLogradouro.text = endereco.logradouro!;
    controllerComplemento.text = endereco.complemento!;
    controllerBairro.text = endereco.bairro!;
    controllerCidade.text = endereco.localidade!;
    controllerEstado.text = endereco.estado!;
  }

  void clearControllers() {
    controllerLogradouro.clear();
    controllerComplemento.clear();
    controllerBairro.clear();
    controllerCidade.clear();
    controllerEstado.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(child: Icon(Icons.house, size: 100), height: 100),
              TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    clearControllers();
                  }
                  ;
                },
                controller: controllerCep,
                maxLength: 9,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          onPressed: () {
                            buscarCep(controllerCep.text);
                          },
                          icon: Icon(Icons.search),
                        ),
                  border: OutlineInputBorder(),
                  labelText: "CEP",
                ),
              ),
              TextField(
                controller: controllerLogradouro,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Logradouro",
                ),
              ),
              if(controllerComplemento.text.isNotEmpty)
              TextField(
                controller: controllerComplemento,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Complemento",
                ),
              ),
              TextField(
                controller: controllerBairro,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Bairro",
                ),
              ),
              TextField(
                controller: controllerCidade,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Cidade",
                ),
              ),
              TextField(
                controller: controllerEstado,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Estado",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
