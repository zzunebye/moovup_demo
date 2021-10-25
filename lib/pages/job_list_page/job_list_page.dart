import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moovup_demo/blocs/HomeBloc/home_bloc.dart';
import 'package:moovup_demo/blocs/HomeBloc/home_events.dart';
import 'package:moovup_demo/pages/job_search_page/job_search_page.dart';
import 'package:moovup_demo/services/graphql_service_deprecated.dart';
import 'package:moovup_demo/widgets/drawer.dart';
import 'package:moovup_demo/widgets/job_list.dart';

class JobListPage extends StatefulWidget {
  static const routeName = '/jobList';

  JobListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          HomeBloc(GraphQLService())..add(FetchHomeData()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => JobSearchPage(
                      title: 'Searching',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.manage_search),
              tooltip: 'Show Search Bar',
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: JobList(),
      ),
    );
  }
}
