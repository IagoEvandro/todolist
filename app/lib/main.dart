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

  bool _botaoAdicionarComHover = false;

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
      appBar: BarraSuperiorComBotaoAdicionar(
        comHoverNoBotao: _botaoAdicionarComHover,

        aoEntrarNoBotao: () {
          setState(() {
            _botaoAdicionarComHover = true;
          });
        },

        aoSairDoBotao: () {
          setState(() {
            _botaoAdicionarComHover = false;
          });
        },

        aoPressionarBotao: abrirJanelaCadastro,
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
    );
  }
}

class BarraSuperiorComBotaoAdicionar extends StatelessWidget
    implements PreferredSizeWidget {
  const BarraSuperiorComBotaoAdicionar({
    super.key,
    required this.comHoverNoBotao,
    required this.aoEntrarNoBotao,
    required this.aoSairDoBotao,
    required this.aoPressionarBotao,
  });

  final bool comHoverNoBotao;

  final VoidCallback aoEntrarNoBotao;

  final VoidCallback aoSairDoBotao;

  final VoidCallback aoPressionarBotao;

  static const double _alturaBarra = 104;

  @override
  Size get preferredSize => const Size.fromHeight(_alturaBarra);

  @override
  Widget build(BuildContext context) {
    const Color corPrincipal = Colors.brown;
    const Color corTexto = Color.fromARGB(255, 219, 153, 129);
    final double espacoSuperiorSeguro = MediaQuery.paddingOf(context).top;
    final double alturaConteudo = preferredSize.height - espacoSuperiorSeguro;
    final double centroVerticalConteudo =
        espacoSuperiorSeguro + (alturaConteudo / 2);
    final double centroVerticalElementos = centroVerticalConteudo - 14;
    final double topoTitulo = centroVerticalElementos - 14;
    final double topoBotao =
        centroVerticalElementos - 30 + (comHoverNoBotao ? 8 : 0);

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: preferredSize.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: comHoverNoBotao ? 1 : 0),
              builder: (context, intensidade, child) {
                return ClipPath(
                  clipper: _DistorcaoAppBarClipper(intensidade: intensidade),
                  child: child,
                );
              },
              child: Container(
                height: preferredSize.height,
                color: corPrincipal,
              ),
            ),

            Positioned(
              left: 18,
              top: topoTitulo,
              child: const Text(
                'MyTask App',
                style: TextStyle(
                  color: corTexto,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              right: 18,
              top: topoBotao,
              child: MouseRegion(
                onEnter: (_) => aoEntrarNoBotao(),
                onExit: (_) => aoSairDoBotao(),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  scale: comHoverNoBotao ? 1.08 : 1,
                  child: FloatingActionButton(
                    onPressed: aoPressionarBotao,
                    backgroundColor: corPrincipal,
                    foregroundColor: Colors.white,
                    elevation: comHoverNoBotao ? 8 : 4,
                    shape: const CircleBorder(
                      side: BorderSide(color: corTexto, width: 2),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DistorcaoAppBarClipper extends CustomClipper<Path> {
  const _DistorcaoAppBarClipper({required this.intensidade});

  final double intensidade;

  @override
  Path getClip(Size size) {
    final double linhaBase = size.height - 24 - (10 * intensidade);
    final double inicioDistorcao = size.width - 112;
    final double centroDistorcao = size.width - 46;
    final double fundoDistorcao = size.height - 4;

    return Path()
      ..lineTo(0, linhaBase)
      ..quadraticBezierTo(
        size.width * 0.35,
        linhaBase + (4 * intensidade),
        inicioDistorcao,
        linhaBase,
      )
      ..cubicTo(
        centroDistorcao - 42,
        linhaBase,
        centroDistorcao - 34,
        linhaBase + ((fundoDistorcao - linhaBase) * intensidade),
        centroDistorcao,
        linhaBase + ((fundoDistorcao - linhaBase) * intensidade),
      )
      ..cubicTo(
        centroDistorcao + 34,
        linhaBase + ((fundoDistorcao - linhaBase) * intensidade),
        centroDistorcao + 42,
        linhaBase,
        size.width,
        linhaBase,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(_DistorcaoAppBarClipper oldClipper) {
    return oldClipper.intensidade != intensidade;
  }
}
