import 'package:flutter/foundation.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

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
      var ids = await _fetchStoriesFuture();
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
    print('build ${_ids.length}');
    return this._errorLoading != null
        ? ErrorHt(error: _errorLoading)
        : this._isLoading
            ? LoadingIndicator()
            : RefreshIndicator(
                key: _refreshIndicatorKey,
                child: ListView.builder(
                  controller: widget.scrollController,
                  itemCount: this._ids.length,
                  itemBuilder: (BuildContext context, int position) {
                    return FutureBuilder(
                      future: _api.getItem(_ids[position]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        var itemId = _ids[position];
                        if (items[itemId] != null) {
                          var item = items[itemId];
                          return ItemRow(
                            item: item,
                            key: Key(itemId.toString()),
                          );
                        }

                        if (snapshot.hasData && snapshot.data != null) {
                          if (snapshot.data != null) {
                            items[(snapshot.data as Item).id] = snapshot.data;
                            return ItemRow(
                              item: snapshot.data,
                              key: Key(itemId.toString()),
                            );
                          } else {
                            print('item is null $position and id = ${itemId}');
                            return Container();
                          }
                        } else if (snapshot.hasError) {
                          print('error $position and id = ${itemId}');
                          return Container();
                        } else {
                          return FadeLoading();
                        }
                      },
                    );
                  },
                ),
                onRefresh: _handleRefresh,
              );
  }

  Future<Null> _handleRefresh() async {
    List fetchStories = await _fetchStoriesFuture();

    if (!listEquals(_ids, fetchStories)) {
      print('item is not equal');
      final unduplicatedItems = Set.of(fetchStories + _ids);
      setState(() {
        this._ids = unduplicatedItems.toList();
        print('final _ids = $_ids');
      });
    }

    return null;
  }

  Future<List> _fetchStoriesFuture() => _api.fetchStories(widget.type);
}
