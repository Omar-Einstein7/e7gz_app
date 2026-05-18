import 'dart:io';
import 'dart:convert';
import 'package:e7gz/src/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:e7gz/src/features/admin/presentation/cubit/admin_state.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import '../layout/admin_layout.dart';

import '../../../pitches/domain/entities/pitch.dart';

class AdminAddPitchScreen extends StatefulWidget {
  final Pitch? pitch;
  const AdminAddPitchScreen({super.key, this.pitch});

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
  final List<XFile> _pickedImages = [];
  List<String> _existingUrls = [];

  LatLng _selectedLocation = const LatLng(30.0444, 31.2357); // Cairo
  final MapController _mapController = MapController();
  final loc.Location _locationService = loc.Location();

  final ImagePicker _picker = ImagePicker();
  bool get _isEdit => widget.pitch != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final pitch = widget.pitch!;
      _nameController.text = pitch.name;
      _descriptionController.text = pitch.description;
      _sportType = pitch.sportType;
      _priceController.text = pitch.pricePerHour.toInt().toString();

      final location = pitch.location;
      _addressController.text = location.address;
      _cityController.text = location.city;
      _selectedLocation = LatLng(location.latitude, location.longitude);
      _existingUrls = List.from(pitch.images);

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

    // Nominatim REQUIRES a User-Agent and prefers descriptive ones
    final url =
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1';

    try {
      AppLogger.info('Searching location for: $query');

      final response = await Dio().get<dynamic>(
        url,
        options: Options(
          headers: {
            'User-Agent': 'e7gzz_flutter_app_location_picker',
            'Accept-Language': 'en',
          },
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      final List results = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (results.isNotEmpty) {
        final lat = double.tryParse(results[0]['lat'].toString()) ?? 0.0;
        final lon = double.tryParse(results[0]['lon'].toString()) ?? 0.0;

        if (lat != 0 && lon != 0) {
          final newPos = LatLng(lat, lon);
          setState(() {
            _selectedLocation = newPos;
            _addressController.text = results[0]['display_name'] ?? query;
          });
          _mapController.move(newPos, 15);
          AppLogger.info('Location found: $lat, $lon');
        }
      } else {
        showGlobalToast(
          message: 'No locations found for this address',
          status: 'error',
        );
      }
    } catch (e) {
      AppLogger.error('Location search failed: $e');
      showGlobalToast(
        message: 'Could not find location. Please try different keywords.',
        status: 'error',
      );
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() => _selectedLocation = point);
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 70);
    if (images.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingUrls.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

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
      "images": _existingUrls,
    };

    final List<List<int>> imageBytesList = [];
    final List<String> fileNames = [];

    for (var image in _pickedImages) {
      imageBytesList.add(await image.readAsBytes());
      fileNames.add(image.name);
    }

    if (_isEdit) {
      context.read<AdminCubit>().updatePitch(
        widget.pitch!.id,
        payload,
        multipleImageBytes: imageBytesList.isNotEmpty ? imageBytesList : null,
        multipleFileNames: fileNames.isNotEmpty ? fileNames : null,
      );
    } else {
      context.read<AdminCubit>().createPitch(
        payload,
        multipleImageBytes: imageBytesList.isNotEmpty ? imageBytesList : null,
        multipleFileNames: fileNames.isNotEmpty ? fileNames : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminState>(
      listenWhen: (previous, current) =>
          previous.isMutating != current.isMutating ||
          previous.mutationSuccess != current.mutationSuccess,
      listener: (context, state) {
        if (!state.isMutating) {
          if (state.mutationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEdit
                      ? 'Pitch updated successfully!'
                      : 'Pitch added successfully!',
                ),
                backgroundColor: AdminColors.accent,
              ),
            );
            context.pop(true);
          } else if (state.mutationError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mutationError!),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final _isLoading = state.isMutating;
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
            title: Text(
              _isEdit ? 'Edit Pitch' : 'Add New Pitch',
              style: AdminTextStyles.pageTitle,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PITCH MEDIA', style: AdminTextStyles.label),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Add Button
                        GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AdminColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AdminColors.accent.withOpacity(0.3),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  IconsaxPlusBold.add_square,
                                  color: AdminColors.accent,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add Pix',
                                  style: TextStyle(
                                    color: AdminColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Existing Images (if editing)
                        ..._existingUrls.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final url = entry.value;
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeExistingImage(idx),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.redAccent
                                          .withOpacity(0.8),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        // Picked Images
                        ..._pickedImages.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final img = entry.value;
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: kIsWeb
                                    ? NetworkImage(img.path) as ImageProvider
                                    : FileImage(File(img.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(idx),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black54,
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
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
                        child: _buildTextField(
                          'CITY',
                          _cityController,
                          'Cairo',
                        ),
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
                      const Text(
                        'PITCH LOCATION',
                        style: AdminTextStyles.label,
                      ),
                      TextButton.icon(
                        onPressed: _getCurrentLocation,
                        icon: const Icon(
                          IconsaxPlusLinear.location,
                          size: 14,
                          color: AdminColors.accent,
                        ),
                        label: const Text(
                          'Current Location',
                          style: TextStyle(
                            color: AdminColors.accent,
                            fontSize: 12,
                          ),
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
      },
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
