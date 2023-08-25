This Flutter package offers a Calendar Widget featuring integrated Day, MultiDay, and Month views. Moreover, it empowers you to tailor the visual aspects of the calendar widget.

## Web Example
Try it out [here](https://werner-scholtz.github.io/kalender/)

## Features

<img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/feature.gif" width="100%"/> 

* **Platforms** - Works with Web, Desktop and Mobile. 

* **Calendar Views** - There are 3 calendar views available, Day, MultiDay, and Month. [Find out more](#calendar-views)

* **Reschedule** - Drag and Drop events to your liking. [Try it out](https://werner-scholtz.github.io/kalender/)

* **Resize** - Resize events by dragging the edges of an event. [Try it out](https://werner-scholtz.github.io/kalender/)

* **Event Handeling** - When a there is interaction with a tile or component the event can be handeled by you. [Find out more](#event-handling)

* **Flexible View's** - Each of the Calendar View's takes a ViewConfiguration, this has some parameters you can change, OR you can create your own. [Find out more](#view-configuration)

* **Custom Object** - CaledarEvent's can contain any object of your choosing. [Find out more](#custom-object)

* **Appearance** - You can change the style of the calendar and default components. [Find out more](#appearance)

* **Custom Builders** - You can create your own builders for different components of the calendar. [Find out more](#appearance)

* **Custom LayoutControllers** - You can create your own algorithm to layout tiles. [Find out more](#layoutcontrollers)

## Installation

1. Add this to your package's pubspec.yaml file:
    
    ```
   $ flutter pub add kalender
    ```
2. Import it:   
    
    ```dart
   import 'package:kalender/kalender.dart';
    ```

## Usage

1. Create a custom class to store your data. 
    ```dart
    class Event {
      final String title;
      final Color color;
      
      Event(this.title, this.color);
    }
    ```

2. Create a EventsController
    ```dart
    final eventsController = EventsController<Event>();
    ```
    Add events to the controller
    ```dart
    eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange()
        eventData: Event(  
            title: 'Event 1',
            color: Colors.blue,
        ),
      ),
    );
    ```

3. Create a CalendarController
    ```dart
    final calendarController = CalendarController();
    ```

4. Create tile builders
   ```dart
   Widget _tileBuilder(event, tileConfiguration) => Widget()
   Widget _multiDayTileBuilder(event, tileConfiguration) => Widget()
   Widget _monthEventTileBuilder(event, tileConfiguration) => Widget()
   ```

5. Create a CalendarView
    ```dart
    CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      tileBuilder: _tileBuilder(),
      multiDayTileBuilder: _multiDayTileBuilder(),
      monthTileBuilder: _monthEventTileBuilder(),
    )       
    ```
    


## Additional information

<!--TODO: Complete this-->
### Calendar Views
There are a few constructors that you can choose from to create a CalendarView.

1. **Default Constructor** - this constructor will build the correct view (Day, MultiDay, Month) based on the ViewConfiguration you pass it.

2. **DayView** - this constructor will build a DayView and does not need the monthTileBuilder.

3. **MultiDayView** - this constructor will build a MultiDayView and does not need the monthTileBuilder.

4. **MonthView** - this constructor will build a MonthView and does not need the tileBuilder or multiDayTileBuilder.

### View Configuration
The CaledarView takes a ViewConfiguration object.

There are 3 'Types' of ViewConfiguration's: DayViewConfiguration, MultiDayViewConfiguration, and MonthViewConfiguration.
* You can create a Custom ViewConfiguration by extending one of these 'Types'.

These are the default ViewConfiguration's:

1. **DayConfiguration** - This configuration is used to configure the SingleDayView.
    ```dart
    DayConfiguration(
      // The width of the timeline on the left of the page.
      timelineWidth: 56,
      // The overlap between the timeline and hourlines.
      hourlineTimelineOverlap: 8,
      // The height of the multi day tiles.
      multidayTileHeight: 24,
      // The size of one slot in the calendar.
      slotSize: SlotSize(minutes: 15),
      // Allow EventTiles to snap to each other.
      eventSnapping: true,
      // Allow EventTiles snap to the time indicator.
      timeIndicatorSnapping: true,
      // Allow the view to create new events.
      createNewEvents: true,
      // The duration of the vertical step while dragging.
      verticalStepDuration: Duration(minutes: 15),
      // The vertical snap range while dragging.
      verticalSnapRange: Duration(minutes: 15),
    ),
    ```

2. **MultiDayConfiguration** - This configuration is used to configure the MultiDayView and can display any number of days.
    ```dart
    MultiDayConfiguration(
      name: 'Two Day',
      numberOfDays: 2,
      timelineWidth: 56,
      hourlineTimelineOverlap: 8,
      multidayTileHeight: 24,
      slotSize: SlotSize(minutes: 15),
      paintWeekNumber: true,
      eventSnapping: true,
      timeIndicatorSnapping: true,
      createNewEvents: true,
      verticalStepDuration: Duration(minutes: 15),
      verticalSnapRange: Duration(minutes: 15),
    ),
    ```

3. **WeekConfiguration** - This configuration is used to configure the MultiDayView and displays 7 days that starts on the firstDayOfWeek.
    ```dart
    WeekConfiguration(
      timelineWidth: 56,
      hourlineTimelineOverlap: 8,
      multidayTileHeight: 24,
      slotSize: SlotSize(minutes: 15),
      paintWeekNumber: true,
      eventSnapping: true,
      timeIndicatorSnapping: true,
      // The first day of the week.
      firstDayOfWeek: DateTime.monday,
      createNewEvents: true,
      verticalStepDuration: Duration(minutes: 15),
      verticalSnapRange: Duration(minutes: 15),
    ),
    ```

4. **WorkWeekConfiguration** - This configuration is used to configure the MultiDayView and displays 5 days that starts on monday.
    ```dart
    WorkWeekConfiguration(
      timelineWidth: 56,
      hourlineTimelineOverlap: 8,
      multidayTileHeight: 24,
      slotSize: SlotSize(minutes: 15),
      paintWeekNumber: true,
      eventSnapping: true,
      timeIndicatorSnapping: true,
      createNewEvents: true,
      verticalStepDuration: Duration(minutes: 15),
      verticalSnapRange: Duration(minutes: 15),
    )
    ```

5. **MonthConfiguration** - this configuration is used to configure the MonthView.
    ```dart
    MonthConfiguration(
      firstDayOfWeek: DateTime.monday,
      // Can events be resized.
      enableRezising: true,
      createNewEvents: true,
    )
    ```




### Event Handling
The CaledarView can take a CalendarEventHandlers object.
The CalendarEventHandlers handles the user's interaction with the calendar. (Do not confuse the CalendarEventHandlers with the EventsController)

There are 5 events at this time that can be handeled.

1. **onEventChanged**: this function is called when an event displayed on the calendar is changed. (resized or moved)

2. **onEventChangeStart**: this function is called when an event is about to be changed.

3. **onEventTapped**: this function is called when an event displayed on the calendar is tapped.

4. **onCreateEvent**: this function is called when a new event is created by the calendar.

5. **onDateTapped**: this function is called when a date on the calendar is tapped.

```dart
CalendarEventHandlers<Event>(
  onEventChangeStart: (CalendarEvent<T> event) {
    // This function is called when an event is about to be changed.
  }
  onEventChanged: (DateTimeRange initialDateTimeRange, CalendarEvent<Event> calendarEvent) async {
    // The initialDateTimeRange is the original DateTimeRange of the event.
    // The event is a reference to the event that was changed.

    // This is a async function, so you can do any async work here.

    // Once this function is complete the calendar will rebuild.
  },
  onEventTapped: (CalendarEvent<Event> calendarEvent) async {
    // The calendarEvent is a reference to the event that was tapped.

    // This is a async function, so you can do any async work here.

    // Once this function is complete the calendar will rebuild.
  },
  onCreateEvent: (CalendarEvent<Event> calendarEvent) async {
    // The calendarEvent is a empty event and is not yet added to the list of events.

    // This is a async function, so you can do any async work here.

    // If you want to add the event to the calendar 
    eventsController.addEvent(event);

    // Once this function completes the calendar will rebuild.
  },
  onDateTapped: (date) {
    // The date is the date header that was tapped. see example for use case.
  },
);
```

### Events Controller
The CaledarView takes a EventsController object.
The EventsController is used to store and manage CalendarEvent's.
(Do not confuse the EventsController with EventHandling)

| Function      | Parameters    | Description   |
| ------------- | ------------- | ------------- |
| addEvent      | CalendarEvent\<T\> event | Adds this event to the list and rebuilds the calendar view  |
| addEvents     | List\<CalendarEvent\<T\>> events  | Adds these events to the list and rebuilds the calendar view |
| removeEvent   | CalendarEvent\<T\> event  | Removes this event from the list and rebuilds the calendar view |
| removeWhere   | bool Function(CalendarEvent\<T\> element) test  | Removes the event(s) where the test returns true  |
| clearEvents   |   | Clears the list of stored events  |
| updateEvent   | T? newEventData, DateTimeRange? newDateTimeRange,bool Function(CalendarEvent<T> calendarEvent) test, | Updates the eventData or newDateTimeRange (if provided), of the event where 
the test returns true  | 
| selectEvent   |  CalendarEvent<T> event | Selects the given event. |
| deselectEvent | | Deslects the selected event. |
| forceUpdate | | Forces the calendar to update the UI. |


### Calendar Controller
The CaledarView takes a CalendarController object.
The CalendarController is used to control the CalendarView.

| Function      | Parameters    | Description   |
| ------------- | ------------- | ------------- |
| animateToNextPage | Duration? duration, Curve? curve | Animates to the next page. |
| animateToPreviousPage | Duration? duration, Curve? curve | Animates to the previous page. |
| jumpToPage  | int page  | Jumps to the given page.  |
| jumpToDate  | DateTime date  | Jumps to the given date.  |
| animateToDate  | DateTime date, {Duration? duration, Curve? curve,}  | Animates to the DateTime provided.|
| adjustHeightPerMinute  | double heightPerMinute  | Changes the heightPerMinute of the view. (Zoom level)  |
| animateToEvent  | CalendarEvent<T> event, {Duration? duration, Curve? curve}  | Animates to the CalendarEvent.  | 
| lockScrollPhyscis  |   | Locks the vertical scroll of the current view. | 
| unlockScrollPhysics  | ScrollPhysics? scrollPhysics | Unlocks the vertical scroll of the current view. | 


### Custom Object
The CalendarEvent can contain any object. This object can be accessed by the tileBuilders and the CalendarEventHandlers.

Custom Object Example:
```dart
CalendarEvent<Event>(
  dateTimeRange: DateTimeRange(),
  eventData: Event(
    title: 'Event 1',
    color: Colors.blue,
  ),
);
```

Tile Builder Example:
```dart
Widget _tileBuilder(CalendarEvent<Event> event, tileConfiguration) {
  final customObject = event.eventData;
  return Card(
    color: customObject.color,
    child: Text(customObject.title),
  );
}
```

### LayoutControllers
There are three types of layout controllers: DayLayoutController, MultiDayLayoutController, and MonthLayoutController.

(See the example app for examples)

1. DayLayoutController
   Create your own DayLayoutController by extending the DayLayoutController class.
   ```dart
    class DefaultDayLayoutController<T> extends DayTileLayoutController<T> {
      DefaultDayTileLayoutController({
        required super.visibleDateRange,
        required super.visibleDates,
        required super.heightPerMinute,
        required super.dayWidth,
      });

      @override
      List<TileGroup<T>> generateTileGroups(
        Iterable<CalendarEvent<T>> events,
      ) {
        // This must return a list of TileGroup's.
        // TileGroups are a collection of PositionedTileData's and are displayed as a group.
        // The order of the PositionedTileData's in the list is the order in which they are displayed.
      }

      @override
      List<PositionedTileData<T>> layoutSingleEvent(
        CalendarEvent<T> event,
      ) {
        // This returns a single PositionedTileData that is used to display event that is moving.
      }

    }
   ```

2. MultiDayLayoutController
   Create your own MultiDayLayoutController by extending the DayLayoutController class.
   ```dart
  class DefaultMultidayLayoutController<T> extends MultiDayTileLayoutController<T> {
    DefaultMultidayLayoutController({
      required super.visibleDateRange,
      required super.dayWidth,
      required super.tileHeight,
    });

    @override
    MultiDayLayoutData<T> layoutEvents(
      Iterable<CalendarEvent<T>> events,
    ) {
      // This must return a MultiDayLayoutData object.
      // The MultiDayLayoutData contains a list of PositionedTileData's.
      // And the stack height.
    }

    @override
    List<PositionedTileData<T>> layoutSingleEvent(
      CalendarEvent<T> event,
    ) {
      // This must return a single PositionedTileData that is used to display event that is moving.
    }

   }
   ```

3. MonthLayoutController 
   Create your own MonthLayoutController by extending the DayLayoutController class.
   ```dart
   class DefaultMultidayLayoutController<T> extends MultiDayTileLayoutController<T> {
      DefaultMultidayLayoutController({
        required super.visibleDateRange,
        required super.cellWidth,
        required super.tileHeight,
      });

      @override
      List<PositionedMonthTileData<T>> layoutEvents(
        Iterable<CalendarEvent<T>> events,
      ){
        // This must return a list of PositionedMonthTileData's.
        // The order of the PositionedMonthTileData's in the list is the order in which they are displayed.
      }

      @override
      List<PositionedMonthTileData<T>> layoutSingleEvent(
        CalendarEvent<T> event,
      ){
        // This must return a single PositionedMonthTileData that is used to display event that is moving.
      }
   }
   ```


### Appearance
The CalendarView consists of quite a few sub components:
Each of these components can be customized in the CalendarStyle object or by passing a custom widget builder through the CalendarComponents object.

1. CalendarHeader - This is a custom widget that you can pass to the calendar to render in the header of the calendar.

    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/calendar_header.png" width="75%" height="75%"/>

    (CalendarHeader)

2. DayHeader - This widget is displayed above a day colum in the calendar.

    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/day_header.png" width="75%" height="75%"/>

    (DayHeader)

3. WeekNumber - This widget displays the week number of the year.

    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/week_number.png" width="75%" height="75%"/>

    (WeekNumber)

4. DaySeprator - This widget is displayed between days in the calendar.
    
    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/day_seperator.png" width="75%" height="75%"/>

    (DaySeprator)

5. Hourlines - This widget is displayes the hourlines in the calendar.
    
    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/hourlines.png" width="75%" height="75%"/>

    (Hourlines)

6. Timeline - This widget is displayed on the left side of the calendar to show the time.
    
    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/timeline.png" width="75%" height="75%"/>

    (Timeline)

7. TimeIndicator - This widget is displayed on the current day to show the current time.
    
    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/time_indicator.png" width="75%" height="75%"/>

    (TimeIndicator)

8. MonthHeader - This widget is displayed above the month grid in the calendar header.
    
    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/month_header.png" width="75%" height="75%"/>

    (MonthHeader)

9. MonthCellHeader - This widget is displayed in a month cell in the month grid.
    
    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/month_cell_header.png" width="75%" height="75%"/>

    (MonthCellHeader)

10. MonthGrid - This widget is displayed in the month view to show the grid.
    
    <img src="https://raw.githubusercontent.com/werner-scholtz/kalender/main/readme_assets/month_grid.png" width="75%" height="75%"/>

    (MonthGrid)


