import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../models/event.dart';
import '../utils/theme.dart';
import '../widgets/animated_list_item.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Event> _getEventsForDay(DateTime day, List<Event> allEvents) {
    return allEvents.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = _getEventsForDay(_selectedDay!, eventProvider.events);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Calendrier', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TableCalendar(
                locale: 'fr_FR',
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: (day) {
                  return _getEventsForDay(day, eventProvider.events);
                },

                // Styling
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                  leftChevronIcon: Icon(Icons.chevron_left, color: AppTheme.primaryColor),
                  rightChevronIcon: Icon(Icons.chevron_right, color: AppTheme.primaryColor),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: isDark ? Colors.grey : const Color(0xFF555555), fontWeight: FontWeight.bold),
                  weekendStyle: TextStyle(color: isDark ? Colors.grey : const Color(0xFF555555), fontWeight: FontWeight.bold),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                  weekendTextStyle: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                  outsideTextStyle: TextStyle(color: isDark ? Colors.grey.withOpacity(0.5) : const Color(0xFFAAAAAA)),
                  selectedDecoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: isDark ? Colors.white : AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 20)),

          // Date Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  toBeginningOfSentenceCase(DateFormat('EEEE d MMMM', 'fr_FR').format(_selectedDay!)) ?? '',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 20)),

          // Events List or Empty State as slivers
          if (events.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(textColor, isDark),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final event = events[index];
                  return AnimatedListItem(
                    index: index,
                    delay: const Duration(milliseconds: 80),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFF5F8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border(left: BorderSide(color: AppTheme.primaryColor, width: 4)),
                      ),
                      child: ListTile(
                        title: Text(
                          event.title,
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.description,
                              style: TextStyle(color: isDark ? textColor.withOpacity(0.7) : const Color(0xFF666666)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: AppTheme.primaryColor),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('HH:mm').format(event.date),
                                  style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12),
                                ),
                                if (event.location.isNotEmpty) ...[
                                  const SizedBox(width: 12),
                                  Icon(Icons.location_on, size: 14, color: isDark ? Colors.grey : const Color(0xFF888888)),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.location,
                                    style: TextStyle(color: isDark ? Colors.grey : const Color(0xFF888888), fontSize: 12),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: events.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, bool isDark) {
    final emptyTextColor = isDark ? Colors.white : Colors.grey;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/images/journee_libre.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.calendar_today, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Journée libre',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aucun événement prévu pour cette date',
              style: TextStyle(
                color: emptyTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
