import '../models/index.dart';
import '../services/index.dart';
import './index.dart';
import '../database/index.dart';
import '../utils/pair.dart';

/// Repository that holds saved stories of Hacker News
class SavedStoriesRepository extends BaseRepository {
  final StoryDao localSource;
  final ApiService remoteSource;

  SavedStoriesRepository(this.localSource, this.remoteSource);

  List<int> _storyIds = [];
  Map<int, Pair<Story, bool>> _stories =
      Map(); //Map<story_id, Pair(is_updated, Story)>

  List<int> get storyIds => [..._storyIds];

  Map<int, Pair<Story, bool>> get stories => {..._stories};

  @override
  Future<void> loadData() async {
    // Try to load the data from database
    try {
      var stories = await localSource.getStories();
      stories.forEach((story) {
        _storyIds.add(story.id);
        _stories[story.id] = Pair(story, false);
      });

      finishLoading();
    } on Exception catch (e) {
      print(e);
      receivedError();
    }
  }

  Future<Story> getStory(int storyId) async {
    var storiesMap = _stories[storyId];

    if (storiesMap.right) {
      //story is updated from remote source, return itself
      return storiesMap.left;
    } else {
      return remoteSource.getStory(storyId).then((response) {
        print('get story id for - $storyId');
        var story = Story.fromJson(response.data);

        localSource.insertOrReplace(story);
        _stories[story.id] = Pair(story, true);
        return story;
      });
    }
  }

  Future deleteStory(Story story) async {
    _storyIds.remove(story.id);
    localSource.deleteStory(story.id);
    notifyListeners();
  }

  Future saveStory(int index, Story story) async {
    _storyIds.insert(index, story.id);
    localSource.insertOrReplace(story);
    notifyListeners();
  }
}
