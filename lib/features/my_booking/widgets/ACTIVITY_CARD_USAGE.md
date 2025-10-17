# ActivityCard Usage Guide

## Overview
The `ActivityCard` widget has been redefined to work with the `JobRequest` model, displaying comprehensive job/booking information.

## Updated Parameters

### Required
- `jobRequest` (JobRequest): The job request object containing all booking details

### Optional Callbacks
- `onView` (VoidCallback?): Called when "View Details" button is pressed
- `onTrack` (VoidCallback?): Called when track location button is pressed
- `onCall` (VoidCallback?): Called when call button is pressed
- `onCancel` (VoidCallback?): Reserved for future cancel functionality

## Data Structure Support

The card now properly displays data from your `JobRequest` model:

```dart
{
  jobId: 'ewFCsF2bTK7IJXvuDvfF',
  customerLocation: { latitude: 6.927919250934141, longitude: 79.86065179109573 },
  customerId: '9UIbcw5WKpMGOCXnz38Ru7boy7m2',
  technicianId: 'egufYQ5ETd2KCpthMP0E',
  serviceCategory: 'vehicles',
  propertyInfo: {
    type: 'vehicle',
    propertyId: 'RlKtrjJXGXZz9Homo0TO',
    details: {
      brand: 'Toyota',
      model: 'Camry',
      year: '2020',
      registrationNumber: 'ABC-1234'
    }
  },
  selectedIssues: [ 'Engine Problem', 'Break not working' ],
  description: 'suddenly stopped the vehicle with a strange noice',
  createdAt: '2025-08-31T14:33:49.150711',
  updatedAt: '2025-08-31T14:33:54.405936',
  status: 'Confirmed'
}
```

## Display Features

### 1. **Header Section**
- Service category icon and color-coded badge
- Property title (e.g., "Toyota Camry" or property type)
- Status badge (Confirmed, Pending, Completed, Cancelled)
- Time ago display (e.g., "2h ago", "3d ago", or formatted date)

### 2. **Property Information**
- Vehicle: Shows registration number and year
- Home: Shows property address
- Icon indicates property type

### 3. **Issues Reported**
- Displays all selected issues as chips/tags
- Visually organized in a wrapped layout

### 4. **Description**
- Shows job description (if provided)
- Styled in a highlighted container
- Truncated to 2 lines with ellipsis

### 5. **Location**
- Displays latitude and longitude coordinates
- Only shown when customer location is available

### 6. **Technician Assignment**
- Shows when technician is assigned
- Displays technician ID
- Green-themed badge indicating assignment

### 7. **Action Buttons**
- **View Details**: Always visible
- **Track**: Shown when customer location is available
- **Call**: Shown when technician is assigned

## Usage Example

```dart
import 'package:fixme/features/my_booking/widgets/activity_card.dart';
import 'package:fixme/models/job_request.dart';

// In your widget
ListView.builder(
  itemCount: jobRequests.length,
  itemBuilder: (context, index) {
    final job = jobRequests[index];
    return ActivityCard(
      jobRequest: job,
      onView: () {
        // Navigate to job details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailsScreen(jobId: job.jobId),
          ),
        );
      },
      onTrack: () {
        // Open map to track location
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TrackingScreen(
              location: job.customerLocation,
            ),
          ),
        );
      },
      onCall: () {
        // Make call to technician
        // You'll need to fetch technician phone number
        _callTechnician(job.technicianId);
      },
    );
  },
)
```

## Status Color Coding

- **Confirmed**: Green
- **Pending**: Orange
- **Completed**: Blue
- **Cancelled**: Red
- **Default**: Grey

## Service Category Icons & Colors

### Vehicles
- Icon: `Icons.car_repair`
- Color: Blue

### Home
- Icon: `Icons.home_repair_service`
- Color: Green

### Paint
- Icon: `Icons.format_paint`
- Color: Purple

### Electrical
- Icon: `Icons.electrical_services`
- Color: Orange

### Plumbing
- Icon: `Icons.plumbing`
- Color: Teal

### Default
- Icon: `Icons.handyman`
- Color: Grey

## Time Display Logic

- < 60 minutes: "Xm ago"
- < 24 hours: "Xh ago"
- < 7 days: "Xd ago"
- >= 7 days: "MMM dd, yyyy"

## Notes

1. The card requires the `intl` package for date formatting
2. All property details are extracted from `propertyInfo.details` map
3. The card gracefully handles missing data with null checks
4. Action buttons are conditionally rendered based on available data
