# ResumeAI

Aplicativo mobile desenvolvido em Flutter para geração de resumos acadêmicos com apoio de IA. O projeto foi criado para a disciplina `Laboratório de Programação para Dispositivos Móveis e Sem Fio`, com foco em navegação entre telas, gerenciamento de estado e consumo de API REST.

## Proposta

O `ResumeAI` permite que o usuário:

- faça login em uma tela inicial demonstrativa;
- cole um texto manualmente ou anexe um arquivo PDF;
- envie esse conteúdo para a API Gemini;
- receba um resumo acadêmico estruturado;
- visualize os resumos salvos no histórico;
- compartilhe o resumo gerado em PDF.

## Funcionalidades

- Tela de abertura com animação.
- Tela de login demonstrativa.
- Tela inicial com histórico de resumos.
- Tela de edição para entrada manual de texto.
- Leitura e extração de texto de arquivos PDF.
- Consumo de API REST para geração de resumo.
- Persistência local com `SharedPreferences`.
- Tela de leitura do resumo estruturado.
- Exportação e compartilhamento em PDF.

## Telas do aplicativo

O app possui as seguintes telas:

1. `TelaAbertura`
2. `TelaLogin`
3. `TelaInicio`
4. `TelaEditor`
5. `TelaLeitura`

Fluxo principal:

`/` -> `/login` -> `/home` -> `/editor` -> `/leitura`

## Tecnologias utilizadas

- Flutter
- Dart
- Material 3
- API Gemini
- SharedPreferences
- File Picker
- Syncfusion PDF
- PDF
- Share Plus

## Dependências principais

- `http`
- `flutter_dotenv`
- `shared_preferences`
- `path_provider`
- `pdf`
- `share_plus`
- `printing`
- `file_picker`
- `syncfusion_flutter_pdf`

## Estrutura do projeto

```text
lib/
  main.dart
  api.dart
  modelos.dart
  pdf_util.dart
  aplicativo.dart
  telas/
    tela_abertura.dart
    tela_login.dart
    tela_inicio.dart
    tela_editor.dart
    tela_leitura.dart
```

## Como executar

### 1. Pré-requisitos

- Flutter instalado e configurado
- Android Studio ou VS Code
- Dispositivo Android ou emulador
- Chave de API da Gemini

### 2. Instalar dependências

```bash
flutter pub get
```

### 3. Configurar variável de ambiente

Crie um arquivo `.env` na raiz do projeto com:

```env
GEMINI_API_KEY=sua_chave_aqui
```

O projeto já está configurado para carregar esse arquivo no `main.dart`.

### 4. Executar o app

```bash
flutter run
```

## Consumo de API

O aplicativo utiliza a API Gemini para gerar resumos acadêmicos estruturados.

- Endpoint:
  `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent`
- Método:
  `POST`
- Autenticação:
  chave via `GEMINI_API_KEY`

O app envia um prompt pedindo que a IA retorne um JSON com os campos:

- `titulo`
- `objetivo`
- `metodologia`
- `resultados`
- `conclusao`
- `palavrasChave`

## Armazenamento local

Os resumos gerados são salvos localmente com `SharedPreferences`, permitindo que o usuário visualize um histórico recente na tela inicial.

## Exportação em PDF

O resumo gerado pode ser convertido em PDF e compartilhado a partir da tela de leitura, usando as bibliotecas `pdf`, `path_provider` e `share_plus`.

## Observações

- A tela de login é demonstrativa e não possui autenticação com backend.
- O funcionamento da geração de resumo depende de conexão com a internet e de uma chave válida da API Gemini.
- O conteúdo extraído de PDF depende de o arquivo possuir texto selecionável.

## Documentação do trabalho

O projeto possui uma documentação acadêmica separada nos arquivos:

- `DOCUMENTACAO_TRABALHO.pdf`

## Autora

Maria Clara Maciel

