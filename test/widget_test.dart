import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/custom_button/next_button.dart';
import 'package:modsport/utilities/reservation/go_back_button.dart';
import 'package:modsport/utilities/reservation/location_name.dart';

import 'package:modsport/utilities/reservation/time_slot_disable.dart';
import 'package:modsport/utilities/reservation/time_slot_reserve.dart';
import 'package:modsport/utilities/reservation/toggle_role_button.dart';
import 'package:modsport/utilities/reservation/zone_name.dart';
import 'package:modsport/utilities/types.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  testWidgets('CustomPageViewButton onPressed callback is called',
      (WidgetTester tester) async {
    bool onPressedCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomPageViewButton(
            pageIndex: 1,
            controller: PageController(),
            onPressed: () {
              onPressedCalled = true;
            },
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump();

    expect(onPressedCalled, true);
  });

  testWidgets('TimeSlotDisable displays correctly',
      (WidgetTester tester) async {
    // Create mock data for the widget
    final List<DisableData> disabledReservation = [];
    final List<ReservationData> reservation = [];
    final List<UserReservationData> userReservation = [];
    final List<bool?> selectedTimeSlots = List.generate(10, (index) => false);

    // Build the TimeSlotDisable widget
    await tester.pumpWidget(MaterialApp(
      home: TimeSlotDisable(
        reservation: reservation,
        userReservation: userReservation,
        disabledReservation: disabledReservation,
        selectedTimeSlots: selectedTimeSlots,
        onChanged: (index, value) {},
      ),
    ));

    // Verify that the TimeSlotDisable is displayed correctly
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(GestureDetector), findsNWidgets(reservation.length));
    expect(find.byType(Container), findsNWidgets(reservation.length));
    expect(find.byType(Checkbox), findsNWidgets(reservation.length));
    expect(find.byType(SizedBox), findsNWidgets(reservation.length * 3));
    expect(find.byType(Expanded), findsNWidgets(reservation.length));
    expect(find.byType(Row), findsNWidgets(reservation.length * 4));
    expect(find.byType(Text), findsNWidgets(reservation.length * 2));
    expect(find.byType(Icon), findsNWidgets(reservation.length * 2));
  });

  testWidgets('TimeSlotReserve displays correctly',
      (WidgetTester tester) async {
    // Create mock data for the widget
    final List<ReservationData> reservation = [];
    final List<DisableData> disabledReservation = [];
    final List<UserReservationData> userReservation = [];
    const int selectedDateIndex = 0;
    const int selectedTimeSlot = 0;
    const bool isReserved = false;

    // Build the TimeSlotReserve widget
    await tester.pumpWidget(MaterialApp(
      home: TimeSlotReserve(
        reservation: reservation,
        disabledReservation: disabledReservation,
        userReservation: userReservation,
        selectedDateIndex: selectedDateIndex,
        selectedTimeSlot: selectedTimeSlot,
        isReserved: isReserved,
        onChanged: (value) {},
      ),
    ));

    // Verify that the TimeSlotReserve is displayed correctly
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Container), findsNWidgets(reservation.length));
    expect(find.byType(Theme), findsOneWidget);
    expect(find.byType(Container), findsNWidgets(reservation.length));
    expect(find.byType(ListTileTheme), findsNWidgets(reservation.length));
    expect(
        find.byType(SingleChildScrollView), findsNWidgets(reservation.length));
    expect(find.byType(SizedBox), findsNWidgets(reservation.length));
    expect(find.byType(RadioListTile), findsNWidgets(reservation.length));
    expect(find.byType(Container), findsNWidgets(reservation.length * 2));
    expect(find.byType(Text), findsNWidgets(reservation.length));
    expect(find.byType(Row), findsNWidgets(reservation.length * 2));
    expect(find.byType(Icon), findsNWidgets(reservation.length));
  });

  testWidgets('ToggleRoleButton displays correctly',
      (WidgetTester tester) async {
    // Set up variables for the test
    bool onPressedCalled = false;
    bool isError = false;
    bool isEverythingLoaded = true;
    bool isDisableMenu = false;
    bool isSwipingUp = false;

    // Build the ToggleRoleButton widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToggleRoleButton(
            onPressed: () {
              onPressedCalled = true;
            },
            isError: isError,
            isEverythingLoaded: isEverythingLoaded,
            isDisableMenu: isDisableMenu,
            isSwipingUp: isSwipingUp,
          ),
        ),
      ),
    );

    // Verify that the ToggleRoleButton is displayed correctly
    final elevatedButton = find.byType(ElevatedButton);
    final container = find.byType(Container);
    final icon = find.byType(Icon);

    expect(elevatedButton, findsOneWidget);
    expect(container, findsOneWidget);
    expect(icon, findsOneWidget);

    // Verify the onPressed callback
    expect(onPressedCalled, false);
    await tester.tap(elevatedButton);
    expect(onPressedCalled, true);

    // Verify the properties of the Icon
    final iconWidget = tester.widget<Icon>(icon);
    expect(
      iconWidget.icon,
      isSwipingUp
          // ignore: dead_code
          ? isDisableMenu
              ? Icons.admin_panel_settings_outlined
              : Icons.person_2_outlined
          : Icons.swap_horiz,
    );
    expect(iconWidget.color, Colors.white);
    expect(iconWidget.size, 40);
  });

  testWidgets('ZoneName displays correctly', (WidgetTester tester) async {
    // Set up variables for the test
    bool isError = false;
    bool isZoneLoaded = true;
    bool isSwipingUp = false;
    String zoneName = 'Example Zone Name';

    // Build the ZoneName widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ZoneName(
            isError: isError,
            zoneName: zoneName,
            isZoneLoaded: isZoneLoaded,
            isSwipingUp: isSwipingUp,
          ),
        ),
      ),
    );

    // Verify that the ZoneName is displayed correctly when isError is false and isZoneLoaded is true
    final textWidget = find.byType(Text);
    final shimmer = find.byType(Shimmer);
    final container = find.byType(Container);

    expect(textWidget, findsOneWidget);
    expect(shimmer, findsNothing);
    expect(container, findsNothing);

    final text = tester.widget<Text>(textWidget);
    expect(text.data, zoneName);
    expect(text.style!.fontFamily, 'Poppins');
    expect(text.style!.fontWeight, FontWeight.w600);
    expect(text.style!.fontSize, 26);
    expect(text.style!.height, 1.5);
    expect(text.style!.color, primaryOrange);

    // Verify the properties of the Text widget when zoneName is longer than 17 characters
    zoneName = 'A very long zone name that exceeds the character limit';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ZoneName(
            isError: isError,
            zoneName: zoneName,
            isZoneLoaded: isZoneLoaded,
            isSwipingUp: isSwipingUp,
          ),
        ),
      ),
    );

    final textOverflow = '${zoneName.substring(0, 15)} ...';
    final truncatedText = tester.widget<Text>(textWidget);
    expect(truncatedText.data, textOverflow);

    // Verify the properties of the ZoneName widget when isError is true and zoneName is empty
    isError = true;
    zoneName = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ZoneName(
            isError: isError,
            zoneName: zoneName,
            isZoneLoaded: isZoneLoaded,
            isSwipingUp: isSwipingUp,
          ),
        ),
      ),
    );

    expect(textWidget, findsOneWidget);
    expect(shimmer, findsNothing);
    expect(container, findsNothing);

    final errorText = tester.widget<Text>(textWidget);
    expect(errorText.data, '---');
    expect(errorText.style!.fontFamily, 'Poppins');
    expect(errorText.style!.fontWeight, FontWeight.bold);
    expect(errorText.style!.fontSize, 26);
    expect(errorText.style!.height, 1.5);
    expect(errorText.style!.color, primaryOrange);
  });

  testWidgets('GoBackButton displays correctly', (WidgetTester tester) async {
    // Set up variables for the test
    const isSwipingUp = true;
    const isError = false;
    const isEverythingLoaded = true;
    const isDisableMenu = false;

    // Build the GoBackButton widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GoBackButton(
            isSwipingUp: isSwipingUp,
            isError: isError,
            isEverythingLoaded: isEverythingLoaded,
            isDisableMenu: isDisableMenu,
          ),
        ),
      ),
    );

    // Verify that the GoBackButton is displayed correctly
    final elevatedButton = find.byType(ElevatedButton);
    final icon = find.byIcon(Icons.arrow_back_ios);

    expect(elevatedButton, findsOneWidget);
    expect(icon, findsOneWidget);
  });

  testWidgets('LocationName displays correctly', (WidgetTester tester) async {
    // Set up variables for the test
    const locationName = 'Test Location';
    const isError = false;
    const isLocationLoaded = true;
    const isSwipingUp = false;

    // Build the LocationName widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LocationName(
            locationName: locationName,
            isError: isError,
            isLocationLoaded: isLocationLoaded,
            isSwipingUp: isSwipingUp,
          ),
        ),
      ),
    );

    // Verify that the LocationName is displayed correctly
    final row = find.byType(Row);
    final icon = find.byIcon(Icons.location_on_outlined);
    final text = find.text(locationName);

    expect(row, findsOneWidget);
    expect(icon, findsOneWidget);
    expect(text, findsOneWidget);

    // Verify the opacity
    final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
    // ignore: dead_code
    expect(opacityWidget.opacity, isSwipingUp ? 0.33 : 1);

    // Verify the properties of the Text widget
    final textWidget = tester.widget<Text>(text);
    expect(textWidget.data, locationName);
    expect(textWidget.style!.color, primaryGray);
    expect(textWidget.style!.fontSize, 13);
    expect(textWidget.style!.fontWeight, FontWeight.w500);
    expect(textWidget.style!.fontFamily, 'Poppins');
    expect(textWidget.style!.height, 1.5);

    // Change isError to true and verify the text
    const emptyLocationName = '';
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LocationName(
            locationName: emptyLocationName,
            isError: true,
            isLocationLoaded: isLocationLoaded,
            isSwipingUp: isSwipingUp,
          ),
        ),
      ),
    );

    final emptyText = find.text('---');
    expect(emptyText, findsOneWidget);

    // Change isLocationLoaded to false and verify the Shimmer widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LocationName(
            locationName: locationName,
            isError: isError,
            isLocationLoaded: false,
            isSwipingUp: isSwipingUp,
          ),
        ),
      ),
    );

    final shimmer = find.byType(Shimmer);
    expect(shimmer, findsOneWidget);

    // Change isSwipingUp to true and verify the opacity
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LocationName(
            locationName: locationName,
            isError: isError,
            isLocationLoaded: isLocationLoaded,
            isSwipingUp: true,
          ),
        ),
      ),
    );

    final opacityWidget2 = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacityWidget2.opacity, 0.33);
  });
}
