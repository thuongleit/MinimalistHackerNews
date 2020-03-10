import 'package:flutter/material.dart';
import 'package:hacker_news/ui/widgets/item_row.dart';
import '../../api/api.dart';
import '../../models/item.dart';
import '../../ui/widgets/error.dart';
import '../../ui/widgets/loading.dart';
import '../../ui/widgets/fade_loading.dart';

class ItemList extends StatefulWidget {
  final StoryType type;
  final ScrollController scrollController;
  final AnimationController animationController;

  const ItemList(
      {Key key, this.type, this.scrollController, this.animationController})
      : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  HackerNewsApi _api = HackerNewsApi();
  bool _isLoading = false;
  String _errorLoading;
  List<dynamic> _ids = [];
  Map<int, Item> items = Map();

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  void fetchStories() async {
    setState(() {
      this._ids = [];
      this.items = Map();
      this._isLoading = true;
      this._errorLoading = null;
    });

    try {
      var ids = await _api.fetchStories(widget.type);
      setState(() {
        this._isLoading = false;
        this._ids = ids.toList();
      });
    } catch (e) {
      setState(() {
        this._isLoading = false;
        this._errorLoading = "Failed to fetch stories";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return this._errorLoading != null
        ? ErrorHt(error: _errorLoading)
        : this._isLoading
            ? LoadingIndicator()
            : ListView.builder(
                controller: widget.scrollController,
                itemCount: this._ids.length,
                itemBuilder: (BuildContext context, int position) {
                  return FutureBuilder(
                    future: _api.getItem(this._ids[position]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (items[position] != null) {
                        var item = items[position];
                        if (item != null) {
                          return ItemRow(
                            item: item,
                            key: Key(item.id.toString()),
                          );
                        } else {
                          return FadeLoading();
                        }
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        var item = snapshot.data;
                        items[position] = item;
                        if (item != null) {
                          return ItemRow(
                            item: item,
                            key: Key(item.id.toString()),
                          );
                        } else {
                          return Container();
                        }
                      } else if (snapshot.hasError) {
                        return Container();
                      } else {
                        return FadeLoading();
                      }
                    },
                  );
                },
              );
  }
}
