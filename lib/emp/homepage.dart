import 'package:flutter/material.dart';
import 'dart:async';

class EmployeeHomePage extends StatefulWidget {
  final String username;

  const EmployeeHomePage({super.key, required this.username});

  @override
  _EmployeeHomePageState createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  late String currentTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    currentTime = _getCurrentTime();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  Widget _buildDrawer(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return Drawer(
      width: isTablet ? size.width * 0.3 : size.width * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.red,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isTablet ? 40 : 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: isTablet ? 50 : 35,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Hello, ${widget.username}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(Icons.home, "Home", isTablet),
                _buildDrawerItem(Icons.card_giftcard, "Rewards", isTablet),
                _buildDrawerItem(Icons.school, "Training & Development", isTablet),
                _buildDrawerItem(Icons.task, "My Tasks", isTablet),
                _buildDrawerItem(Icons.airplane_ticket, "Leave", isTablet),
                _buildDrawerItem(Icons.currency_rupee, "Salary", isTablet),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isTablet) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 12 : 8,
      ),
      leading: Icon(
        icon,
        color: Colors.grey,
        size: isTablet ? 32 : 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isTablet ? 20 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 16,
        vertical: isTablet ? 24 : 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome ${widget.username}",
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "30 March 2024",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currentTime,
            style: TextStyle(
              fontSize: isTablet ? 24 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton(bool isTablet) {
    return Container(
      width: isTablet ? 300 : 200,
      height: isTablet ? 300 : 200,
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 16,
        vertical: isTablet ? 24 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Add functionality for "Scan to Check In"
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: isTablet ? 80 : 60,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                "Scan to Check In",
                style: TextStyle(
                  fontSize: isTablet ? 24 : 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(bool isTablet) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month, size: isTablet ? 32 : 24),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: isTablet ? 32 : 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: isTablet ? 32 : 24),
          label: 'Profile',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart HR",
          style: TextStyle(
            fontSize: isTablet ? 28 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isTablet),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (isTablet)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildScanButton(isTablet),
                          // Add more widgets for tablet layout
                        ],
                      )
                    else
                      _buildScanButton(isTablet),
                  ],
                ),
              ),
            ),
            _buildBottomNavBar(isTablet),
          ],
        ),
      ),
    );
  }
}