import 'package:flutter/material.dart';

import '../data/model/medicine.dart';

class MedicineItemComponent extends StatefulWidget {
  final int? id;
  final String name;
  final String description;
  final String photoMedicine;
  final String startDate;
  final String startTime;
  final String formattedStartTime;

  const MedicineItemComponent({
    super.key,
    this.id,
    required this.name,
    required this.description,
    required this.photoMedicine,
    required this.startDate,
    required this.startTime,
    required this.formattedStartTime,
  });

  const MedicineItemComponent.medicineView(
      {super.key,
      this.id,
      required this.name,
      required this.photoMedicine,
      required this.description,
      required this.startTime})
      : startDate = '',
        formattedStartTime = '';

  Medicine toMedicine() {
    return Medicine(
      id: id,
      name: name,
      description: description,
      photoMedicine: photoMedicine,
      startDate: startDate,
      startTime: startTime,
    );
  }

  @override
  State<MedicineItemComponent> createState() => _MedicineItemComponentState();
}

class _MedicineItemComponentState extends State<MedicineItemComponent> {
  Widget _buildImage() {
    return Image.asset('assets/images/dash.png');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black26,
                    ),
                    child: ClipOval(
                      child: _buildImage(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          child: Text(
                        widget.name,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      )),
                      Text(
                        widget.description,
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.startTime,
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.arrow_forward_ios_rounded),
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
