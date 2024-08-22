import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.yellow, // Menggunakan warna yang lebih umum
      ),
      home: TabScreen(),
    );
  }
}

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4 - Mobile Apps'),
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Beranda'),
            Tab(icon: Icon(Icons.person), text: 'Users'),
            Tab(icon: Icon(Icons.account_circle), text: 'Profil'), // Ganti icon untuk Profil
          ],
          labelColor: Color.fromARGB(255, 243, 33, 33),
          unselectedLabelColor: Color.fromARGB(255, 158, 158, 158),
          indicatorColor: Color.fromARGB(255, 180, 243, 33),
        ),
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school, 'label': 'School'},
    {'icon': Icons.gamepad, 'label': 'Games'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
    {'icon': Icons.assignment, 'label': 'Assignments'},
    {'icon': Icons.chat, 'label': 'Chat'},
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.map, 'label': 'Map'},
    {'icon': Icons.calendar_today, 'label': 'Calendar'},
    {'icon': Icons.contact_phone, 'label': 'Contact'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Dashboard Summary Widget
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.school, color: Colors.white, size: 50),
                    Text('School', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.notifications, color: Colors.white, size: 50),
                    Text('Notifications', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.chat, color: Colors.white, size: 50),
                    Text('Chat', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // GridView Widget
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return GestureDetector(
                  onTap: () {
                    print('${item['label']} tapped');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(item['icon'], size: 50.0, color: Color.fromARGB(215, 1, 7, 37)),
                      SizedBox(height: 8.0),
                      Text(
                        item['label'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 216, 109, 109)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UsersTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final users = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // User Statistics Widget
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 78, 0, 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text('Total Users', style: TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(height: 10),
                        Text(users.length.toString(), style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // List of Users
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user.firstName),
                          subtitle: Text(user.email),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('fdln.jpg'), // Pastikan path gambar benar
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Fadlanways',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Email: fadlan31@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Biodata',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Nama Lengkap'),
            subtitle: Text('Fadlan M. A Permadi'),
          ),
          ListTile(
            leading: Icon(Icons.cake),
            title: Text('Tanggal Lahir'),
            subtitle: Text('31 July 2007'),
          ),
          SizedBox(height: 20),
          // Additional Profile Info Widget
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('Additional Info', style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                Text('More details about the profile can go here.', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String firstName;
  final String email;

  User({required this.firstName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}
