import 'package:amplify_trips_planner/common/ui/navigation_drawer.dart';
import 'package:amplify_trips_planner/features/trip/ui/trip_gridview_item/trip_gridview_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:amplify_trips_planner/features/trip/data/trips_repository.dart';
import 'package:amplify_trips_planner/features/trip/ui/trips_list/add_trip_bottomsheet.dart';

import 'package:amplify_trips_planner/common/utils/colors.dart' as constants;

class TripsListPage extends ConsumerWidget {
  const TripsListPage({
    super.key,
  });

  Future<void> showAddTripDialog(BuildContext context) =>
      showModalBottomSheet<void>(
        isScrollControlled: true,
        elevation: 5,
        context: context,
        builder: (sheetContext) {
          return AddTripBottomSheet();
        },
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsListValue = ref.watch(tripsListStreamProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Trips Planner',
        ),
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      drawer: const NavigationDrawer2(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTripDialog(context);
        },
        backgroundColor: const Color(constants.primaryColorDark),
        child: const Icon(Icons.add),
      ),
      body: tripsListValue.when(
        data: (trips) => trips.isEmpty
            ? const Center(
                child: Text('No Trips'),
              )
            : OrientationBuilder(builder: (context, orientation) {
                return GridView.count(
                  crossAxisCount: (orientation == Orientation.portrait) ? 1 : 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  padding: const EdgeInsets.all(4),
                  childAspectRatio:
                      (orientation == Orientation.portrait) ? 1.7 : 1.4,
                  children: trips.map((tripData) {
                    return TripGridViewItem(
                      trip: tripData!,
                      isPast: false,
                    );
                  }).toList(growable: false),
                );
              }),
        error: (e, st) => const Center(
          child: Text('Error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
