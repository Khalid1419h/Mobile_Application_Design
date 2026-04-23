import 'package:flutter/material.dart';
import 'package:university_event_management_system/models/notification_model.dart';
import 'package:university_event_management_system/services/notification_service.dart';

class AddEventPage extends StatefulWidget {
  final Function(Map<String, String>) onAddEvent;
  const AddEventPage({super.key, required this.onAddEvent});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String date = '';
  String time = '';
  String category = '';
  String location = '';
  String latitude = '23.8103';
  String longitude = '90.4125';
  bool notify = false;
  String? selectedCategoryValue;

  static const categories = [
    'Job Fair', 'Research', 'Tour', 'Contest', 'Workshop', 'Career', 'Design', 'Seminar', 'Other'
  ];

  static const Map<String, Color> categoryColors = {
    'Job Fair': Color(0xFF4CAF50),
    'Research': Color(0xFF2196F3),
    'Tour': Color(0xFFFF9800),
    'Contest': Color(0xFFE91E63),
    'Workshop': Color(0xFF9C27B0),
    'Career': Color(0xFF00BCD4),
    'Design': Color(0xFFFF5722),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('➕ Add New Event'),
        backgroundColor: const Color(0xFF5C35CC),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Event Details'),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildField(
                        label: 'Event Title *',
                        hint: 'e.g. DIU Programming Contest',
                        icon: Icons.event,
                        onChanged: (v) => title = v,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        label: 'Description *',
                        hint: 'Short description of the event',
                        icon: Icons.description,
                        maxLines: 2,
                        onChanged: (v) => description = v,
                      ),
                      const SizedBox(height: 14),

                      // Category dropdown
                      DropdownButtonFormField<String>(
                        value: selectedCategoryValue,
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          prefixIcon: const Icon(Icons.category, color: Color(0xFF5C35CC)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: categories.map((c) => DropdownMenuItem(
                          value: c,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: categoryColors[c] ?? Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(c),
                            ],
                          ),
                        )).toList(),
                        onChanged: (v) => setState(() {
                          selectedCategoryValue = v;
                          category = v ?? '';
                        }),
                        validator: (v) => v == null ? 'Select a category' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _sectionTitle('Date & Time'),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: 'Date *',
                          hint: 'YYYY-MM-DD',
                          icon: Icons.calendar_today,
                          onChanged: (v) => date = v,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildField(
                          label: 'Time *',
                          hint: '10:00 AM',
                          icon: Icons.access_time,
                          onChanged: (v) => time = v,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _sectionTitle('📍 Location & Map'),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildField(
                        label: 'Location Name *',
                        hint: 'e.g. DIU Campus, Ashulia',
                        icon: Icons.location_on,
                        onChanged: (v) => location = v,
                      ),
                      const SizedBox(height: 8),
                      // API info
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Map uses OpenStreetMap Free API. Latitude/Longitude দিলে map-এ pin দেখাবে।',
                                style: TextStyle(fontSize: 11, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: '23.8103',
                              decoration: InputDecoration(
                                labelText: 'Latitude',
                                prefixIcon: const Icon(Icons.explore, color: Color(0xFF5C35CC)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (v) => latitude = v,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: '90.4125',
                              decoration: InputDecoration(
                                labelText: 'Longitude',
                                prefixIcon: const Icon(Icons.explore, color: Color(0xFF5C35CC)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (v) => longitude = v,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notification toggle
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: SwitchListTile(
                  title: const Text('Set Reminder Notification', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Notification tab-এ reminder add হবে'),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C35CC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.notifications, color: Color(0xFF5C35CC)),
                  ),
                  value: notify,
                  activeColor: const Color(0xFF5C35CC),
                  onChanged: (v) => setState(() => notify = v),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C35CC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Save Event',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onAddEvent({
                        'title': title,
                        'description': description,
                        'date': date,
                        'time': time,
                        'category': category,
                        'location': location,
                        'latitude': latitude,
                        'longitude': longitude,
                        'image': '',
                        'full_description': description,
                        'notify': notify ? 'true' : 'false',
                      });

                      if (notify) {
                        NotificationService().addNotification(
                          NotificationModel(
                            title: '📅 Reminder: $title',
                            description: description,
                            timestamp: '$date at $time',
                          ),
                        );
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Event Added Successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5C35CC),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF5C35CC)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
      validator: (v) => v!.isEmpty ? 'This field is required' : null,
    );
  }
}
