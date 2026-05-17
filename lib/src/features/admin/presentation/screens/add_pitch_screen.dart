import 'dart:io';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import '../layout/admin_layout.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../../../di/injection_container.dart';

class AdminAddPitchScreen extends StatefulWidget {
  final Map<String, dynamic>? pitchData;
  const AdminAddPitchScreen({super.key, this.pitchData});

  @override
  State<AdminAddPitchScreen> createState() => _AdminAddPitchScreenState();
}

class _AdminAddPitchScreenState extends State<AdminAddPitchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _sportType = 'football';
  XFile? _pickedImage;
  bool _isLoading = false;

  LatLng _selectedLocation = const LatLng(30.0444, 31.2357); // Cairo
  final MapController _mapController = MapController();
  final loc.Location _locationService = loc.Location();

  final AdminRemoteDataSource _dataSource = sl<AdminRemoteDataSource>();
  final ImagePicker _picker = ImagePicker();
  bool get _isEdit => widget.pitchData != null;

  bool get _hasValidNetworkImage {
    if (!_isEdit) return false;
    final images = widget.pitchData!['images'];
    if (images == null || images is! List || images.isEmpty) return false;
    final firstImage = images[0];
    return firstImage != null && firstImage.toString().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final data = widget.pitchData!;
      _nameController.text = data['name'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _sportType = data['sportType'] ?? 'football';
      _priceController.text = (data['pricePerHour'] ?? 0).toString();
      
      final location = data['location'];
      if (location != null) {
        _addressController.text = location['address'] ?? '';
        _cityController.text = location['city'] ?? '';
        final coords = location['coordinates']?['coordinates'];
        if (coords != null && coords.length >= 2) {
          _selectedLocation = LatLng(coords[1], coords[0]);
        }
      }
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_selectedLocation, 15);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    final locationData = await _locationService.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      final newPos = LatLng(locationData.latitude!, locationData.longitude!);
      setState(() => _selectedLocation = newPos);
      _mapController.move(newPos, 15);
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
    );
    try {
      final response = await Dio().get<dynamic>(url.toString());
      final List results = response.data;
      if (results.isNotEmpty) {
        final lat = double.parse(results[0]['lat']);
        final lon = double.parse(results[0]['lon']);
        final newPos = LatLng(lat, lon);
        setState(() {
          _selectedLocation = newPos;
          _addressController.text = results[0]['display_name'];
        });
        _mapController.move(newPos, 15);
      }
    } catch (e) {
      AppLogger.error('Location search failed: $e');
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() => _selectedLocation = point);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final payload = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        "sportType": _sportType,
        "location": {
          "address": _addressController.text,
          "city": _cityController.text,
          "coordinates": {
            "type": "Point",
            "coordinates": [
              _selectedLocation.longitude,
              _selectedLocation.latitude,
            ],
          },
        },
        "pricePerHour": int.tryParse(_priceController.text) ?? 0,
        "openingTime": "08:00",
        "closingTime": "23:00",
      };

      bool success;
      if (_isEdit) {
        success = await _dataSource.updatePitch(
          widget.pitchData!['_id'] ?? widget.pitchData!['id'],
          payload,
          imageBytes: _pickedImage != null ? await _pickedImage!.readAsBytes() : null,
          fileName: _pickedImage?.name,
        );
      } else {
        success = await _dataSource.createPitch(
          payload,
          imageBytes: _pickedImage != null ? await _pickedImage!.readAsBytes() : null,
          fileName: _pickedImage?.name,
        );
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEdit ? 'Pitch updated successfully!' : 'Pitch added successfully!'),
              backgroundColor: AdminColors.accent,
            ),
          );
          context.pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEdit ? 'Failed to update pitch' : 'Failed to add pitch'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      appBar: AppBar(
        backgroundColor: AdminColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AdminColors.textPrimary,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(_isEdit ? 'Edit Pitch' : 'Add New Pitch', style: AdminTextStyles.pageTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image Picker ──────────────────────────────────────
              const Text('PITCH MEDIA', style: AdminTextStyles.label),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AdminColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AdminColors.border,
                      width: 2,
                      style: BorderStyle.none,
                    ),
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: kIsWeb
                                ? NetworkImage(_pickedImage!.path)
                                      as ImageProvider
                                : FileImage(File(_pickedImage!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _pickedImage == null && !_hasValidNetworkImage
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AdminColors.accent.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                IconsaxPlusBold.camera,
                                color: AdminColors.accent,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Click to upload pitch photo',
                              style: TextStyle(
                                color: AdminColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      : _pickedImage == null && _hasValidNetworkImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.pitchData!['images'][0],
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                              ),
                            )
                          : Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Form Fields ───────────────────────────────────────
              _buildTextField(
                'PITCH NAME',
                _nameController,
                'e.g. Champions Arena',
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown('SPORT TYPE', [
                      'football',
                      'padel',
                      'tennis',
                      'basketball',
                    ]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'PRICE / HOUR (EGP)',
                      _priceController,
                      '350',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField('CITY', _cityController, 'Cairo'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'ADDRESS',
                      _addressController,
                      'Nasr City, Cairo',
                      suffixIcon: IconButton(
                        icon: const Icon(
                          IconsaxPlusLinear.search_normal_1,
                          color: AdminColors.accent,
                          size: 18,
                        ),
                        onPressed: () =>
                            _searchLocation(_addressController.text),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildTextField(
                'DESCRIPTION',
                _descriptionController,
                'Describe the pitch features...',
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // ── Location Picker (Map) ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('PITCH LOCATION', style: AdminTextStyles.label),
                  TextButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(
                      IconsaxPlusLinear.location,
                      size: 14,
                      color: AdminColors.accent,
                    ),
                    label: const Text(
                      'Current Location',
                      style: TextStyle(color: AdminColors.accent, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 250,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AdminColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AdminColors.border),
                ),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation,
                    initialZoom: 13,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.e7gz.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            IconsaxPlusBold.location,
                            color: AdminColors.accent,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // ── Submit Button ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AdminColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isEdit ? 'UPDATE PITCH' : 'CREATE PITCH',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AdminTextStyles.label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onFieldSubmitted: (value) {
            final icon = suffixIcon;
            if (icon is IconButton) {
              icon.onPressed?.call();
            }
          },
          style: const TextStyle(color: AdminColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AdminColors.textMuted),
            filled: true,
            fillColor: AdminColors.surface,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (v) => v!.isEmpty ? 'Field is required' : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AdminTextStyles.label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _sportType,
          dropdownColor: AdminColors.surfaceHigh,
          style: const TextStyle(color: AdminColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: AdminColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: items
              .map(
                (i) => DropdownMenuItem(value: i, child: Text(i.toUpperCase())),
              )
              .toList(),
          onChanged: (v) => setState(() => _sportType = v!),
        ),
      ],
    );
  }
}
