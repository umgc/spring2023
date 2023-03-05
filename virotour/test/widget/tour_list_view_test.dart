import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virotour/src/tour/tour.dart';
import 'package:virotour/src/tour/tour_list_view.dart';

void main() {
  testWidgets('TourListView displays tour data', (WidgetTester tester) async {
    // Create a list of Tours to use as test data
    final tourList = [
      Tour(
        id: '1',
        tourName: 'Tour 1',
        description: 'This is Tour 1',
      ),
      Tour(
        id: '2',
        tourName: 'Tour 2',
        description: 'This is Tour 2',
      ),
    ];

    // Build the TourListView widget with the test data
    await tester.pumpWidget(
      MaterialApp(
        home: TourListView(items: tourList),
      ),
    );

    // Check if TourListView is rendered on screen
    expect(find.byType(TourListView), findsOneWidget);

    // Check if both Tour 1 and Tour 2 are displayed in the Tour
    expect(find.text('Tour 1'), findsOneWidget);
    expect(find.text('Tour 2'), findsOneWidget);
  });
}
