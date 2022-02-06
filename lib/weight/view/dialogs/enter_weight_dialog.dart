import 'dart:developer';
import 'dart:io';

import 'package:black_cat_lib/black_cat_lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/weight/bloc/weight_bloc.dart';
import 'package:weight_tracker/weight/bloc/weight_event.dart';
import 'package:weight_tracker/weight/models/weight_entry.dart';

import '../../../utils/date_time_formatter.dart';

class EnterWeightDialog extends StatelessWidget {
  const EnterWeightDialog({Key? key, required this.weightBloc})
      : super(key: key);

  final WeightBloc weightBloc;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const MyTextWidget(text: 'Add Weight Entry', fontSize: 20),
      actions: [
        _DateRow(weightBloc: weightBloc),
        _WeightInputTextField(weightBloc: weightBloc),
        _SubmitButton(weightBloc: weightBloc),
      ],
    );
  }
}

class _DateRow extends StatefulWidget {
  const _DateRow({Key? key, required this.weightBloc}) : super(key: key);
  final WeightBloc weightBloc;

  @override
  State<_DateRow> createState() => _DateRowState();
}

class _DateRowState extends State<_DateRow> {
  late String displayDate;

  @override
  void initState() {
    log('init state');
    super.initState();
    _updateEntryDate(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _modifyDate() => Platform.isAndroid
      ? _showMaterialDatePicker()
      : _showCupertinoDatePicker();

  void _showMaterialDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      _updateEntryDate(pickedDate);
    });
  }

  void _showCupertinoDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (pickedDate) => _updateEntryDate(pickedDate),
              initialDateTime: DateTime.now(),
              maximumDate: DateTime.now(),
            ),
          );
        });
  }

  void _updateEntryDate(DateTime pickedDate) {
    widget.weightBloc.add(EntryDateModified(modifiedDate: pickedDate));
    setState(() {
      displayDate = DateTimeFormatter.formatDate(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _modifyDate(),
      child: RoundedContainer(
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyTextWidget(
                text: displayDate,
              ),
              const Icon(
                Icons.calendar_today,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightInputTextField extends StatelessWidget {
  const _WeightInputTextField({
    Key? key,
    required this.weightBloc,
  }) : super(key: key);

  final WeightBloc weightBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RoundedContainer(
        color: Colors.white24,
        child: TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Weight',
            contentPadding: EdgeInsets.only(left: 8.0),
          ),
          onChanged: (text) => weightBloc.add(
            WeightTextEntered(input: text),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
    required this.weightBloc,
  }) : super(key: key);

  final WeightBloc weightBloc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('Submit'),
      onPressed: () {
        weightBloc.add(
          WeightEntrySubmitted(
            weightEntry: WeightEntry(
                enteredOn: weightBloc.entryDate,
                weight: weightBloc.weightInput),
          ),
        );
        Navigator.pop(context);
      },
    );
  }
}
