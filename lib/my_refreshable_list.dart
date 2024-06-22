import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyRefreshableList extends StatefulWidget {
  @override
  _MyRefreshableListState createState() => _MyRefreshableListState();
}

class _MyRefreshableListState extends State<MyRefreshableList> {
  List<String> _data = []; // Initialize your data
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Fetch initial data here if needed
    _data = fetchData(); // Replace with your data fetching method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull-to-Refresh Example'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_data[index]),
            );
          },
        ),
      ),
    );
  }

  void _onRefresh() async {
    // Simulate a delay for fetching new data
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      // Update _data with new data fetched
      _data = fetchData(); // Replace with your data fetching method
      _isRefreshing = false;
    });

    _refreshController.refreshCompleted();
  }

  List<String> fetchData() {
    // Replace this with your actual data fetching logic
    return List.generate(20, (index) => 'Item ${index + 1}');
  }
}




// import 'package:flutter/material.dart';
// import 'my_refreshable_list.dart'; // Import the file where MyRefreshableList is defined

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pull-to-Refresh Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyRefreshableList(), 
    );
  }
}
