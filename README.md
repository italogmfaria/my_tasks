# MyTasks

O MyTasks é um aplicativo Flutter desenvolvido para gerenciamento de tarefas pessoais, permitindo criar, listar, marcar como concluídas e excluir tarefas. O diferencial deste projeto está na implementação de **três métodos distintos de persistência local de dados**, possibilitando uma análise comparativa detalhada de suas características, vantagens e limitações.

Este projeto foi desenvolvido como Atividade 8 para a disciplina de Programação Avançada II, com foco na implementação do padrão arquitetural MVVM, gerenciamento de estado com Provider e análise de diferentes estratégias de persistência de dados em aplicações móveis.

## Principais Funcionalidades

-   **Gerenciamento Completo de Tarefas:** Criação, listagem, atualização e exclusão de tarefas pessoais.
-   **Marcação de Conclusão:** Sistema de checkbox para marcar tarefas como concluídas ou pendentes.
-   **Confirmação de Exclusão:** Dialog de confirmação antes de remover uma tarefa.
-   **Três Métodos de Persistência:** Interface com abas para alternar entre SharedPreferences, File e SQLite.
-   **Persistência Automática:** Carregamento automático dos dados ao abrir o app e salvamento em tempo real.
-   **Interface Responsiva:** Design adaptável com suporte multi-plataforma (Web, Android, iOS, Desktop).
-   **Avisos de Plataforma:** Notificações visuais sobre limitações específicas de cada plataforma.

## Arquitetura: MVVM (Model-View-ViewModel)

O projeto foi estruturado seguindo a arquitetura **MVVM (Model-View-ViewModel)** para garantir uma separação clara de responsabilidades, tornando a base de código mais escalável, manutenível e testável. Esta arquitetura é especialmente importante neste projeto, pois permite a implementação de múltiplos ViewModels (um para cada método de persistência) que compartilham a mesma View e Model.

### Model (Modelo)

O Modelo representa os dados e a lógica de negócio da aplicação.

-   **`lib/models/task.dart`**: Define a classe `Task`, que é a estrutura de dados para uma tarefa, incluindo campos como `id`, `title` e `done` (boolean). A classe também implementa métodos de serialização (`toJson`) e desserialização (`fromJson`) para facilitar a persistência em diferentes formatos (JSON para SharedPreferences e File, e campos diretos para SQLite).

### View (Visão)

A Visão é responsável pela interface do usuário (UI) e por exibir os dados ao usuário. Ela observa o ViewModel em busca de mudanças de estado e se atualiza de acordo.

-   **`lib/views/task_list_view.dart`**: Componente de UI reutilizável que exibe a lista de tarefas. Esta view é agnóstica quanto ao método de persistência utilizado, recebendo o ViewModel apropriado como parâmetro. Implementa campo de texto para adicionar novas tarefas, lista scrollável de tarefas com checkbox, botões de exclusão com confirmação e estados de loading e lista vazia.
-   **`lib/widgets/platform_warning.dart`**: Widget que exibe avisos contextuais sobre limitações de plataforma (especialmente para File e SQLite no web).

### ViewModel

O ViewModel atua como uma ponte entre o Modelo e a Visão. Ele detém o estado da aplicação e a lógica de negócio, expondo os dados para a Visão e tratando as interações do usuário. No MyTasks, existem três ViewModels, um para cada método de persistência:

-   **`lib/viewmodels/shared_preferences_viewmodel.dart`**: Gerencia tarefas usando SharedPreferences.
    -   Utiliza `ChangeNotifier` para notificar a UI sobre quaisquer mudanças de estado.
    -   A UI é conectada a este ViewModel usando o pacote `provider`, que escuta as mudanças e reconstrói os widgets relevantes.
    -   Serializa/desserializa tarefas em formato JSON.
    -   Métodos: `loadTasks()`, `addTask(String title)`, `toggleTask(String id)`, `deleteTask(String id)`.

-   **`lib/viewmodels/file_viewmodel.dart`**: Gerencia tarefas usando armazenamento em arquivo.
    -   Implementa leitura/escrita no arquivo `tasks.json` no diretório de documentos da aplicação.
    -   Possui fallback automático para SharedPreferences quando executado no web.
    -   Gerencia estados de carregamento e erros de I/O.

-   **`lib/viewmodels/sqlite_viewmodel.dart`**: Gerencia tarefas usando banco de dados SQLite.
    -   Implementa operações CRUD completas no banco de dados.
    -   Cria e gerencia a tabela `tasks` com campos `id INTEGER PRIMARY KEY`, `title TEXT`, `done INTEGER`.
    -   No web, utiliza armazenamento em memória como alternativa (dados não persistem ao recarregar).

### Repository (Repositório)

Para separar ainda mais as responsabilidades, uma camada de repositório é usada para lidar com a persistência de dados, abstraindo os detalhes de implementação dos ViewModels.

-   **`lib/repositories/shared_preferences_repository.dart`**: Responsável por todas as operações de leitura e escrita usando SharedPreferences.
    -   `loadTasks()`: Carrega e desserializa tarefas do armazenamento local.
    -   `saveTasks(List<Task> tasks)`: Serializa e salva a lista de tarefas.

-   **`lib/repositories/file_repository.dart`**: Gerencia operações de arquivo.
    -   Determina o diretório apropriado para cada plataforma usando `path_provider`.
    -   Implementa detecção de plataforma web com fallback automático para SharedPreferences.
    -   Lida com exceções de I/O de forma robusta.

-   **`lib/repositories/sqlite_repository.dart`**: Encapsula toda a lógica de banco de dados SQLite.
    -   `initDatabase()`: Cria o banco de dados e a tabela `tasks`.
    -   `insertTask(Task task)`, `getTasks()`, `updateTask(Task task)`, `deleteTask(String id)`: Operações CRUD completas.
    -   Implementa fallback para armazenamento em memória no web.

### Theme (Tema)

O aplicativo possui um tema customizado que define a identidade visual da aplicação.

-   **`lib/theme/app_theme.dart`**: Define a paleta de cores e estilos do aplicativo:
    -   **#2B2D42** – Space Cadet (Cor primária, AppBar e textos principais)
    -   **#8D99AE** – Cool Gray (Cor secundária, ícones e detalhes)
    -   **#EDF2F4** – Anti-flash White (Background principal)
    -   **#EF233C** – Red Pantone (Ações de erro/exclusão)
    -   **#D80032** – Crimson (Detalhes de erro)

```
lib/
├── models/
│   └── task.dart                          # Modelo de dados Task
├── repositories/
│   ├── shared_preferences_repository.dart # Persistência via SharedPreferences
│   ├── file_repository.dart               # Persistência via File
│   └── sqlite_repository.dart             # Persistência via SQLite
├── theme/
│   └── app_theme.dart                     # Tema customizado
├── viewmodels/
│   ├── shared_preferences_viewmodel.dart  # ViewModel SharedPreferences
│   ├── file_viewmodel.dart                # ViewModel File
│   └── sqlite_viewmodel.dart              # ViewModel SQLite
├── views/
│   └── task_list_view.dart                # UI reutilizável
├── widgets/
│   └── platform_warning.dart              # Avisos de plataforma
├── main.dart                              # Entrada da aplicação
```

## Dependências

-   **`provider`**: Usado para o gerenciamento de estado e para implementar a conexão entre os ViewModels e a Visão.
-   **`shared_preferences`**: Utilizado para persistência simples de pares chave-valor (Versão 1).
-   **`path_provider`**: Fornece acesso aos diretórios do sistema de arquivos para armazenamento de arquivo local (Versão 2).
-   **`sqflite`**: Implementa banco de dados SQLite para persistência estruturada (Versão 3).

## Métodos de Persistência Implementados

### Versão 1: SharedPreferences

**Armazenamento:** Pares chave-valor em formato JSON serializado.

**Implementação:**
- As tarefas são convertidas para JSON usando `jsonEncode()`.
- A lista completa é salva sob uma única chave no SharedPreferences.
- Carregamento automático ao inicializar o app.
- Salvamento automático após cada operação (adicionar, atualizar, excluir).

**Características:**
- ✅ Simples e direto de implementar
- ✅ Excelente para dados pequenos e configurações
- ✅ Funciona em todas as plataformas
- ⚠️ Não recomendado para grandes volumes de dados
- ⚠️ Sem suporte a queries complexas

### Versão 2: File (Armazenamento em Arquivo)

**Armazenamento:** Arquivo JSON local (`tasks.json`).

**Implementação:**
- Utiliza `path_provider` para obter o diretório de documentos da aplicação.
- Grava e lê o arquivo `tasks.json` com toda a lista de tarefas.
- Atualização do arquivo sempre que há alteração nos dados.
- No web, usa SharedPreferences como fallback transparente.

**Características:**
- ✅ Flexível para diferentes formatos de dados
- ✅ Útil para export/import e backup
- ✅ Controle total sobre a estrutura dos dados
- ⚠️ Requer serialização manual
- ⚠️ Não disponível nativamente no Flutter Web

### Versão 3: SQLite (via sqflite)

**Armazenamento:** Banco de dados relacional SQLite.

**Implementação:**
- Criação de tabela `tasks` com campos: `id INTEGER PRIMARY KEY`, `title TEXT`, `done INTEGER`.
- Operações CRUD completas usando SQL.
- Queries otimizadas para leitura e escrita.
- No web, utiliza armazenamento em memória (dados não persistem ao recarregar).

**Características:**
- ✅ Robusto e escalável
- ✅ Suporta queries complexas e relações
- ✅ Excelente performance com grandes volumes
- ✅ Transações e integridade de dados
- ⚠️ Setup inicial mais complexo
- ⚠️ Não funciona no Flutter Web (requer fallback)

## Como Executar o Projeto

1.  **Clone o repositório:**
    ```bash
    git clone <url-do-repositorio>
    ```

2.  **Navegue até o diretório do projeto:**
    ```bash
    cd my_tasks
    ```

3.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

4.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```

## Fluxo de Uso do Aplicativo

1. Ao abrir o app, o usuário visualiza uma interface com três abas: **SharedPreferences**, **File** e **SQLite**.
2. Cada aba apresenta uma lista de tarefas e um campo de texto para adicionar novas tarefas.
3. Para adicionar uma tarefa, o usuário digita o título no campo de texto e pressiona o botão "+" ou a tecla Enter.
4. Cada tarefa na lista possui um checkbox à esquerda para marcar como concluída/pendente e um ícone de lixeira à direita para exclusão.
5. Ao clicar no checkbox, a tarefa é marcada como concluída (com texto riscado) ou volta para pendente.
6. Ao clicar no ícone de lixeira, um dialog de confirmação é exibido antes de excluir a tarefa.
7. Todas as operações são salvas automaticamente usando o método de persistência da aba ativa.
8. Ao fechar e reabrir o aplicativo, as tarefas são carregadas automaticamente de cada método de persistência.
9. O usuário pode alternar entre as abas para comparar o comportamento dos três métodos de persistência.
10. Em plataformas web, avisos visuais são exibidos nas abas File e SQLite sobre limitações de persistência.
