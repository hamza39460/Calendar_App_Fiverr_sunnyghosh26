import 'package:calendar_events_app/Screens/AddEvent.dart';
import 'package:device_calendar/device_calendar.dart';

extension RecurrenceFrequencyExtensions on RecurrenceFrequency {
  String _enumToString(RecurrenceFrequency enumValue) {
    switch (enumValue) {
      case RecurrenceFrequency.Daily:
        return 'Daily';
      case RecurrenceFrequency.Weekly:
        return 'Weekly';
      case RecurrenceFrequency.Monthly:
        return 'Monthly';
      case RecurrenceFrequency.Yearly:
        return 'Yearly';
    }
  }

  String get enumToString => _enumToString(this);
}

extension RecurrenceRuleEndTypeExtension on RecurrenceRuleEndType {
  String _enumToString(RecurrenceRuleEndType enumValue) {
    switch (enumValue) {
      case RecurrenceRuleEndType.Indefinite:
        return 'Indefinitely';
      case RecurrenceRuleEndType.MaxOccurrences:
        return 'After a set number of times';
      case RecurrenceRuleEndType.SpecifiedEndDate:
        return 'Continues untill a specified Date';
    }
  }

  String get enumToString => _enumToString(this);
}

extension StringExtension on String {
  Availability _stringAvailabilityToEnum(String string) {
    switch (string) {
      case 'BUSY':
        return Availability.Busy;
      case 'FREE':
        return Availability.Free;
      case 'TENTATIVE':
        return Availability.Tentative;
      case 'UNAVAILABLE':
        return Availability.Unavailable;
      default:
        return Availability.Busy;
    }
  }

  RecurrenceFrequency _stringReccurrenceToEnum(String string) {
    switch (string) {
      case 'Daily':
        return RecurrenceFrequency.Daily;
      case 'Weekly':
        return RecurrenceFrequency.Weekly;
      case 'Monthly':
        return RecurrenceFrequency.Monthly;
      case 'Yearly':
        return RecurrenceFrequency.Yearly;
      default:
        return RecurrenceFrequency.Daily;
    }
  }

  DayOfWeek _stringDaysOfWeeksToEnum(String string) {
    switch (string) {
      case 'Monday':
        return DayOfWeek.Monday;
      case 'Tuesday':
        return DayOfWeek.Tuesday;
      case 'Wednesday':
        return DayOfWeek.Wednesday;
      case 'Thursday':
        return DayOfWeek.Thursday;
      case 'Friday':
        return DayOfWeek.Friday;
      case 'Saturday':
        return DayOfWeek.Saturday;
      case 'Sunday':
        return DayOfWeek.Sunday;
      default:
        return DayOfWeek.Monday;
    }
  }

  MonthOfYear _stringMonthOfYearToEnum(String string) {
    switch (string) {
      case 'January':
        return MonthOfYear.January;
      case 'Feburary':
        return MonthOfYear.Feburary;
      case 'March':
        return MonthOfYear.March;
      case 'April':
        return MonthOfYear.April;
      case 'May':
        return MonthOfYear.May;
      case 'June':
        return MonthOfYear.June;
      case 'July':
        return MonthOfYear.July;
      case 'August':
        return MonthOfYear.August;
      case 'September':
        return MonthOfYear.September;
      case 'October':
        return MonthOfYear.October;
      case 'November':
        return MonthOfYear.November;
      case 'December':
        return MonthOfYear.December;
      default:
        return MonthOfYear.January;
    }
  }

  WeekNumber _stringWeekNumberToEnum(String string) {
    switch (string) {
      case 'First':
        return WeekNumber.First;
      case 'Second':
        return WeekNumber.Second;
      case 'Third':
        return WeekNumber.Third;
      case 'Fourth':
        return WeekNumber.Fourth;
      case 'Last':
        return WeekNumber.Last;
      default:
        return WeekNumber.First;
    }
  }

  Availability get stringAvailabilityToEnum => _stringAvailabilityToEnum(this);

  RecurrenceFrequency get stringReccurrenceToEnum =>
      _stringReccurrenceToEnum(this);

  DayOfWeek get stringDaysOfWeeksToEnum => _stringDaysOfWeeksToEnum(this);

  MonthOfYear get stringMonthOfYearToEnum => _stringMonthOfYearToEnum(this);

  WeekNumber get stringWeekNumberToEnum => _stringWeekNumberToEnum(this);
}
