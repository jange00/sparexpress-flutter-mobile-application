# Proximity Sensor Implementation

## 🎯 Overview

This implementation provides a comprehensive proximity sensor system for the SpareXpress app that monitors device distance from the user's face and provides warnings to prevent eye strain and promote healthy device usage habits.

## ✨ Features

### 🔍 **Core Functionality**
- **Real-time Monitoring**: Continuously monitors device proximity
- **Smart Warnings**: Progressive warning system (3s, 10s, then every 5s)
- **Visual Indicators**: On-screen indicators when device is too close
- **Statistics Tracking**: Tracks total warnings and near-time usage
- **Settings Management**: User-configurable preferences

### 🛡️ **Health & Safety**
- **Eye Strain Prevention**: Warns users when device is too close
- **Usage Awareness**: Helps users develop better device habits
- **Progressive Alerts**: Escalating warnings for prolonged close usage
- **Break Reminders**: Suggests taking breaks during extended use

### 🎨 **User Experience**
- **Non-intrusive**: Subtle warnings that don't interrupt usage
- **Customizable**: Users can enable/disable features
- **Visual Feedback**: Clear indicators and statistics
- **Smart Pausing**: Automatically pauses when app is backgrounded

## 📱 **How It Works**

### **Warning System:**
1. **3 seconds**: First warning - "Device too close!"
2. **10 seconds**: Critical warning - "Critical Warning!"
3. **Every 5 seconds**: Reminder - "Prolonged Close Usage"

### **Visual Indicators:**
- **Orange indicator** appears in top-right corner when device is near
- **SnackBar notifications** for warnings and confirmations
- **Settings panel** shows usage statistics and preferences

## 🏗️ **Architecture**

### **Core Components:**

1. **ProximitySensorService** (`lib/core/sensors/proximity_sensor_service.dart`)
   - Main service for proximity monitoring
   - Handles warning logic and timing
   - Manages callbacks and state

2. **ProximitySensorWidget** (`lib/core/sensors/proximity_sensor_widget.dart`)
   - Wrapper widget for easy integration
   - Provides visual indicators
   - Handles lifecycle management

3. **ProximitySensorSettingsWidget** (`lib/core/sensors/proximity_sensor_settings_widget.dart`)
   - Settings interface for users
   - Statistics display
   - Configuration options

## 🚀 **Integration Guide**

### **1. Basic Integration**

Wrap your main app content with the proximity sensor widget:

```dart
import 'package:sparexpress/core/sensors/proximity_sensor_widget.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProximitySensorWidget(
      showVisualIndicator: true,
      enableWarnings: true,
      onProximityChanged: (isNear) {
        print('Device is ${isNear ? 'near' : 'far'}');
      },
      onWarning: (message) {
        print('Warning: $message');
      },
      child: MaterialApp(
        // Your app content
      ),
    );
  }
}
```

### **2. Add to Settings Page**

Include the settings widget in your account settings:

```dart
import 'package:sparexpress/core/sensors/proximity_sensor_settings_widget.dart';

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Other settings...
          const ProximitySensorSettingsWidget(),
          // More settings...
        ],
      ),
    );
  }
}
```

### **3. Custom Implementation**

For more control, use the service directly:

```dart
import 'package:sparexpress/core/sensors/proximity_sensor_service.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final ProximitySensorService _proximityService = ProximitySensorService();

  @override
  void initState() {
    super.initState();
    _initializeProximitySensor();
  }

  Future<void> _initializeProximitySensor() async {
    await _proximityService.initialize(context);
    _proximityService.setCallbacks(
      onProximityChanged: (isNear) {
        // Handle proximity changes
      },
      onWarning: (message) {
        // Handle warnings
      },
    );
  }

  @override
  void dispose() {
    _proximityService.dispose();
    super.dispose();
  }
}
```

## 📋 **Configuration Options**

### **ProximitySensorWidget Properties:**
- `showVisualIndicator`: Show on-screen indicator (default: true)
- `enableWarnings`: Enable warning messages (default: true)
- `onProximityChanged`: Callback for proximity state changes
- `onWarning`: Callback for warning messages

### **Settings Options:**
- **Enable Proximity Monitoring**: Turn on/off the entire feature
- **Show Warning Messages**: Enable/disable warning notifications
- **Show Visual Indicator**: Enable/disable on-screen indicator

## 🔧 **Platform Support**

### **Android:**
- ✅ Proximity sensor support
- ✅ Background monitoring
- ✅ Custom warning thresholds
- ✅ Statistics tracking

### **iOS:**
- ⚠️ Limited proximity sensor access
- ✅ Basic functionality works
- ⚠️ May require additional permissions

## 🧪 **Testing**

### **Test Scenarios:**

1. **Basic Functionality**
   - Cover proximity sensor with hand
   - Verify warnings appear after 3 seconds
   - Move hand away, verify warnings stop

2. **Warning Escalation**
   - Keep device near for 10+ seconds
   - Verify critical warning appears
   - Check for periodic reminders

3. **Settings Integration**
   - Toggle proximity monitoring on/off
   - Test warning message settings
   - Verify visual indicator settings

4. **Statistics Tracking**
   - Use device near face for extended periods
   - Check statistics in settings
   - Verify accurate time tracking

### **Testing Commands:**
```bash
# Test on Android device
flutter run -d android

# Test on iOS device
flutter run -d ios

# Test with specific device
flutter run -d <device-id>
```

## 🐛 **Troubleshooting**

### **Common Issues:**

1. **Proximity Sensor Not Available**
   - Check device compatibility
   - Verify sensor is not blocked
   - Test on different device

2. **Warnings Not Appearing**
   - Check settings are enabled
   - Verify app permissions
   - Test with hand covering sensor

3. **False Positives**
   - Adjust warning thresholds
   - Check for sensor interference
   - Test in different environments

### **Debug Information:**
```dart
// Enable debug logging
final proximityService = ProximitySensorService();
await proximityService.initialize(context);

// Check current state
print('Is near: ${proximityService.isNear}');
print('Near duration: ${proximityService.nearDuration}');
print('Is enabled: ${proximityService.isEnabled}');
```

## 📈 **Usage Statistics**

The system tracks:
- **Total Warnings**: Number of times warnings were shown
- **Total Near Time**: Cumulative time device was near face
- **Session Data**: Per-session proximity information

## 🔒 **Privacy & Permissions**

### **Required Permissions:**
- **Android**: No additional permissions required
- **iOS**: May require proximity sensor access

### **Data Collection:**
- **Local Only**: All data stored locally on device
- **No Network**: No data sent to servers
- **User Control**: Users can disable all features

## 🎯 **Best Practices**

1. **User Education**: Explain the health benefits
2. **Gradual Introduction**: Start with basic warnings
3. **Customization**: Allow users to adjust sensitivity
4. **Feedback**: Provide clear, actionable warnings
5. **Statistics**: Show usage patterns to encourage better habits

## 📞 **Support**

For issues with the proximity sensor implementation:

1. Check device compatibility
2. Verify sensor is not blocked
3. Test on different devices
4. Review debug logs
5. Check user settings

---

**Note**: This implementation promotes healthy device usage habits while providing a non-intrusive user experience. The system is designed to be helpful rather than annoying, with clear benefits for eye health and device usage awareness. 