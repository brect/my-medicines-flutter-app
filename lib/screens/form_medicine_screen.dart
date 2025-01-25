import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/model/medicine.dart';
import '../medicine_store.dart';

class FormMedicineScreen extends StatefulWidget {
  final Medicine? medicine;

  const FormMedicineScreen({super.key, this.medicine});

  @override
  State<FormMedicineScreen> createState() => _FormMedicineScreenState();
}

class _FormMedicineScreenState extends State<FormMedicineScreen> {
  TextEditingController textMedicineName = TextEditingController();
  TextEditingController textMedicineDescription = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.medicine != null) {
      textMedicineName.text = widget.medicine!.name;
      textMedicineDescription.text = widget.medicine!.description;
      dateController.text = widget.medicine!.startDate;
      _timeController.text = widget.medicine!.startTime;
    }
  }

  final TextEditingController _timeController = TextEditingController();
  TimeOfDay? _selectedTime;
  String _formattedTime = '';
  final _formKey = GlobalKey<FormState>();

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  bool get isEditing => widget.medicine != null;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MedicineStore>(context);

    final title = isEditing ? 'Edit medicine' : 'New medicine';

    final buttonText = isEditing ? 'Save' : 'Add';

    return Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (String? value) {
                                if (valueValidator(value)) {
                                  return 'Enter the name of the medicine';
                                }
                                return null;
                              },
                              controller: textMedicineName,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.medication),
                                  border: OutlineInputBorder(),
                                  labelText: 'Medicine',
                                  fillColor: Colors.white24,
                                  filled: true),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (String? value) {
                                if (valueValidator(value)) {
                                  return 'Enter the description of the medicine';
                                }
                                return null;
                              },
                              controller: textMedicineDescription,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.description),
                                  border: OutlineInputBorder(),
                                  labelText: 'Description',
                                  fillColor: Colors.white24,
                                  filled: true),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (String? value) {
                                if (valueValidator(value)) {
                                  return 'Enter start date';
                                }
                                return null;
                              },
                              controller: dateController,
                              textAlign: TextAlign.start,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('dd/MM/yyyy')
                                          .format(pickedDate);

                                  setState(() {
                                    dateController.text = formattedDate;
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                              decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(),
                                  labelText: 'Start date',
                                  fillColor: Colors.white24,
                                  filled: true),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (String? value) {
                                if (valueValidator(value)) {
                                  return 'Enter the time to take the medicine';
                                }
                                return null;
                              },
                              controller: _timeController,
                              textAlign: TextAlign.start,
                              readOnly: true,
                              onTap: () async {
                                final TimeOfDay? timeOfDay =
                                    await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        initialEntryMode:
                                            TimePickerEntryMode.dial);

                                if (timeOfDay != null) {
                                  setState(() {
                                    _selectedTime = timeOfDay;
                                    _formattedTime = DateFormat('HH:mm').format(
                                        DateTime(
                                            2023,
                                            1,
                                            1,
                                            _selectedTime!.hour,
                                            _selectedTime!.minute));
                                    _timeController.text = _formattedTime;
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.timer),
                                  border: OutlineInputBorder(),
                                  labelText: 'Time',
                                  fillColor: Colors.white24,
                                  filled: true),
                            ),
                          ),
                        ]),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final editId = widget.medicine?.id;

                        final newMedicine = Medicine(
                          id: editId,
                          name: textMedicineName.text,
                          description: textMedicineDescription.text,
                          photoMedicine: 'https://via.placeholder.com/150',
                          startDate: dateController.text,
                          startTime: _timeController.text,
                        );

                        store.addItem(newMedicine);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Medicamento salvo com sucesso!'),
                          ),
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: Text(buttonText))
              ],
            )));
  }
}
