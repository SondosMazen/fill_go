// import 'package:fill_go/Model/LocalStorge/RecentSearch.dart';
// import 'package:fill_go/objectbox.g.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

// class ObjectBox {
//   late Box<RecentSearch> box;

//   ObjectBox._init(this.box);

//   static Future<ObjectBox> init() async {

//     final dir = await getApplicationDocumentsDirectory();
//     final store = Store(getObjectBoxModel(),
//         directory: p.join(dir.path, 'search_history'));
//     final box = store.box<RecentSearch>();
//     return ObjectBox._init(box);
//   }

//   List<RecentSearch> getAllSearch() => box.getAll();

//   RecentSearch getSearch(int id) => box.get(id)!;

//   bool deleteSearch(int id) => box.remove(id);

//   int deleteAllSearch() => box.removeAll();

//   int addSearch(RecentSearch recentSearch) => box.put(recentSearch);
// }
