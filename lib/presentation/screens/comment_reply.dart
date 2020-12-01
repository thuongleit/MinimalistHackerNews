import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hacker_news/presentation/widgets/single_comment_tile.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../presentation/widgets/widgets.dart';
import '../../blocs/blocs.dart';

class CommentReplyScreen extends StatefulWidget {
  static Route route(BuildContext context, Item item) {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<StoryCubit>(context),
        child: CommentReplyScreen(
          parentItem: item,
        ),
      ),
    );
  }

  const CommentReplyScreen({
    @required this.parentItem,
    Key key,
  }) : super(key: key);

  final Item parentItem;

  @override
  _CommentReplyScreenState createState() => _CommentReplyScreenState();
}

class _CommentReplyScreenState extends State<CommentReplyScreen> {
  bool isContentCollapsed = true;

  @override
  void initState() {
    isContentCollapsed = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: '',
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isContentCollapsed = !isContentCollapsed;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 4.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Original content',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.grey[700]),
                          ),
                          (isContentCollapsed)
                              ? Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                )
                              : Icon(
                                  Icons.arrow_drop_up,
                                  color: Colors.grey[600],
                                ),
                        ],
                      ),
                    ),
                    (isContentCollapsed)
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 2.0, bottom: 16.0),
                            child: SingleCommentTile(
                              item: widget.parentItem,
                            ),
                          ),
                  ],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.2),
                  ),
                  hintText: 'Enter your comment',
                ),
                style: TextStyle(fontSize: 14.0),
                minLines: 15,
                maxLines: 35,
              ),
            ],
          ),
        ),
      ),
      actions: [],
      fab: FloatingActionButton(
        child: Icon(Icons.reply),
        onPressed: () => {},
      ),
    );
  }

  Widget _buildMenuAction(BuildContext context, Map<String, Object> action) {
    return IconButton(
      tooltip: action['title'],
      onPressed: () => Navigator.pushNamed(context, action['route']),
      icon: Icon(action['icon']),
    );
  }
}
