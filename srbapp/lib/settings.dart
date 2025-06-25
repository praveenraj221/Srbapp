import 'package:flutter/material.dart';

void main() => runApp(const RespiratoryBeltApp());

class RespiratoryBeltApp extends StatelessWidget {
  const RespiratoryBeltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Respiratory Belt',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double fontSize = 16;
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  bool soundEffectsEnabled = false;
  String selectedLanguage = 'English';
  String selectedRetention = '30 days';
  Color selectedColor = Colors.lightBlue;

  final List<String> languages = ['English', 'Tamil', 'Hindi'];
  final List<String> retentionPeriods = ['7 days', '30 days', '60 days', 'Forever'];

  final List<Color> colorOptions = [
    Colors.lightBlue,
    Colors.indigo,
    Colors.green,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDashboard(),
      appBar: AppBar(
        title: const Text('Respiratory Belt'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildAppearanceSection(),
            const SizedBox(height: 20),
            _buildUserPreferencesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('T', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: fontSize,
                    min: 12,
                    max: 24,
                    divisions: 6,
                    label: '${fontSize.toInt()}px',
                    onChanged: (val) => setState(() => fontSize = val),
                  ),
                ),
                const Text('T', style: TextStyle(fontSize: 20)),
              ],
            ),
            Text('${fontSize.toInt()}px'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isDarkMode = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.grey[300] : Colors.blue,
                    ),
                    child: const Text('Light'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isDarkMode = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.black : Colors.grey[300],
                    ),
                    child: const Text('Dark'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Color Scheme:'),
            const SizedBox(height: 8),
            Row(
              children: colorOptions.map((color) => _buildColorCircle(color)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: selectedColor == color ? Border.all(width: 3, color: Colors.black) : null,
        ),
      ),
    );
  }

  Widget _buildUserPreferencesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Receive alerts for completed readings'),
              value: notificationsEnabled,
              onChanged: (val) => setState(() => notificationsEnabled = val),
            ),
            SwitchListTile(
              title: const Text('Sound Effects'),
              subtitle: const Text('Play sounds during readings'),
              value: soundEffectsEnabled,
              onChanged: (val) => setState(() => soundEffectsEnabled = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              items: languages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
              onChanged: (val) => setState(() => selectedLanguage = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRetention,
              decoration: const InputDecoration(
                labelText: 'Data Retention Period',
                border: OutlineInputBorder(),
              ),
              items: retentionPeriods.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: (val) => setState(() => selectedRetention = val!),
            ),
          ],
        ),
      ),
    );
  }
}

class SideDashboard extends StatelessWidget {
  const SideDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Hemavarthini', style: TextStyle(color: Colors.white, fontSize: 20)),
                SizedBox(height: 8),
                Text('Age: 19', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('Dashboard'), onTap: () {}),
          ListTile(leading: const Icon(Icons.menu_book), title: const Text('New Reading'), onTap: () {}),
          ListTile(leading: const Icon(Icons.history), title: const Text('History'), onTap: () {}),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () {}),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Logout', style: TextStyle(color: Colors.red)), onTap: () {}),
        ],
      ),
    );
  }
}
