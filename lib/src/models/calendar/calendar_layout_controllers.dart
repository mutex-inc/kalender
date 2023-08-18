import 'package:flutter/material.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/day_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/day_tile_layout_controller/default_day_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller/default_month_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller/month_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/default_multi_day_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_layout_controller/multi_day_layout_controller.dart';
import 'package:kalender/src/typedefs.dart';

/// The [CalendarLayoutControllers] class contains layout controllers used by the calendar view.
class CalendarLayoutControllers<T> {
  CalendarLayoutControllers({
    DayLayoutController<T>? dayTileLayoutController,
    MultiDayLayoutController<T>? multiDayTileLayoutController,
    MonthLayoutController<T>? monthTileLayoutController,
  }) {
    this.dayTileLayoutController =
        dayTileLayoutController ?? defaultDayTileLayoutController;

    this.multiDayTileLayoutController =
        multiDayTileLayoutController ?? defaultMultiDayTileLayoutController;

    this.monthTileLayoutController =
        monthTileLayoutController ?? defaultMonthTileLayoutController;
  }

  /// The [DayLayoutController] used to layout the day tiles.
  late DayLayoutController<T> dayTileLayoutController;

  /// The [MultiDayLayoutController] used to layout the multiday tiles.
  late MultiDayLayoutController<T> multiDayTileLayoutController;

  /// The [MonthLayoutController] used to layout the month tiles.
  late MonthLayoutController<T> monthTileLayoutController;

  /// The default [DayLayoutController] used to layout the day tiles.
  DayTileLayoutController<T> defaultDayTileLayoutController({
    required DateTimeRange visibleDateRange,
    required List<DateTime> visibleDates,
    required Duration verticalDurationStep,
    required double heightPerMinute,
    required double dayWidth,
  }) {
    return DefaultDayTileLayoutController<T>(
      visibleDateRange: visibleDateRange,
      visibleDates: visibleDates,
      verticalDurationStep: verticalDurationStep,
      heightPerMinute: heightPerMinute,
      dayWidth: dayWidth,
    );
  }

  /// The default [MultiDayLayoutController] used to layout the multiday tiles.
  MultiDayTileLayoutController<T> defaultMultiDayTileLayoutController({
    required DateTimeRange visibleDateRange,
    required double dayWidth,
    required double tileHeight,
    required bool isMobileDevice,
    required bool isMultidayView,
  }) {
    return DefaultMultidayLayoutController<T>(
      visibleDateRange: visibleDateRange,
      dayWidth: dayWidth,
      tileHeight: tileHeight,
      isMobileDevice: isMobileDevice,
      isMultidayView: isMultidayView,
    );
  }

  /// The default [MonthLayoutController] used to layout the month tiles.
  MonthTileLayoutController<T> defaultMonthTileLayoutController({
    required DateTimeRange visibleDateRange,
    required double cellWidth,
    required double tileHeight,
    required bool isMobileDevice,
  }) {
    return DefaultMonthTileLayoutController<T>(
      visibleDateRange: visibleDateRange,
      cellWidth: cellWidth,
      tileHeight: tileHeight,
      isMobileDevice: isMobileDevice,
    );
  }

  @override
  operator ==(Object other) {
    return false;
  }

  @override
  int get hashCode => Object.hash(dayTileLayoutController, 1);

  CalendarLayoutControllers<T> copyWith({
    DayLayoutController<T>? dayTileLayoutController,
    MultiDayLayoutController<T>? multiDayTileLayoutController,
    MonthLayoutController<T>? monthTileLayoutController,
  }) {
    return CalendarLayoutControllers<T>(
      dayTileLayoutController: dayTileLayoutController,
      multiDayTileLayoutController: multiDayTileLayoutController,
      monthTileLayoutController: monthTileLayoutController,
    );
  }
}
