import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srbapp/new_reading.dart';
import 'package:srbapp/side_dashboard.dart' as side_dashboard;
import 'package:srbapp/settings.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Sample data - in a real app, this would come from an API
  final String userName = "Hemavarthini";
  int totalReadings = 12;
  DateTime lastReading = DateTime.now().subtract(const Duration(hours: 3));
  bool isMonitoring = false;
  double averageRespRate = 14.6;

  // Navigation index
  int _currentIndex = 0;

// Updated function in dashboard.dart
void _startMonitoring() async {
  // Start loading state
  setState(() {
    isMonitoring = true;
  });

  // Navigate to NewReadingPage and wait for result
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const NewReadingPage(),
    ),
  );

  // When returning from NewReadingPage:
  if (mounted) {
    setState(() {
      isMonitoring = false;
      if (result != null && result is Map) {
        totalReadings++;
        lastReading = DateTime.now();
        // Update average with new reading if available
        if (result.containsKey('respiratoryRate')) {
          averageRespRate = ((averageRespRate * (totalReadings - 1)) + 
                           result['respiratoryRate']) / totalReadings;
        }
      }
    });
  }
}

  // Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const side_dashboard.SideDashboard(),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.white),
            SizedBox(width: 8),
            Text("Respiratory Belt"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startMonitoring,
        tooltip: 'Start New Reading',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return _buildHomeTab();
    } else if (_currentIndex == 1) {
      return _buildHistoryTab();
    } else {
      return _buildProfileTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _buildWelcomeSection(),
          const SizedBox(height: 24),

          // Quick stats card
          _buildQuickStatsCard(),
          const SizedBox(height: 24),

          // Quick actions
          _buildQuickActionsCard(),
          const SizedBox(height: 24),

          // Recent readings
          _buildRecentReadingsSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome, $userName",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Monitor and track your respiratory health",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildQuickStatsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.insights, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Quick Stats",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.assignment, "Total Readings", "$totalReadings"),
                _buildStatItem(Icons.timer, "Last Reading", _formatDate(lastReading)),
                _buildStatItem(Icons.speed, "Avg. Rate", "${averageRespRate.toStringAsFixed(1)}/min"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (isMonitoring)
              const LinearProgressIndicator()
            else
              ElevatedButton(
                onPressed: _startMonitoring,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text("Start New Reading"),
              ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                // Navigate to history
                setState(() {
                  _currentIndex = 1;
                });
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text("View History"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReadingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Readings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (totalReadings == 0)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("No readings yet. Start your first reading!"),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.assignment, color: Colors.blue),
                title: const Text("Last Reading"),
                subtitle: Text(_formatDate(lastReading)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // View details of last reading
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return Center(
      child: Text("History Tab - $totalReadings readings"),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Text("Profile Tab - $userName"),
    );
  }
}