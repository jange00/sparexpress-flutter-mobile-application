import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparexpress/core/sensors/proximity_sensor_service.dart';

class ProximitySensorSettingsWidget extends StatefulWidget {
  const ProximitySensorSettingsWidget({super.key});

  @override
  State<ProximitySensorSettingsWidget> createState() => _ProximitySensorSettingsWidgetState();
}

class _ProximitySensorSettingsWidgetState extends State<ProximitySensorSettingsWidget> {
  final ProximitySensorService _proximityService = ProximitySensorService();
  bool _isEnabled = false;
  bool _showWarnings = true;
  bool _showVisualIndicator = true;
  bool _isAvailable = false;
  int _totalWarnings = 0;
  int _totalNearTime = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkAvailability();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isEnabled = prefs.getBool('proximity_sensor_enabled') ?? false;
      _showWarnings = prefs.getBool('proximity_warnings_enabled') ?? true;
      _showVisualIndicator = prefs.getBool('proximity_visual_indicator') ?? true;
      _totalWarnings = prefs.getInt('proximity_total_warnings') ?? 0;
      _totalNearTime = prefs.getInt('proximity_total_near_time') ?? 0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('proximity_sensor_enabled', _isEnabled);
    await prefs.setBool('proximity_warnings_enabled', _showWarnings);
    await prefs.setBool('proximity_visual_indicator', _showVisualIndicator);
  }

  Future<void> _checkAvailability() async {
    try {
      // Try to initialize to check availability
      final isAvailable = await _proximityService.initialize(context);
      setState(() {
        _isAvailable = isAvailable;
      });
    } catch (e) {
      setState(() {
        _isAvailable = false;
      });
    }
  }

  Future<void> _toggleProximitySensor(bool value) async {
    setState(() {
      _isEnabled = value;
    });
    await _saveSettings();
  }

  Future<void> _toggleWarnings(bool value) async {
    setState(() {
      _showWarnings = value;
    });
    await _saveSettings();
  }

  Future<void> _toggleVisualIndicator(bool value) async {
    setState(() {
      _showVisualIndicator = value;
    });
    await _saveSettings();
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${remainingSeconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    } else {
      return '${remainingSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.sensors,
                  color: Color(0xFFFFC107),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Proximity Sensor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _isAvailable 
                          ? 'Monitor device distance for eye health'
                          : 'Not available on this device',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (!_isAvailable) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Proximity sensor is not available on this device.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
            
            // Enable/Disable Switch
            SwitchListTile(
              title: const Text('Enable Proximity Monitoring'),
              subtitle: const Text('Monitor device distance from your face'),
              value: _isEnabled,
              onChanged: _toggleProximitySensor,
              activeColor: const Color(0xFFFFC107),
              contentPadding: EdgeInsets.zero,
            ),
            
            if (_isEnabled) ...[
              const SizedBox(height: 16),
              
              // Warning Settings
              SwitchListTile(
                title: const Text('Show Warning Messages'),
                subtitle: const Text('Display alerts when device is too close'),
                value: _showWarnings,
                onChanged: _toggleWarnings,
                activeColor: const Color(0xFFFFC107),
                contentPadding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 8),
              
              // Visual Indicator Settings
              SwitchListTile(
                title: const Text('Show Visual Indicator'),
                subtitle: const Text('Display on-screen indicator when device is near'),
                value: _showVisualIndicator,
                onChanged: _toggleVisualIndicator,
                activeColor: const Color(0xFFFFC107),
                contentPadding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 20),
              
              // Statistics
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Usage Statistics',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Warnings',
                            '$_totalWarnings',
                            Icons.warning,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Total Near Time',
                            _formatDuration(_totalNearTime),
                            Icons.timer,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'How it works',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Warns after 3 seconds of close usage\n'
                      '• Critical warning after 10 seconds\n'
                      '• Helps prevent eye strain and discomfort\n'
                      '• Monitors device proximity automatically',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 