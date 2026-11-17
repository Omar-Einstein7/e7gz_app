import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_cubit.dart';
import 'package:e7gz/src/features/matchmaking/presentation/cubit/matchmaking_state.dart';
import 'package:e7gz/src/features/matchmaking/data/models/match_model.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';
import 'package:e7gz/src/features/search/data/datasources/search_remote_datasource.dart';
import 'package:e7gz/src/core/di/injection_container.dart';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/features/matchmaking/presentation/widgets/widgets.dart';

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
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _skillLevel = 'all';
  String? _creationTeam = 'teamA'; // Default to Team A for creator

  List<Pitch> _availablePitches = [];
  double _pricePerPlayer = 150;
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
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: cs.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'matchmaking.host_title'.tr(),
          style: tt.titleLarge?.copyWith(
            color: cs.onSurface,
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
              MatchmakingFieldLabel(
                label: 'matchmaking.match_title_label'.tr(),
              ),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: cs.onSurface),
                decoration: _inputDecoration(
                  'matchmaking.match_title_hint'.tr(),
                  cs,
                ),
                validator: (v) => v!.isEmpty ? 'auth.required'.tr() : null,
              ),
              SizedBox(height: 24.h),

              MatchmakingFieldLabel(label: 'matchmaking.select_pitch'.tr()),
              if (_isLoadingPitches)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedPitchId,
                  dropdownColor: cs.surfaceContainer,
                  style: TextStyle(color: cs.onSurface),
                  decoration: _inputDecoration(
                    'matchmaking.choose_location'.tr(),
                    cs,
                  ),
                  items: _availablePitches
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.name, overflow: TextOverflow.ellipsis),
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
                        MatchmakingFieldLabel(
                          label: 'bookings.date'.tr().toUpperCase(),
                        ),
                        InkWell(
                          onTap: () => _pickDate(cs),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainer,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  IconsaxPlusLinear.calendar_1,
                                  color: cs.onSurfaceVariant,
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
                                        ? cs.onSurfaceVariant
                                        : cs.onSurface,
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
                        MatchmakingFieldLabel(
                          label: 'matchmaking.start_time'.tr(),
                        ),
                        InkWell(
                          onTap: () => _pickTime(true, cs),
                          child: MatchmakingTimeBox(
                            text: _startTime?.format(context) ?? '00:00',
                            isSelected: _startTime != null,
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
                        MatchmakingFieldLabel(
                          label: 'matchmaking.end_time'.tr(),
                        ),
                        InkWell(
                          onTap: () => _pickTime(false, cs),
                          child: MatchmakingTimeBox(
                            text: _endTime?.format(context) ?? '00:00',
                            isSelected: _endTime != null,
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
                        MatchmakingFieldLabel(
                          label: 'matchmaking.max_players'.tr(),
                        ),
                        TextFormField(
                          controller: _maxPlayersController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: cs.onSurface),
                          decoration: _inputDecoration('10', cs),
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
                        MatchmakingFieldLabel(
                          label: 'matchmaking.price_player'.tr(),
                        ),
                        TextFormField(
                          initialValue: '150',
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: cs.onSurface),
                          decoration: _inputDecoration('150', cs),
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
                  MatchmakingFieldLabel(label: 'matchmaking.skill_level'.tr()),
                  DropdownButtonFormField<String>(
                    initialValue: _skillLevel,
                    dropdownColor: cs.surfaceContainer,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _inputDecoration('', cs),
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
              SizedBox(height: 24.h),

              MatchmakingFieldLabel(label: 'matchmaking.select_your_team'.tr()),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _creationTeam = 'teamA'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: _creationTeam == 'teamA'
                              ? cs.error.withValues(alpha: 0.15)
                              : cs.surfaceContainer,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: _creationTeam == 'teamA'
                                ? cs.error
                                : cs.outlineVariant,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Team A',
                            style: TextStyle(
                              color: _creationTeam == 'teamA'
                                  ? cs.error
                                  : cs.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _creationTeam = 'teamB'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: _creationTeam == 'teamB'
                              ? cs.primary.withValues(alpha: 0.15)
                              : cs.surfaceContainer,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: _creationTeam == 'teamB'
                                ? cs.primary
                                : cs.outlineVariant,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Team B',
                            style: TextStyle(
                              color: _creationTeam == 'teamB'
                                  ? cs.primary
                                  : cs.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
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

  InputDecoration _inputDecoration(String hint, ColorScheme cs) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cs.onSurfaceVariant),
      filled: true,
      fillColor: cs.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    );
  }

  Future<void> _pickDate(ColorScheme cs) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(bool isStart, ColorScheme cs) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? const TimeOfDay(hour: 20, minute: 0)
          : const TimeOfDay(hour: 21, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
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
        id: '',
        title: _titleController.text,
        pitchId: _selectedPitchId!,
        creatorId: '',
        date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        startTime: startTimeStr,
        endTime: endTimeStr,
        maxPlayers: int.parse(_maxPlayersController.text),
        participantIds: const [],
        participants: const [],
        teamA: const [],
        teamB: const [],
        pricePerPlayer: _pricePerPlayer,
        skillLevel: _skillLevel,
        status: 'open',
        sportType: sportType,
        team: _creationTeam,
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
