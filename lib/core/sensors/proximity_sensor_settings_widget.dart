import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparexpress/core/sensors/proximity_sensor_service.dart';

class ProximitySensorSettingsWidget extends StatefulWidget {
  const ProximitySensorSettingsWidget({Key? key}) : super(key: key);

  @override
  State<ProximitySensorSettingsWidget> createState() => _ProximitySensorSettingsWidgetState();
}

class _ProximitySensorSettingsWidgetState extends State<ProximitySensorSettingsWidget> {
  bool _isEnabled = false;
  String _sensitivityLevel = 'high';
  final ProximitySensorService _proximityService = ProximitySensorService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isEnabled = prefs.getBool('proximity_sensor_enabled') ?? false;
      _sensitivityLevel = prefs.getString('proximity_sensor_sensitivity') ?? 'high';
    });
    
    // Apply sensitivity setting to service
    _proximityService.setSensitivity(_sensitivityLevel);
  }

  Future<void> _toggleProximitySensor(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('proximity_sensor_enabled', value);
    
    setState(() {
      _isEnabled = value;
    });
    
    if (value) {
      // Initialize proximity sensor if enabled
      _proximityService.initialize(context);
    } else {
      // Disable proximity sensor
      _proximityService.dispose();
    }
  }

  Future<void> _setSensitivity(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('proximity_sensor_sensitivity', level);
    
    setState(() {
      _sensitivityLevel = level;
    });
    
    // Apply sensitivity setting to service
    _proximityService.setSensitivity(level);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sensors,
                  color: _isEnabled ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Proximity Sensor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _isEnabled,
                  onChanged: _toggleProximitySensor,
                  activeColor: Colors.green,
                ),
              ],
            ),
            if (_isEnabled) ...[
              const SizedBox(height: 16),
              const Text(
                'Sensitivity Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildSensitivityButton('High', 'high', Colors.red),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSensitivityButton('Medium', 'medium', Colors.orange),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSensitivityButton('Low', 'low', Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Current Setting: $_sensitivityLevel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSensitivityDescription(_sensitivityLevel),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSensitivityButton(String label, String value, Color color) {
    final isSelected = _sensitivityLevel == value;
    return ElevatedButton(
      onPressed: () => _setSensitivity(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: isSelected ? 2 : 0,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  String _getSensitivityDescription(String level) {
    switch (level) {
      case 'high':
        return 'Very sensitive - triggers quickly when device is near face';
      case 'medium':
        return 'Moderate sensitivity - balanced response time';
      case 'low':
        return 'Less sensitive - requires longer proximity to trigger';
      default:
        return 'Standard sensitivity setting';
    }
  }
} 