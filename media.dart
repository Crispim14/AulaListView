import 'package:flutter/material.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final TextEditingController _nomeController = TextEditingController();
  final List<TextEditingController> _notasControllers =
      List.generate(4, (_) => TextEditingController());
  String _resultado = '';

  void _calcularMedia() {
    double somaNotas = 0;
    for (var controller in _notasControllers) {
      double? nota = double.tryParse(controller.text.replaceAll(',', '.'));
      if (nota == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Por favor, preencha todos os campos corretamente.'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ));
        return;
      }
      somaNotas += nota;
    }
    double media = somaNotas / _notasControllers.length;
    setState(() {
      _resultado =
          '${_nomeController.text} obteve média ${media.toStringAsFixed(1)}.';
      if (media >= 6.0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Aprovado'),
          action: SnackBarAction(
            label: 'Limpar',
            onPressed: _limparCampos,
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Reprovado'),
          action: SnackBarAction(
            label: 'Limpar',
            onPressed: _limparCampos,
          ),
        ));
      }
    });
  }

  void _limparCampos() {
    _nomeController.clear();
    for (var controller in _notasControllers) {
      controller.clear();
    }
    setState(() {
      _resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Média'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do aluno'),
            ),
            ..._notasControllers.asMap().entries.map((entry) {
              int idx = entry.key;
              TextEditingController controller = entry.value;
              return TextField(
                controller: controller,
                decoration: InputDecoration(labelText: 'Nota ${idx + 1}'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              );
            }),
            ElevatedButton(
              onPressed: _calcularMedia,
              child: Text('Calcular Média'),
            ),
            Text(_resultado),
          ],
        ),
      ),
    );
  }
}
