import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingItem extends StatelessWidget {
  const LoadingItem({
    Key key,
    this.count = 1,
    this.width = double.infinity,
    this.height = 24.0,
    this.padding = const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
  }) : super(key: key);

  final int count;
  final double width;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
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
        width: this.width,
        height: this.height,
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
