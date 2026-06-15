import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTask App',

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
  // NOVA ESTRUTURA: Agora a lista guarda Mapas (Chave e Valor) em vez de apenas texto

  List<Map<String, dynamic>> tarefas = [];

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
                // Se o texto não estiver vazio, adicionamos o Mapa na lista

                if (_controleTexto.text.isNotEmpty) {
                  setState(() {
                    tarefas.add({
                      'titulo': _controleTexto.text,

                      'concluida':
                          false, // Toda tarefa nova começa como não concluída
                    });
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
        title: const Text('MyTask App'),

        backgroundColor: Colors.brown,

        foregroundColor: const Color.fromARGB(255, 219, 153, 129),
      ),

      body: tarefas.isEmpty
          ? const Center(child: Text('Nenhuma tarefa por enquanto...'))
          : ListView.builder(
              itemCount: tarefas.length,

              itemBuilder: (context, index) {
                // Criamos uma variável local para facilitar a leitura do status da tarefa atual

                final bool estaConcluida = tarefas[index]['concluida'];

                return ListTile(
                  // 1. MARCAR COMO CONCLUÍDA (Lado Esquerdo): Ícone muda dinamicamente
                  leading: Icon(
                    estaConcluida
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,

                    color: Colors.brown,
                  ),

                  // O texto ganha um efeito de "riscado" se a tarefa estiver concluída
                  title: Text(
                    tarefas[index]['titulo'],

                    style: TextStyle(
                      decoration: estaConcluida
                          ? TextDecoration.lineThrough
                          : null,

                      color: estaConcluida ? Colors.grey : Colors.black,
                    ),
                  ),

                  // 2. EXCLUIR TAREFA (Lado Direito): Botão de lixeira
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 84, 26, 22),
                    ),

                    onPressed: () {
                      setState(() {
                        tarefas.removeAt(
                          index,
                        ); // Remove o item da lista pela posição (índice)
                      });
                    },
                  ),

                  // Ação ao clicar em qualquer lugar da linha da tarefa
                  onTap: () {
                    setState(() {
                      // Inverte o valor booleano atual (se era true vira false, se era false vira true)

                      tarefas[index]['concluida'] =
                          !tarefas[index]['concluida'];
                    });
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirJanelaCadastro, // Chama a função que criamos

        backgroundColor: Colors.brown,

        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
