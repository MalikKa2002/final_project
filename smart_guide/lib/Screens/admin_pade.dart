import 'package:flutter/material.dart';
import 'package:smart_guide/components/request.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminPage extends StatefulWidget {
  @override
  createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Dispose of the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(local.managerPage),
        automaticallyImplyLeading: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120), // space for search + tabs
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: local.search,
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Tab bar

              TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: local.request),
                  Tab(text: local.users),
                  Tab(text: local.buildings),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              RequestBody(),
              _buildUsersTab(),
              _buildBuildingsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab() => Center(child: Text('Users List Here'));
  Widget _buildBuildingsTab() => Center(child: Text('Buildings List Here'));
}
