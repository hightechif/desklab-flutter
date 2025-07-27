import 'dart:async';
import 'package:intl/intl.dart';
import 'package:desklab/domain/models/activity.dart';
import 'package:flutter/material.dart';

class AddActivityScreen extends StatefulWidget {
  final Activity? activity;
  final DateTime? selectedDate;
  const AddActivityScreen({super.key, this.activity, this.selectedDate});
  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _projectController,
      _activityController,
      _hoursController,
      _notesController;
  late DateTime _dateForActivity;

  bool get isEditing => widget.activity != null;

  @override
  void initState() {
    super.initState();
    _projectController = TextEditingController(text: widget.activity?.project);
    _activityController = TextEditingController(
      text: widget.activity?.activityName,
    );
    _hoursController = TextEditingController(
      text: widget.activity?.hours.toString(),
    );
    _notesController = TextEditingController(text: widget.activity?.notes);
    _dateForActivity =
        widget.activity?.activityDate ?? widget.selectedDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _projectController.dispose();
    _activityController.dispose();
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Mohon Tunggu"),
              ],
            ),
          ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();
      Timer(const Duration(seconds: 1), () {
        final newActivity = Activity(
          // CHANGED: Ensure a unique ID is always present. Use the existing one if editing,
          // or create a new one based on the timestamp for new activities.
          id: widget.activity?.id ?? DateTime.now().toIso8601String(),
          project: _projectController.text,
          activityName: _activityController.text,
          hours: int.parse(_hoursController.text),
          notes: _notesController.text,
          activityDate: _dateForActivity,
          color:
              isEditing
                  ? widget.activity!.color
                  : (_projectController.text.contains("KLIK")
                      ? const Color(0xFF546E7A)
                      : Colors.brown),
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop(newActivity);
      });
    }
  }

  void _selectProject() async {
    final result = await _showSelectionScreen(
      context: context,
      title: 'Daftar Proyek',
      items: [
        'KLIK-CORP-KLIK-DEVELOPMENT',
        'EDTS-ADMIN-ADMIN-TRAINING',
        'GURIH-CORP-GURIHMART-DEV',
      ],
    );
    if (result != null) _projectController.text = result;
  }

  void _selectActivity() async {
    final result = await _showSelectionScreen(
      context: context,
      title: 'Daftar Aktivitas',
      items: [
        'Development',
        'Sharing Session',
        'Research / Planning',
        'Bugs Fixing',
        'Enhancement',
        'Weekly Meeting',
      ],
    );
    if (result != null) _activityController.text = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Ubah Aktivitas' : 'Tambah Aktivitas',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          if (isEditing)
            TextButton(
              onPressed: () => Navigator.of(context).pop('delete'),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextField(
              label: 'Tanggal',
              initialValue: DateFormat(
                'd MMMM yyyy',
                'id_ID',
              ).format(_dateForActivity),
              readOnly: true,
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Proyek',
              controller: _projectController,
              onTap: _selectProject,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Aktivitas',
              controller: _activityController,
              onTap: _selectActivity,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Jam Kerja',
              controller: _hoursController,
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Catatan',
              controller: _notesController,
              maxLines: 3,
              hint: 'Masukkan Catatan (Opsional)',
            ),
            const SizedBox(height: 16),
            _buildAttachmentField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(isEditing ? 'Simpan' : 'Tambah'),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextEditingController? controller,
    bool readOnly = false,
    IconData? icon,
    int? maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ${validator != null ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: icon != null ? Icon(icon) : null,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label *', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: 'Cari atau Pilih $label',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
        ),
      ],
    );
  }

  Widget _buildAttachmentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lampiran', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Center(
            child: Column(
              children: [
                Icon(Icons.upload_file, size: 40, color: Colors.grey),
                SizedBox(height: 8),
                Text('Upload Lampiran'),
                Text(
                  'file didukung: .pdf, .zip, .jpg, .jpeg, .png. Maksimum 5MB',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _showSelectionScreen({
    required BuildContext context,
    required String title,
    required List<String> items,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            builder:
                (_, scrollController) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari $title',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: items.length,
                        itemBuilder:
                            (context, index) => ListTile(
                              title: Text(items[index]),
                              onTap:
                                  () => Navigator.of(context).pop(items[index]),
                            ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }
}
