import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobFormChangeModel with ChangeNotifier {
  JobFormChangeModel({
    @required this.database,
    @required this.context,
    this.isLoading = false,
    this.jobName,
    this.ratePerHour,
    this.documentId,
  });

  final Database database;
  final BuildContext context;
  bool isLoading;
  String jobName;
  int ratePerHour;
  String documentId;

  Future<void> submit() async {
    try {
      final jobs = await database.jobsStream().first;
      final allNames = jobs.map((job) => job.name).toList();
      if (documentId != null && jobName != null) {
        allNames.remove(jobName);
      }
      if (allNames.contains(jobName)) {
        throw new DuplicateException("Please choose another Job Name");
      } else {
        await database.setJob(
          Job(
            id: documentId ?? documentIdFromCurrentDate(),
            name: jobName,
            ratePerHour: ratePerHour,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateJobName(String jobName) {
    updateWith(jobName: jobName);
    print(this.jobName);
  }

  void updateRatePerHour(int ratePerHour) {
    updateWith(ratePerHour: ratePerHour);
    print(this.ratePerHour);
  }

  void updateWith({String jobName, int ratePerHour, bool isLoading}) {
    this.jobName = jobName ?? this.jobName;
    this.ratePerHour = ratePerHour ?? this.ratePerHour;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }
}

class DuplicateException implements Exception {
  DuplicateException(this.message);
  String message;
}
