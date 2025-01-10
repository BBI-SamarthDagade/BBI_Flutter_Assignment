import 'package:flutter/material.dart';
import 'package:taskapp/core/utils/constants.dart';


class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(helpTitle),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              SizedBox(height: 16),
              _buildSectionTitle(featuresTitle),
              _buildFeatureList(),
              SizedBox(height: 16),
              _buildSectionTitle(gettingStartedTitle),
              _buildGettingStartedSteps(),
              SizedBox(height: 16),
              _buildNavigationTips(),
              SizedBox(height: 16),
              _buildSupportSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(welcomeTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(welcomeMessage, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: featuresList
          .map(
            (feature) => Card(
              margin: EdgeInsets.symmetric(vertical: 4.0),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text(feature),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildGettingStartedSteps() {
    return Column(
      children: gettingStartedSteps
          .asMap()
          .entries
          .map((entry) => Card(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text('${entry.key + 1}', style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(entry.value),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildNavigationTips() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(navigationTipsTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...navigationTips.map((tip) => _buildTipItem(tip['icon'], tip['text'])).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String tip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        SizedBox(width: 8),
        Expanded(child: Text(tip, style: TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.help_outline, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(supportTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(supportMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.email),
              label: Text(contactSupportButtonText, style: TextStyle(fontSize: 16)),
              onPressed: () {
                // Navigate to Contact Us page or handle support actions
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
