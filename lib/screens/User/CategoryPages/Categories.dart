import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/databases/DBcategory.dart';
import 'package:eventy/widgets/categoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Categories extends StatefulWidget {
  static Map<String, IconData> _iconDataMapping = {
    'home': Icons.home,
    'musical_notes': Ionicons.musical_note,
    'football': Ionicons.football,
    'aperture': Ionicons.aperture,
    'school': Ionicons.school,
    'default': Ionicons.star

    // Add more mappings as needed
  };
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<List<Map<String, dynamic>>> _fetchCategories;
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _fetchCategories = fetchingCategories();
  }

  Future<List<Map<String, dynamic>>> fetchingCategories() async {
    return await DBCategory.getAllCategories();
  }

  void _onRefresh() async {
    // Implement your refresh logic here
    await DBCategory.service_sync_categories();
    _refreshController.refreshCompleted();
    setState(() {
      _fetchCategories = fetchingCategories();
    });
  }

  void _onLoading() async {
    // Implement your refresh logic here
    await DBCategory.service_sync_categories();
    _refreshController.loadComplete();
    setState(() {
      _fetchCategories = fetchingCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PageAppBar(
        title: 'Categories',
        context: context,
        backButton: true,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: ClassicHeader(
          refreshingIcon: const SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
            ),
          ),
          idleIcon: const Icon(
            Icons.refresh,
            color: Color(0xFF662549),
          ),
          releaseIcon: const Icon(
            Icons.refresh,
            color: Color(0xFF662549),
          ),
          completeIcon: const Icon(
            Ionicons.checkmark_circle_outline,
            color: Color.fromARGB(255, 135, 244, 138),
          ),
          failedIcon: const Icon(Icons.error,
              color: const Color.fromARGB(255, 239, 92, 92)),
          idleText: '',
          releaseText: '',
          refreshingText: '',
          completeText: '',
          failedText: 'Refresh failed',
          textStyle: TextStyle(
              color: const Color.fromARGB(
                  255, 239, 92, 92)), // Change the text color here
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchCategories,
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                  strokeWidth: 2,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching data'));
            } else {
              List<Map<String, dynamic>> categories = snapshot.data ?? [];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                      (categories.length / 3).ceil(),
                      (index) {
                        int startIndex = index * 3 + 1;
                        int endIndex = (startIndex + 3 < categories.length)
                            ? startIndex + 3
                            : categories.length;

                        List<Widget> categoryRow = [];

                        for (int i = startIndex; i < endIndex; i++) {
                          String iconName = categories[i]['icon'] ?? 'default';
                          IconData icon =
                              Categories._iconDataMapping[iconName] ??
                                  Icons.error;

                          categoryRow.add(
                            CategoryWidget(
                              title: categories[i]['name'],
                              icon: icon,
                              isLike: false,
                            ),
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: categoryRow,
                        );
                      },
                    ).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
