import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../utils/theme.dart';
import '../widgets/animated_button.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'Personnel';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  
  bool _hasReminder = false;
  int? _selectedReminderMinutes = 30; // Default to 30 min if reminder is on

  final List<String> _categories = ['Personnel', 'Professionnel', 'Autre'];
  final List<int> _reminderOptions = [5, 15, 30, 60, 1440]; // Minutes (60 = 1h, 1440 = 1j)

  String _formatReminderText(int minutes) {
    if (minutes < 60) return '$minutes min';
    if (minutes == 60) return '1 heure';
    if (minutes == 1440) return '1 jour';
    return '$minutes min';
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Professionnel':
        return Colors.blue;
      case 'Autre':
        return Colors.amber;
      case 'Personnel':
      default:
        return AppTheme.primaryColor;
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _createEvent() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un titre')),
      );
      return;
    }

    final eventDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newEvent = Event(
      title: _titleController.text,
      description: _descriptionController.text,
      date: eventDate,
      category: _selectedCategory,
      location: _locationController.text,
      reminderMinutes: _hasReminder ? _selectedReminderMinutes : null,
    );

    Provider.of<EventProvider>(context, listen: false).addEvent(newEvent);
    
    // Show success and maybe navigate back or clear
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Événement créé avec succès')),
    );
    
    // Clear form or redirect? 
    // The design is a screen in a tab, so maybe just clear form.
    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = 'Personnel';
      _hasReminder = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Nouvel événement',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Title
              Text(
                'Titre de l\'événement',
                style: TextStyle(color: isDark ? Colors.grey : const Color(0xFF555555), fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _titleController,
                style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Entrez le titre',
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
                ),
              ),
              const SizedBox(height: 24),

              // Category
              Text(
                'Catégorie',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  final categoryColor = _getCategoryColor(category);
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = category);
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0E8F5),
                      selectedColor: categoryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? categoryColor : Colors.transparent),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Date & Time
              Text('Date et heure', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5E8F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppTheme.primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_selectedDate),
                              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A), fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5E8F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: AppTheme.primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _selectedTime.format(context),
                              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Location
              Text('Localisation', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5E8F0),
                  prefixIcon: Icon(Icons.location_on_outlined, color: isDark ? Colors.grey : const Color(0xFF888888)),
                  hintText: 'Ex: 48.8566, 2.3522 (latitude, longitude)',
                  hintStyle: TextStyle(color: isDark ? Colors.grey : const Color(0xFF999999), fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Description
              Text('Description', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5E8F0),
                  hintText: 'Ajouter une description',
                  hintStyle: TextStyle(color: isDark ? Colors.grey : const Color(0xFF999999)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),

              // Reminder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_none, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text('Rappel', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Switch(
                    value: _hasReminder,
                    onChanged: (val) => setState(() => _hasReminder = val),
                    activeColor: AppTheme.primaryColor,
                    activeTrackColor: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                ],
              ),
              
              if (_hasReminder) ...[
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _reminderOptions.map((minutes) {
                      final isSelected = _selectedReminderMinutes == minutes;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(_formatReminderText(minutes)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedReminderMinutes = minutes);
                          },
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0E8F5),
                          selectedColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none, // Remove border
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              
              const SizedBox(height: 40),

              // Submit Button
              AnimatedButton(
                onPressed: _createEvent,
                backgroundColor: const Color(0xFF883B5E),
                width: double.infinity,
                height: 50,
                borderRadius: BorderRadius.circular(25),
                child: const Text(
                  'Créer l\'événement',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
