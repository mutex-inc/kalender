import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day_gesture_detector.dart';
import 'package:kalender/src/components/gesture_detectors/multi_day_tile_gesture_detector.dart';
import 'package:kalender/src/components/tile_stacks/chaning_multi_day_event_stack.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/calendar_components.dart';
import 'package:kalender/src/models/calendar_state.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class PositionedMultiDayTileStack<T extends Object?> extends StatelessWidget {
  const PositionedMultiDayTileStack({
    super.key,
    required this.pageWidth,
    required this.dayWidth,
    required this.multiDayEventLayout,
  });

  /// The width of the page.
  final double pageWidth;

  /// The width a single day.
  final double dayWidth;

  /// The [MultiDayLayoutController]
  final MultiDayLayoutController<T> multiDayEventLayout;

  @override
  Widget build(BuildContext context) {
    CalendarController<T> controller = CalendarInternals.of<T>(context).controller;
    CalendarViewState state = CalendarInternals.of<T>(context).state;
    CalendarComponents<T> components = CalendarInternals.of<T>(context).components;

    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          List<PositionedMultiDayTileData<T>> arragedEvents = multiDayEventLayout.arrageEvents(
            controller.getMultidayEventsFromDateRange(
              state.visibleDateRange.value,
            ),
            selectedEvent: controller.chaningEvent,
          );

          int numberOfRows = multiDayEventLayout.stackHeight ~/ multiDayEventLayout.tileHeight;
          double stackHeight = multiDayEventLayout.stackHeight;


          return SizedBox(
            width: pageWidth,
            height: stackHeight,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        components.daySepratorBuilder(
                          15,
                          dayWidth,
                          state.visibleDateRange.value.duration.inDays,
                        ),
                      ],
                    ),
                  ],
                ),
                MultiDayGestureDetector<T>(
                  controller: controller,
                  pageWidth: pageWidth,
                  height: stackHeight,
                  dayWidth: dayWidth,
                  multidayEventHeight: multiDayEventLayout.tileHeight,
                  numberOfRows: numberOfRows,
                  visibleDates: state.visibleDateRange.value.datesSpanned,
                ),
                ...arragedEvents.map(
                  (PositionedMultiDayTileData<T> e) {
                    return MultidayTileStack<T>(
                      controller: controller,
                      onEventChanged: CalendarInternals.of<T>(context).functions.onEventChanged,
                      onEventTapped: CalendarInternals.of<T>(context).functions.onEventTapped,
                      visibleDateRange: state.visibleDateRange.value,
                      multiDayEventLayout: multiDayEventLayout,
                      arragnedEvent: e,
                      dayWidth: dayWidth,
                      horizontalDurationStep: const Duration(days: 1),
                    );
                  },
                ).toList(),
                ChaningMultiDayEventStack<T>(
                  multiDayEventLayout: multiDayEventLayout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MultidayTileStack<T extends Object?> extends StatelessWidget {
  const MultidayTileStack({
    super.key,
    required this.controller,
    required this.onEventTapped,
    required this.onEventChanged,
    required this.visibleDateRange,
    required this.multiDayEventLayout,
    required this.arragnedEvent,
    required this.dayWidth,
    required this.horizontalDurationStep,
  });

  final CalendarController<T> controller;

  /// The [Function] called when the event is changed.
  final Function(DateTimeRange initialDateTimeRange, CalendarEvent<T> event)? onEventChanged;

  /// The [Function] called when the event is tapped.
  final Function(CalendarEvent<T> event)? onEventTapped;

  final DateTimeRange visibleDateRange;
  final MultiDayLayoutController<T> multiDayEventLayout;
  final PositionedMultiDayTileData<T> arragnedEvent;

  final double dayWidth;
  final Duration horizontalDurationStep;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        bool isMoving = controller.chaningEvent == arragnedEvent.event;
        return Stack(
          children: [
            Positioned(
              top: arragnedEvent.top,
              left: arragnedEvent.left,
              width: arragnedEvent.width,
              height: arragnedEvent.height,
              child: MultiDayTileGestureDetector(
                horizontalDurationStep: horizontalDurationStep,
                dayWidth: dayWidth,
                initialDateTimeRange: arragnedEvent.event.dateTimeRange,
                onTap: _onTap,
                onHorizontalDragStart: _onHorizontalDragStart,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                rescheduleEvent: _rescheduleEvent,
                child: CalendarInternals.of<T>(context).components.multiDayEventTileBuilder(
                      arragnedEvent.event,
                      isMoving ? TileType.ghost : TileType.normal,
                      arragnedEvent.continuesBefore,
                      arragnedEvent.continuesAfter,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onTap() async {
    controller.isMultidayEvent = true;
    controller.chaningEvent = arragnedEvent.event;
    await onEventTapped?.call(controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMultidayEvent = false;
  }

  void _onHorizontalDragStart() {
    controller.isMultidayEvent = true;
    controller.chaningEvent = arragnedEvent.event;
  }

  void _onHorizontalDragEnd() {
    onEventChanged?.call(arragnedEvent.dateRange, controller.chaningEvent!);
    controller.chaningEvent = null;
    controller.isMultidayEvent = false;
  }

  void _rescheduleEvent(DateTimeRange newDateTimeRange) {
    if (controller.chaningEvent == null) return;

    if (newDateTimeRange.start.isWithin(visibleDateRange) ||
        newDateTimeRange.end.isWithin(visibleDateRange)) {
      controller.chaningEvent?.dateTimeRange = newDateTimeRange;
    }
  }
}