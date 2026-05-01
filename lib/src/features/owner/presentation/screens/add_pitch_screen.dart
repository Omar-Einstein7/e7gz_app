import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/admin/data/datasources/admin_remote_datasource.dart';
import '../cubit/owner_cubit.dart';

class AddPitchScreen extends StatefulWidget {
  const AddPitchScreen({super.key});

  @override
  State<AddPitchScreen> createState() => _AddPitchScreenState();
}

class _AddPitchScreenState extends State<AddPitchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _sportType = 'football';

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Add New Pitch', style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Placeholder
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(IconsaxPlusLinear.camera, color: Color(0xFF4BE277), size: 48),
                    SizedBox(height: 12.h),
                    Text('Upload Pitch Photos', style: TextStyle(color: const Color(0xFFBCC7DE), fontSize: 14.sp)),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              _buildFieldLabel('PITCH NAME', tt),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Enter pitch name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 24.h),

              _buildFieldLabel('SPORT TYPE', tt),
              DropdownButtonFormField<String>(
                initialValue: _sportType,
                dropdownColor: const Color(0xFF131B2E),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(''),
                items: ['football', 'padel', 'tennis', 'basketball']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase())))
                    .toList(),
                onChanged: (v) => setState(() => _sportType = v!),
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('CITY', tt),
                        TextFormField(
                          controller: _cityController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('e.g. Cairo'),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('PRICE / HOUR', tt),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('EGP'),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              _buildFieldLabel('ADDRESS', tt),
              TextFormField(
                controller: _addressController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Full address'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 24.h),

              _buildFieldLabel('DESCRIPTION', tt),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Tell players about your pitch...'),
              ),
              SizedBox(height: 48.h),

              AppButton(
                label: 'CREATE PITCH',
                isFullWidth: true,
                onPressed: _submit,
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, TextTheme tt) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFFBCC7DE),
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24),
      filled: true,
      fillColor: const Color(0xFF131B2E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final scaffold = ScaffoldMessenger.of(context);
      
      try {
        final dataSource = AdminRemoteDataSource();
        final success = await dataSource.createPitch({
          "name": _nameController.text,
          "description": _descriptionController.text,
          "sportType": _sportType,
          "location": {
            "address": _addressController.text,
            "city": _cityController.text,
            "coordinates": {
              "type": "Point",
              "coordinates": [31.2357, 30.0444] // Default to Cairo center for now
            }
          },
          "pricePerHour": int.tryParse(_priceController.text) ?? 350,
          "openingTime": "08:00",
          "closingTime": "23:00",
          "amenities": ["Parking", "Showers", "Lights"]
        });

        if (success) {
          scaffold.showSnackBar(const SnackBar(content: Text('Pitch created successfully!')));
          if (mounted) context.pop();
        } else {
          scaffold.showSnackBar(const SnackBar(content: Text('Failed to create pitch. Please try again.')));
        }
      } catch (e) {
        scaffold.showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
