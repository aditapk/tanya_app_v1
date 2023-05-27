import 'package:flutter/material.dart';
import 'medicine_information.dart';

class NotifyInformation {
  String? name;
  String? detail;
  DateTime? startDate;
  DateTime? endDate;
  MedicineInformation? selectedMedicine;
  TimeOfDay? morningTime;
  TimeOfDay? lunchTime;
  TimeOfDay? eveningTime;
  TimeOfDay? beforeToBedTime;

  bool get enableMorningTime {
    return morningTime != null ? true : false;
  }

  bool get enableLunchTime {
    return lunchTime != null ? true : false;
  }

  bool get enableEveningTime {
    return eveningTime != null ? true : false;
  }

  bool get enableBeforeToBedTime {
    return beforeToBedTime != null ? true : false;
  }

  NotifyInformation({
    this.name,
    this.detail,
    this.startDate,
    this.endDate,
    this.selectedMedicine,
    this.morningTime,
    this.lunchTime,
    this.eveningTime,
    this.beforeToBedTime,
  });
}
