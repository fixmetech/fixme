import 'package:fixme/styles/app_headings.dart';
import 'package:fixme/widgets/activity_list.dart';
import 'package:flutter/material.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Your Activities', style: heading1),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                indicatorColor: const Color.fromRGBO(46, 49, 146, 1),
                indicatorWeight: 4,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                padding: const EdgeInsets.only(left: 16),
                indicatorPadding: const EdgeInsets.only(left: 16, right: 16),
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: 'OnGoing'),
                  Tab(text: 'UpComing'),
                  Tab(text: 'Cancelled'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
          ),
        ),

        body: const TabBarView(
          children: [
            ActivityList(type: 'Ongoing'),
            ActivityList(type: 'Completed'),
            ActivityList(type: 'Upcoming'),
            ActivityList(type: 'Cancelled'),
            ActivityList(type: 'Completed'),
          ],
        ),
      ),
    );
  }
}
