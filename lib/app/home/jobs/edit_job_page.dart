import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/job_form_change_model.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage(
      {Key key, @required this.database, @required this.model, this.job})
      : super(key: key);
  final Database database;
  final JobFormChangeModel model;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditJobPage.create(context, database, job),
      ),
    );
  }

  static Widget create(BuildContext context, Database database, Job job) {
    return ChangeNotifierProvider<JobFormChangeModel>(
      create: (_) => JobFormChangeModel(
          database: database,
          context: context,
          jobName: job?.name,
          ratePerHour: job?.ratePerHour,
          documentId: job?.id),
      child: Consumer<JobFormChangeModel>(
        builder: (_, model, __) => EditJobPage(
          database: database,
          model: model,
          job: job,
        ),
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _jobFieldKey = GlobalKey<FormFieldState>();

  final FocusNode _jobFocusNode = FocusNode();
  final FocusNode _rateFocusNode = FocusNode();

  bool _isLoading = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        await widget.model.submit();
        Navigator.of(context).pop();
      } on DuplicateException catch (e) {
        showAlertDialogue(
          context,
          title: "Duplicate Job Name",
          content: e.message,
          defaultActionText: 'OK',
        );
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: "Operation Failed",
          exception: e,
        );
      }
    }
  }

  void _onJobEditingComplete() {
    if (_jobFieldKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(_rateFocusNode);
    }
  }

  @override
  void dispose() {
    _rateFocusNode.dispose();
    _jobFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: widget.job == null ? Text("Add a new Job") : Text("Edit Job"),
        actions: [
          FlatButton(
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: _isLoading ? null : _submit,
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(labelText: 'Job Name'),
        enabled: _isLoading ? false : true,
        focusNode: _jobFocusNode,
        initialValue: widget.job != null ? widget.model.jobName : null,
        key: _jobFieldKey,
        onSaved: (value) => widget.model.updateJobName(value),
        onEditingComplete: _onJobEditingComplete,
        textInputAction: TextInputAction.next,
        validator: (value) => value.isNotEmpty ? null : "Name cannot be empty",
      ),
      SizedBox(height: 8),
      TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(labelText: 'Rate Per Hour'),
        enabled: _isLoading ? false : true,
        focusNode: _rateFocusNode,
        initialValue: widget.job != null ? '${widget.model.ratePerHour}' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => widget.model.updateRatePerHour(int.tryParse(value)),
        validator: (value) => value.isNotEmpty ? null : "Rate cannot be empty",
      )
    ];
  }
}
