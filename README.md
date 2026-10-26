# G Hub Battery Tray

Indicador de bateria do Logitech G535 na area de notificacao do Windows, com leitura direta do Logitech G Hub.

## Aparencia

- Bateria vertical com contorno preto e fundo transparente.
- Carregando: somente um raio azul-claro dentro da bateria.
- Carga completa: preenchimento verde.
- 61 a 99%: tres barras azuis; 31 a 60%: duas barras amarelas; ate 30%: uma barra vermelha.
- Percentual e autonomia ao passar o mouse; atualizacao a cada 30 segundos.
- Menu para atualizar, abrir o G Hub ou sair.
- Desligado, desconectado ou G Hub indisponivel: bateria com X vermelho; novas tentativas a cada 30 segundos.

## Requisitos

Windows 10/11, Windows PowerShell 5.1 e Logitech G Hub em execucao. Validado com o G535; outros modelos nao foram testados e nao sao selecionados por esta versao. Nao requer Python, Node.js ou acesso de administrador.

## Como usar

1. Baixe o ZIP do repositorio em **Code > Download ZIP** e extraia em uma pasta permanente.
2. Abra o Logitech G Hub e conecte o G535.
3. Na pasta extraida, clique com o botao direito em **Criar-Atalho.ps1** e escolha **Executar com PowerShell**.
4. Abra o atalho **Bateria do headset** criado nessa mesma pasta.
5. Se necessario, arraste o icone da seta de icones ocultos para perto do relogio.

O atalho usa uma opcao de execucao valida somente para o processo iniciado; nao altera a politica global do Windows. Se a organizacao bloquear scripts, siga as regras do administrador.

Para iniciar junto com o Windows, copie o atalho para a pasta Inicializar do seu usuario. Isso e opcional e nao e feito automaticamente. Para remover, saia pelo menu do icone, remova esse atalho da pasta Inicializar se o tiver adicionado e apague a pasta do projeto.

## Privacidade

O aplicativo consulta exclusivamente `ws://127.0.0.1:9010` com subprotocolo `json`, usando consultas GET de dispositivos e bateria. Essa conexao fica no proprio computador. O codigo nao envia dados para a internet, nao coleta telemetria e nao grava leituras ou identificadores em arquivos. A lista de dispositivos recebida e usada em memoria para localizar o G535.

O pacote nao inclui logs, bancos de dados do G Hub, atalhos de um computador especifico, capturas de tela, nomes de usuario ou caminhos pessoais. O atalho e criado no computador de quem baixa.

## Limitacoes

A comunicacao local utilizada e interna ao G Hub e pode mudar em atualizacoes. Se o headset estiver desconectado ou o G Hub indisponivel, aparece uma bateria com X vermelho sem percentual. O contorno preto foi escolhido para barras de tarefas claras e pode ter pouco contraste no tema escuro. O tamanho final do icone e controlado pelo Windows.

Projeto independente, sem afiliacao com a Logitech. Nenhum arquivo, imagem ou componente proprietario do G Hub e redistribuido.

## Contribuir

Sugestoes e melhorias sao bem-vindas. Ao relatar problemas, remova nomes de usuario, caminhos pessoais, numeros de serie e identificadores de dispositivos de qualquer anexo.

## Licenca

MIT. Consulte LICENSE.

