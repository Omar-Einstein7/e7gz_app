import 'package:e7gz/src/config/app_config.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_state.dart';
import 'package:e7gz/src/features/matchmaking/data/models/match_model.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/search/data/datasources/search_remote_datasource.dart';
import 'package:e7gz/src/di/injection_container.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _maxPlayersController = TextEditingController(text: '10');

  String? _selectedPitchId;
  String? _selectedPitchName;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _skillLevel = 'all';

  List<Pitch> _availablePitches = [];
  double _pricePerPlayer = 150.0;
  bool _isLoadingPitches = true;

  @override
  void initState() {
    super.initState();
    _fetchPitches();
  }

  Future<void> _fetchPitches() async {
    try {
      final ds = sl<SearchRemoteDataSource>();
      final pitches = await ds.searchPitches();
      if (mounted) {
        setState(() {
          _availablePitches = pitches;
          _isLoadingPitches = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingPitches = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'matchmaking.error_loading_pitches'.tr(
                namedArgs: {'error': e.toString()},
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;
    final colors = context.theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'matchmaking.host_title'.tr(),
          style: tt.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel('matchmaking.match_title_label'.tr(), tt),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  'matchmaking.match_title_hint'.tr(),
                ),
                validator: (v) => v!.isEmpty ? 'auth.required'.tr() : null,
              ),
              SizedBox(height: 24.h),

              _buildFieldLabel('matchmaking.select_pitch'.tr(), tt),
              _isLoadingPitches
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      value: _selectedPitchId,
                      dropdownColor: const Color(0xFF131B2E),
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        'matchmaking.choose_location'.tr(),
                      ),
                      items: _availablePitches
                          .map(
                            (p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(
                                p.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedPitchId = v),
                      validator: (v) => v == null ? 'auth.required'.tr() : null,
                    ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(
                          'bookings.date'.tr().toUpperCase(),
                          tt,
                        ),
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131B2E),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  IconsaxPlusLinear.calendar_1,
                                  color: Colors.white24,
                                  size: 20,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  _selectedDate == null
                                      ? 'matchmaking.select_date'.tr()
                                      : DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(_selectedDate!),
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? Colors.white24
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('matchmaking.start_time'.tr(), tt),
                        InkWell(
                          onTap: () => _pickTime(true),
                          child: _timeBox(
                            _startTime?.format(context) ?? '00:00',
                            _startTime != null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('matchmaking.end_time'.tr(), tt),
                        InkWell(
                          onTap: () => _pickTime(false),
                          child: _timeBox(
                            _endTime?.format(context) ?? '00:00',
                            _endTime != null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('matchmaking.max_players'.tr(), tt),
                        TextFormField(
                          controller: _maxPlayersController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('10'),
                          validator: (v) =>
                              v!.isEmpty ? 'auth.required'.tr() : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('matchmaking.price_player'.tr(), tt),
                        TextFormField(
                          initialValue: '150',
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('150'),
                          onChanged: (v) => setState(
                            () => _pricePerPlayer = double.tryParse(v) ?? 0,
                          ),
                          validator: (v) =>
                              v!.isEmpty ? 'auth.required'.tr() : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('matchmaking.skill_level'.tr(), tt),
                  DropdownButtonFormField<String>(
                    value: _skillLevel,
                    dropdownColor: const Color(0xFF131B2E),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(''),
                    items: ['all', 'beginner', 'intermediate', 'advanced']
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              s.toUpperCase(),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _skillLevel = v!),
                  ),
                ],
              ),

              SizedBox(height: 48.h),

              BlocBuilder<MatchmakingCubit, MatchmakingState>(
                builder: (context, state) {
                  return AppButton(
                    label: state.status == MatchmakingStatus.loading
                        ? 'booking_slots.creating'.tr().toUpperCase()
                        : 'matchmaking.publish_match'.tr(),
                    isFullWidth: true,
                    isLoading: state.status == MatchmakingStatus.loading,
                    onPressed: _submit,
                  );
                },
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeBox(String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          const Icon(IconsaxPlusLinear.clock, color: Colors.white24, size: 20),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(color: isSelected ? Colors.white : Colors.white24),
          ),
        ],
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4BE277),
            onPrimary: Colors.black,
            surface: Color(0xFF131B2E),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? const TimeOfDay(hour: 20, minute: 0)
          : const TimeOfDay(hour: 21, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4BE277),
            onPrimary: Colors.black,
            surface: Color(0xFF131B2E),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart)
          _startTime = picked;
        else
          _endTime = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('matchmaking.select_date_time_warning'.tr())),
        );
        return;
      }

      final startTimeStr =
          '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
      final endTimeStr =
          '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';

      final selectedPitch = _availablePitches.firstWhere(
        (p) => p.id == _selectedPitchId,
      );
      final sportType = selectedPitch.sportType;

      final match = MatchModel(
        id: '', // Backend generates it
        title: _titleController.text,
        pitchId: _selectedPitchId!,
        creatorId: '', // Backend handles it
        date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        startTime: startTimeStr,
        endTime: endTimeStr,
        maxPlayers: int.parse(_maxPlayersController.text),
        participantIds: [],
        participants: [],
        pricePerPlayer: _pricePerPlayer,
        skillLevel: _skillLevel,
        status: 'open',
        sportType: sportType,
      );

      final cubit = context.read<MatchmakingCubit>();
      cubit.createMatch(match).then((_) {
        if (mounted && cubit.state.status == MatchmakingStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('matchmaking.create_success'.tr())),
          );
          context.pop();
        }
      });
    }
  }
}

