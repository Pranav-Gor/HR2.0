import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class pointaccumulation extends StatefulWidget {
  const pointaccumulation({Key? key, required this.employeeId})
      : super(key: key);

  final String employeeId;

  @override
  State<pointaccumulation> createState() => _pointaccumulationState();
}

class _pointaccumulationState extends State<pointaccumulation> {
  Color primary = const Color(0xffeef444c);
  Map<String, dynamic>? employeeData;
  late List<Map<String, dynamic>> pointsData = [];
  String totalPoints = '0';

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
    fetchEmployeePoints();
    print('points:$totalPoints');
  }

  Future<void> fetchEmployeeData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.29.97:8080//'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final Map<String, dynamic>? empData = jsonData.firstWhere(
          (employee) => employee['userid'] == widget.employeeId,
          orElse: () => null,
        );
        if (empData != null) {
          setState(() {
            employeeData = empData;
            totalPoints = employeeData!['points'];
          });
        } else {
          print('Employee with ID ${widget.employeeId} not found');
        }
      } else {
        print('Failed to fetch employee data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching employee data: $e');
    }
  }

  Future<void> fetchEmployeePoints() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:5000/api/point'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        setState(() {
          pointsData = List<Map<String, dynamic>>.from(decodedData);
        });
        print('pointsData:$pointsData');
      } else {
        print('Failed to fetch points data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching points data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Point Accumulation',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'NexaBold',
          ),
        ),
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white12],
                  begin: Alignment.centerLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$totalPoints',
                    style: TextStyle(
                      fontFamily: 'NexaBold',
                      fontSize: 28,
                      color: primary,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'You gained $totalPoints points this month',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'NexaRegular',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            if (pointsData.isNotEmpty) ...[
              _buildPointsInfoCard(
                'Performance Points',
                'You get ${pointsData[0]['performancepoints']} points for achieving specific goals and meeting targets.',
                'assets/images/vecv2.jpg',
              ),
              SizedBox(height: 8.0),
              _buildPointsInfoCard(
                'Attendance Points',
                'You get ${pointsData[0]['attendancepoints']} points for achieving attendance.',
                'assets/images/att3.png',
              ),
              SizedBox(height: 8.0),
              _buildPointsInfoCard(
                'Seminar Points',
                'You get ${pointsData[0]['seminarpoints']} points for contributing innovation ideas.',
                'assets/images/inn1.jpg',
              ),
              SizedBox(height: 8.0),
            ],
            if (pointsData.isEmpty)
              Center(
                  child:
                      CircularProgressIndicator()), // Show a loading indicator while data is being fetched
          ],
        ),
      ),
    );
  }

  Widget _buildPointsInfoCard(
      String title, String description, String imagePath) {
    return Container(
      height: 150.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                imagePath,
                height: 150.0,
                width: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "NexaBold",
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: "NexaRegular",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
