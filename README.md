# my_medicines_flutter_app

### Vídeo de apresentação

Link: https://pucpredu-my.sharepoint.com/:v:/g/personal/bruno_silva20_pucpr_edu_br/EUEnny7OU41FuvIWLT6x0i8BiQQJHL3B_wkncuFS_eLIAg?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJTdHJlYW1XZWJBcHAiLCJyZWZlcnJhbFZpZXciOiJTaGFyZURpYWxvZy1MaW5rIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXcifX0%3D&e=eq8mbo

### Visão Geral do Projeto
O aplicativo My Medicines foi desenvolvido em Flutter com o objetivo de gerenciar medicamentos, armazenando dados como nome, descrição, data de início e horário para tomar o medicamento.

Além de permitir a inserção e edição, o app possibilita exclusão de itens, utilizando um banco de dados local (SQLite via sqflite).

O gerenciamento de estado é feito com o Provider, seguindo o padrão de arquitetura com ChangeNotifier para notificar as telas quando há alterações nos dados.

#### main.dart
- Ponto de entrada do aplicativo Flutter.
- Configura o Provider global (MedicineStore) com ChangeNotifierProvider. O uso de Provider logo no runApp garante que toda a árvore de widgets terá acesso ao estado gerenciado (lista de medicamentos).
- Carrega a lista de medicamentos (loadItems()) ao iniciar a aplicação.
- Define o MaterialApp, configurando tema e home como InitialScreen.

#### medicine_store.dart
- Nossa classe que gerencia o estado dos medicamentos.
- Estende ChangeNotifier, possibilitando às telas escutar mudanças de estado.
- Conecta-se ao banco de dados através do MedicineDAO.
- Fornece métodos para:
    - loadItems(): carregar todos os medicamentos do banco.
    - addItem(): inserir ou atualizar um medicamento.
    - removeItem(): excluir um medicamento.
- A ideia é centralizar o estado numa Store para simplificar o controle de fluxo de dados e evitar duplicação de lógica em várias telas.

#### initial_screen.dart
- Tela inicial que exibe a lista de medicamentos.
- Ao construir a tela, obtém a lista de items a partir do MedicineStore.
- Caso esteja carregando (isLoading), exibe um indicador de progresso.
- Exibe mensagem caso não haja medicamentos.
- Lista cada medicamento usando um ListView.builder.
- Permite excluir medicamentos com um long press (acionando um AlertDialog)
- Permite editar ao tocar em um item (navega para FormMedicineScreen).
- Possui um FloatingActionButton para adicionar novo medicamento.

#### form_medicine_screen.dart
- Tela de cadastro e edição de medicamentos.
- Exibe campos para nome, descrição, data de início e horário (utilizando showDatePicker e showTimePicker).
- Ao confirmar (clicar em “Add” ou “Save”), valida os campos e chama store.addItem(...).

#### database.dart
- Responsável por fornecer a instância do SQLite através do sqflite.
- Cria o banco de dados (caso não exista) em medicine.db.
- Executa o script MedicineDAO.tableSql na criação.

#### medicine.dart
- Modelo de dados que representa um medicamento.
- Contém campos como id, name, description, photoMedicine, startDate, e startTime.
- Implementa o método toMap() para converter o objeto em mapa, sendo necessário para operações de banco de dados.

#### medicine_dao.dart
- Responsável pelas operações de CRUD (Create, Read, Update, Delete) na tabela medicines.
- Implementa:
    - tableSql: script SQL para criar a tabela.
    - save(): insere ou atualiza um medicamento no banco.
    - getAllMedicines(): retorna uma lista de objetos Medicine.
    - delete(): exclui um registro pelo id.
    - Métodos auxiliares (toMap, toList, etc.) para conversão de dados entre banco e modelo.

#### medicine_item_component.dart
- Widget que representa visualmente cada medicamento na lista.
- Exibe imagem, nome, descrição e horário do medicamento.
- Também converte para e de objeto Medicine (toMedicine()).
