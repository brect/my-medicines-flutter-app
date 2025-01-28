import 'package:flutter/material.dart';
import 'package:my_medicines_flutter_app/components/medicine_item_component.dart';
import 'package:provider/provider.dart';

import '../medicine_store.dart';
import 'form_medicine_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MedicineStore>(context);

    final items = store.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Medicines"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 70),
        child: Builder(
          builder: (context) {
            if (store.isLoading) {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    'Carregando',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ));
            } else if (items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 98,
                    ),
                    Text(
                      'Você não possui nenhum medicamento',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Excluir Item'),
                            content: Text(
                                'Deseja realmente excluir o item "${item.name}"?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  final itemId = item.id;
                                  if (itemId != null) {
                                    await store.removeItem(itemId);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Medicamento removido com sucesso!'),
                                      ),
                                    );

                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('SIM'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Apenas fecha o diálogo
                                },
                                child: const Text('NÃO'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormMedicineScreen(
                            medicine: item.toMedicine(),
                          ),
                        ),
                      );
                    },
                    child: MedicineItemComponent.medicineView(
                      name: item.name,
                      photoMedicine: item.photoMedicine,
                      description: item.description,
                      startTime: item.startTime,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormMedicineScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          Text(
            'Carregando',
            style: TextStyle(fontSize: 32),
          )
        ],
      ),
    );
  }
}
