import 'package:flutter/material.dart';
import 'package:projeto_2/Services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'package:projeto_2/services/via_cep_service.dart';
import 'package:projeto_2/models/endereco.dart';

class ConnectivityPage extends StatefulWidget {
  const ConnectivityPage({super.key});

  @override
  State<ConnectivityPage> createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  bool _buscando = false;

  Future<void> _buscarCep() async {
    final connectivityService = Provider.of<ConnectivityService>(
      context,
      listen: false,
    );

    setState(() {
      _buscando = true;
    });

    bool temInternet = await connectivityService.checkconnectivity();

    if (temInternet) {
      print("✅ Conectado — buscando na API...");
    } else {
      print("⚠️ Sem internet — buscando no cache...");
    }

    setState(() {
      _buscando = false;
    });
  }
    final _cepController = TextEditingController();
  final _viaCepService = ViaCepService();

Endereco? _endereco;
  bool _isLoading = false;
  String? _erro;

  final List<Endereco> _historico = [];

  Future<void> _buscarEndereco() async {
    final cep = _cepController.text.trim();

    if (cep.isEmpty) {
      setState(() {
        _erro = 'Digite um CEP válido.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _erro = null;
      _endereco = null;
    });

    try {
      final endereco = await _viaCepService.buscarEndereco(cep);

      if (endereco != null) {
        setState(() {
          _endereco = endereco;

          if (!_historico.any((e) => e.cep == endereco.cep)) {
            _historico.insert(0, endereco); 
          }
        });
      } else {
        setState(() {
          _erro = 'CEP não encontrado.';
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro ao buscar o CEP.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _limparHistorico() {
    setState(() {
      _historico.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    final connectivityService = Provider.of<ConnectivityService>(
      context,
      listen: false,
    );

    return StreamBuilder<bool>(
      stream: connectivityService.connectivityStream.map((e) => e as bool),
      initialData: true,
      builder: (context, snapshot) {
        final bool temInternet = snapshot.data ?? true;

        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Status de CeP',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Row(
                  children: [
                    Text(
                      temInternet ? "Online" : "Offline",
                      style: TextStyle(
                        color: temInternet ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      temInternet ? Icons.wifi : Icons.wifi_off,
                      color: temInternet ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _cepController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Digite o cep',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _isLoading ? null : _buscarEndereco,
                child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Buscar'),
                ), 
                const SizedBox(height: 24),
                if (_erro != null)
                Text(_erro!,
                style: const TextStyle(color: Colors.red),
                ),
                if(_endereco != null)
                Card(
                  child: ListTile(
                    title: Text('${_endereco!.logradouro}, ${_endereco!.bairro}'),
                    subtitle: Text('${_endereco!.localidade} - ${_endereco!.uf}\nCEP: ${_endereco!.cep}'),
                  ),
                ), 
                const SizedBox(height: 16),
                const Divider(),
                Expanded (
                child: _historico.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum histórico de busca ainda.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _historico.length,
                      itemBuilder: (context, index) {
                        final e = _historico[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text('${e.logradouro}, ${e.bairro}'),
                            subtitle:
                                Text('${e.localidade} - ${e.uf} | CEP: ${e.cep}'),
                            onTap: () {
                              _cepController.text = e.cep ?? "";
                              _buscarEndereco();
                            },
                          ),
                        );
                      },
                    ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
