import 'package:flutter/material.dart';

class ConnectivityPage extends StatefulWidget {
  const ConnectivityPage({super.key});

  @override
  State<ConnectivityPage> createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status de "Conexão"'),
        titleTextStyle: TextStyle(color: Colors.lightBlue),
        animateColor: EditableText.debugDeterministicCursor,
        shadowColor: Color(0xFFFFF),
      ),
      body: Center(child: Column(children: [Icon(Icons.wifi_1_bar_outlined)])),
    );
  }
}
