import 'package:flutter/material.dart';

String? selectedUniversity;
String? selectedDate;
String? selectedCategory;

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? tempUniversity;
  String? tempDate;
  String? tempCategory;

  @override
  void initState() {
    super.initState();
    tempUniversity = selectedUniversity;
    tempDate = selectedDate;
    tempCategory = selectedCategory;
  }

  bool get hasActive =>
      (tempUniversity != null && tempUniversity != 'All Universities') ||
      (tempDate != null && tempDate != 'All Dates') ||
      (tempCategory != null && tempCategory != 'All Categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('🔍 Filter Events')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Find events by:', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 16),

            _buildCard(
              title: 'University',
              icon: Icons.school,
              color: Colors.blue,
              child: DropdownButtonFormField<String>(
                value: tempUniversity,
                hint: const Text('All Universities'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.school, color: Color(0xFF5C35CC)),
                ),
                onChanged: (v) => setState(() => tempUniversity = v),
                items: ['All Universities', 'AUST', 'DIU', 'UIU']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),

            _buildCard(
              title: 'Date',
              icon: Icons.calendar_today,
              color: Colors.orange,
              child: DropdownButtonFormField<String>(
                value: tempDate,
                hint: const Text('All Dates'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF5C35CC)),
                ),
                onChanged: (v) => setState(() => tempDate = v),
                items: ['All Dates', '2025-04-10', '2025-04-15', '2025-04-20', '2025-04-25', '2025-04-30', '2025-05-01', '2025-05-05']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),

            _buildCard(
              title: 'Category',
              icon: Icons.category,
              color: Colors.purple,
              child: DropdownButtonFormField<String>(
                value: tempCategory,
                hint: const Text('All Categories'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category, color: Color(0xFF5C35CC)),
                ),
                onChanged: (v) => setState(() => tempCategory = v),
                items: ['All Categories', 'Job Fair', 'Research', 'Tour', 'Contest', 'Workshop', 'Career', 'Design']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text('Apply Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C35CC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedUniversity = tempUniversity;
                          selectedDate = tempDate;
                          selectedCategory = tempCategory;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('✅ Filter applied!'), backgroundColor: Colors.green),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasActive ? Colors.red[700] : Colors.grey[400],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: hasActive ? () => setState(() {
                      tempUniversity = null;
                      tempDate = null;
                      tempCategory = null;
                      selectedUniversity = null;
                      selectedDate = null;
                      selectedCategory = null;
                    }) : null,
                    child: const Text('Reset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),

            if (hasActive) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5C35CC).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF5C35CC).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Active Filters:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5C35CC))),
                    const SizedBox(height: 4),
                    if (tempUniversity != null && tempUniversity != 'All Universities') Text('🏫 $tempUniversity'),
                    if (tempDate != null && tempDate != 'All Dates') Text('📅 $tempDate'),
                    if (tempCategory != null && tempCategory != 'All Categories') Text('🏷 $tempCategory'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required Color color, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
