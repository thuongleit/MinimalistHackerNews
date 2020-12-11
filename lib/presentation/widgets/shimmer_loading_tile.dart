import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingItem extends StatelessWidget {
  const LoadingItem({
    Key key,
    this.count = 1,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Column(
        children: [...List.generate(count, (_) => _shimmer())],
      ),
    );
  }

  Shimmer _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500],
      highlightColor: Colors.grey[100],
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
