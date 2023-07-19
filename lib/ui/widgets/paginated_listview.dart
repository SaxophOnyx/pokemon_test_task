import 'package:flutter/material.dart';

class PaginatedListView extends StatelessWidget {
  final int itemsCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function() onNextPageRequested;
  final void Function() onPrevPageRequested;

  const PaginatedListView({
    super.key,
    required this.itemsCount,
    required this.itemBuilder,
    required this.onPrevPageRequested,
    required this.onNextPageRequested
  });
  
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: _onNotification,
      child: ListView.builder(
        itemCount: itemsCount,
        itemBuilder: itemBuilder,
      ),
    );
  }

    bool _onNotification(ScrollEndNotification notification) {
    final velocity = notification.dragDetails?.velocity;

    if (velocity != null) {
      if (velocity.pixelsPerSecond.dy < 0) {
        onNextPageRequested();
      } else if (velocity.pixelsPerSecond.dy > 0) {
        onPrevPageRequested();
      }
    }

    return true;
  }
}
