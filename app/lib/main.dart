import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoList App',

      debugShowCheckedModeBanner: false, // Tira a faixa de debug

      theme: ThemeData(useMaterial3: true),

      home: const MinhaTelaPrincipal(),
    );
  }
}

class MinhaTelaPrincipal extends StatefulWidget {
  const MinhaTelaPrincipal({super.key});

  @override
  State<MinhaTelaPrincipal> createState() => _MinhaTelaPrincipalState();
}

class _MinhaTelaPrincipalState extends State<MinhaTelaPrincipal> {
  // A memória da nossa lista

  List<String> tarefas = [];

  // O "gancho" para capturar o texto do teclado

  final TextEditingController _controleTexto = TextEditingController();

  void abrirJanelaCadastro() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Tarefa'),

          content: TextField(
            controller: _controleTexto, // Conectamos o gancho aqui

            decoration: const InputDecoration(
              hintText: 'Digite o nome da tarefa...',
            ),
          ),

          actions: [
            // Botão de cancelar
            TextButton(
              onPressed: () => Navigator.pop(context),

              child: const Text('Cancelar'),
            ),

            // Botão de salvar
            ElevatedButton(
              onPressed: () {
                // Se o texto não estiver vazio, adicionamos na lista

                if (_controleTexto.text.isNotEmpty) {
                  setState(() {
                    tarefas.add(_controleTexto.text);
                  });

                  _controleTexto.clear(); // Limpa a caixa para a próxima

                  Navigator.pop(context); // Fecha a janelinha
                }
              },

              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList App'),

        backgroundColor: Colors.green,

        foregroundColor: Colors.yellow,
      ),

      body: tarefas.isEmpty
          ? const Center(child: Text('Nenhuma tarefa por enquanto...'))
          : ListView.builder(
              itemCount: tarefas.length,

              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.green,
                  ),

                  title: Text(tarefas[index]),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirJanelaCadastro, // Chama a função que criamos

        backgroundColor: Colors.blue,

        child: const Icon(Icons.add),
      ),
    );
  }
}
