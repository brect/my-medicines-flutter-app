import 'package:flutter/material.dart';
import 'package:my_medicines_flutter_app/data/dao/Medicine_dao.dart';

import 'components/medicine_item_component.dart';
import 'data/model/medicine.dart';

class MedicineStore extends ChangeNotifier {

  final MedicineDAO _dao = MedicineDAO();

  /// Lista local de itens, mantida em memória.
  List<MedicineItemComponent> _items = [];

  /// Getter para a lista
  List<MedicineItemComponent> get items => _items;

  bool isLoading = false; // se quiser usar flag de loading

  /// Carrega todos os itens do DB e atualiza [_items].
  Future<void> loadItems() async {
    isLoading = true;
    notifyListeners();

    final List<Medicine> medicines = await _dao.getAllMedicines();
    _items = medicines.map((e) => MedicineItemComponent(
      id: e.id,
      name: e.name,
      description: e.description,
      photoMedicine: e.photoMedicine,
      startDate: e.startDate,
      startTime: e.startTime,
      formattedStartTime: e.startTime,
    )).toList();

    isLoading = false;
    notifyListeners();
  }

  /// Salva (insert/update) um item no banco e recarrega a lista
  Future<void> addItem(Medicine medicine) async {
    await _dao.save(medicine);
    await loadItems(); // recarrega a lista do banco
  }

  /// Exclui um item e recarrega a lista
  Future<void> removeItem(int id) async {
    await _dao.delete(id);
    await loadItems();
  }
}
