import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/home_profile.dart';
import 'package:fixme/screens/Profile/customer_edit_home.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        Alignment,
        Border,
        BorderRadius,
        BoxDecoration,
        BoxFit,
        BuildContext,
        Center,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        DecorationImage,
        EdgeInsets,
        Expanded,
        FlexibleSpaceBar,
        FontWeight,
        GestureDetector,
        Icon,
        Icons,
        InkWell,
        LinearGradient,
        MainAxisAlignment,
        Material,
        MaterialPageRoute,
        Navigator,
        NetworkImage,
        Padding,
        RoundedRectangleBorder,
        Row,
        Scaffold,
        ScaffoldMessenger,
        SizedBox,
        SliverAppBar,
        SnackBar,
        State,
        StatefulWidget,
        Text,
        TextButton,
        TextStyle,
        Widget,
        showDialog;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


class CustomerHomeProfile extends StatefulWidget {
  final String? homeId;

  const CustomerHomeProfile({super.key, this.homeId});

  @override
  State<CustomerHomeProfile> createState() => _CustomerHomeProfileState();
}

class _CustomerHomeProfileState extends State<CustomerHomeProfile> {
  static const Color _primaryColor = Color(0xFF2563EB);
  static const Color _primaryLight = Color(0xFF60A5FA);
  static const Color _surface = Color(0xFFFAFBFC);
  static const Color _cardColor = Colors.white;

  late ProfileController profileController;
  HomeProfile? currentHome;

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();
    _loadHomeData();
  }

  void _loadHomeData() {
    if (widget.homeId != null) {
      currentHome = profileController.getHomeById(widget.homeId!);
    } else {
      currentHome = profileController.getDefaultHome();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (currentHome == null) {
      return Scaffold(
        backgroundColor: _surface,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _primaryLight.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.home_outlined,
                          size: 60,
                          color: _primaryLight,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Home Not Found',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The requested home profile could not be loaded',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: _surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildHomeImageCard(),
                  const SizedBox(height: 20),
                  _buildHomeDetailsCard(),
                  const SizedBox(height: 20),
                  if (currentHome!.owner != null) _buildOwnerCard(),
                  if (currentHome!.owner != null) const SizedBox(height: 20),
                  if (currentHome!.map != null) _buildLocationCard(),
                  if (currentHome!.map != null) const SizedBox(height: 20),
                  _buildEditButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 90.0,
      floating: false,
      pinned: true,
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          currentHome?.name ?? 'Home Profile',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, _primaryLight],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeImageCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: currentHome!.imageUrl.isEmpty ? _handleImageEdit : null,
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  image: currentHome!.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(currentHome!.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: currentHome!.imageUrl.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _primaryLight.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 48,
                              color: _primaryLight,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to add home image',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            if (currentHome!.imageUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: _primaryColor,
                    onPressed: _handleImageEdit,
                  ),
                  const SizedBox(width: 16),
                  _buildImageActionButton(
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    color: Colors.red[600]!,
                    onPressed: _showDeleteImageDialog,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Text(
              currentHome!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              currentHome!.homeType,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeDetailsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailGrid([
              {
                'label': 'Address',
                'value': currentHome!.address,
                'fullWidth': true,
              },
              if (currentHome!.landmark != null)
                {
                  'label': 'Landmark',
                  'value': currentHome!.landmark!,
                  'fullWidth': true,
                },
              {'label': 'City', 'value': currentHome!.city},
              {'label': 'Area', 'value': currentHome!.area},
              {'label': 'Postal Code', 'value': currentHome!.postalCode},
              {'label': 'Phone', 'value': currentHome!.phone},
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Owner Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailGrid([
              {
                'label': 'Owner Name',
                'value': currentHome!.owner!['name'] ?? '',
              },
              {
                'label': 'Owner Email',
                'value': currentHome!.owner!['email'] ?? '',
              },
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailGrid([
              {
                'label': 'Latitude',
                'value': currentHome!.map!['latitude'].toString(),
              },
              {
                'label': 'Longitude',
                'value': currentHome!.map!['longitude'].toString(),
              },
            ]),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primaryColor.withOpacity(0.1),
                    _primaryLight.withOpacity(0.05),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _primaryColor.withOpacity(0.2)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () =>
                      _openLocation(currentHome!.map!['googleMapUrl'] ?? ''),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: _primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Open in Google Maps',
                        style: TextStyle(
                          color: _primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid(List<Map<String, dynamic>> details) {
    return Column(
      children: [
        for (int i = 0; i < details.length; i++)
          if (details[i]['fullWidth'] == true)
            Padding(
              padding: EdgeInsets.only(
                bottom: i < details.length - 1 ? 20.0 : 0,
              ),
              child: _buildDetailItem(
                details[i]['label']!,
                details[i]['value']!,
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(
                bottom: i < details.length - 1 ? 20.0 : 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      details[i]['label']!,
                      details[i]['value']!,
                    ),
                  ),
                  if (i + 1 < details.length &&
                      details[i + 1]['fullWidth'] != true) ...[
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildDetailItem(
                        details[i + 1]['label']!,
                        details[i + 1]['value']!,
                      ),
                    ),
                  ],
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _primaryLight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _showEditDialog,
          child: const Center(
            child: Text(
              'Edit Home Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Home Details',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          content: const Text(
            'Would you like to edit your home details?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _primaryLight],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerEditHome(homeProfile: currentHome!),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleImageEdit() {
    // Simulate image picking (in a real app, use image_picker package)
    setState(() {
      currentHome = currentHome!.copyWith(
        imageUrl: 'https://via.placeholder.com/300',
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Image updated successfully'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  void _showDeleteImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Image',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          content: const Text(
            'Are you sure you want to delete this image?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      currentHome = currentHome!.copyWith(imageUrl: '');
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Image deleted successfully'),
                        backgroundColor: Colors.red[600],
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openLocation(String location) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening location: $location'),
        backgroundColor: _primaryColor,
      ),
    );
  }
}
