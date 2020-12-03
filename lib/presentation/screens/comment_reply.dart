import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hknews_repository/hknews_repository.dart';
import 'package:formz/formz.dart';

import '../../blocs/blocs.dart';
import '../../presentation/widgets/single_comment_tile.dart';
import '../../presentation/widgets/widgets.dart';

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
    return BlocProvider(
      create: (context) => UserInputBloc(
        userAction: context.read<UserActionBloc>(),
      ),
      child: BlocListener<UserInputBloc, UserInputState>(
        listenWhen: (previous, current) => current.status.isSubmissionSuccess,
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pop();
          }
        },
        child: SimplePage(
          title: _isComment() ? 'Reply' : 'Add comment',
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
          actions: [],
          fab: BlocBuilder<UserInputBloc, UserInputState>(
            buildWhen: (previous, current) => previous.input != current.input,
            builder: (context, state) => FloatingActionButton(
              child: Icon(Icons.reply),
              onPressed: () {
                context
                    .read<UserInputBloc>()
                    .replyToComment(widget.parentItem.id);
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ),
        ),
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

class _UserInputField extends StatelessWidget {
  const _UserInputField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInputBloc, UserInputState>(
      buildWhen: (previous, current) =>
          (previous.input != current.input || current.status.isInvalid),
      builder: (context, state) {
        return TextField(
          key: const Key('user_input_field'),
          onChanged: (value) => context.read<UserInputBloc>().input(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.2),
            ),
            hintText: 'Enter your comment',
            errorText: (state.input.invalid || state.status.isInvalid)
                ? 'Content must not be empty'
                : null,
          ),
          style: TextStyle(fontSize: 14.0),
          minLines: 15,
          maxLines: 35,
        );
      },
    );
  }
}
