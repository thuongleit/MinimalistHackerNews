import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';

import '../../blocs/blocs.dart';
import '../../extensions/extensions.dart';
import '../../presentation/widgets/single_comment_tile.dart';
import '../../presentation/widgets/widgets.dart';

class CommentReplyScreen extends StatefulWidget {
  static Route route(BuildContext context, Item item) {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => CommentReplyScreen(
        parentItem: item,
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
    return BlocProvider(
      create: (_) => UserInputBloc(
        userAction: context.read<UserActionBloc>(),
      ),
      child: SimplePage(
        title: _isComment() ? 'Reply' : 'Add comment',
        body: UserActionsListener(
          callback: (result) {
            if (result.success) {
              Navigator.of(context).pop();
            }
          },
          child: SingleChildScrollView(
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
                            left: 8.0,
                            top: 4.0,
                            bottom: 8.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                _isComment() ? 'Reply to' : 'Comment on',
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
                                padding: const EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 16.0,
                                ),
                                child: _isComment()
                                    ? SingleCommentTile(
                                        item: widget.parentItem,
                                      )
                                    : MinimalistStoryTile(
                                        widget.parentItem,
                                        voteable: false,
                                      ),
                              ),
                      ],
                    ),
                  ),
                  _UserInputField(),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.send),
              onPressed: () => context
                  .read<UserInputBloc>()
                  .replyToComment(widget.parentItem.id),
            ),
          )
        ],
      ),
    );
  }

  bool _isComment() => (widget.parentItem.type == ItemType.comment);

  Widget _buildMenuAction(BuildContext context, Map<String, Object> action) {
    return IconButton(
      tooltip: action['title'],
      onPressed: () => Navigator.pushNamed(context, action['route']),
      icon: Icon(action['icon']),
    );
  }
}

class _UserInputField extends StatefulWidget {
  const _UserInputField({
    Key key,
  }) : super(key: key);

  @override
  __UserInputFieldState createState() => __UserInputFieldState();
}

class __UserInputFieldState extends State<_UserInputField> {
  FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserInputBloc, UserInputState>(
      listenWhen: (previous, current) => current.status.isSubmitted,
      listener: (context, state) => focusNode.unfocus(),
      buildWhen: (previous, current) => previous.input != current.input,
      builder: (context, state) {
        return TextField(
          key: const Key('user_input_field'),
          onChanged: (value) => context.read<UserInputBloc>().input(value),
          focusNode: focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.2),
            ),
            hintText: 'Write a comment...',
            errorText:
                (state.input.invalid) ? 'Comment must not be empty' : null,
          ),
          style: TextStyle(fontSize: 14.0),
          minLines: 15,
          maxLines: 35,
        );
      },
    );
  }
}
