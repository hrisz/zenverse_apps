import 'package:flutter/material.dart';

class DeveloperMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon/blue-logo.png',
          height: 30,
        ),
        backgroundColor: const Color.fromARGB(255, 54, 57, 62),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/aboutbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            DeveloperProfile(
              name: 'Haris Saefuloh',
              role: '714220061 - FE Developer',
              imageUrl: 'https://avatars.githubusercontent.com/u/60280111?v=4',
              description: 'Passionate about user experience and interface design. Also interested on game development and looking for a new project related to it.',
            ),
            SizedBox(height: 20),
            DeveloperProfile(
              name: 'Rayfan Aqbil',
              role: '714220044 - BE Developer',
              imageUrl: 'https://avatars.githubusercontent.com/u/114157212?v=4',
              description: 'Expert in backend development and cloud. I always aim for the impossible because no system is safe.',
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperProfile extends StatefulWidget {
  final String name;
  final String role;
  final String imageUrl;
  final String description;

  DeveloperProfile({required this.name, required this.role, required this.imageUrl, required this.description});

  @override
  _DeveloperProfileState createState() => _DeveloperProfileState();
}

class _DeveloperProfileState extends State<DeveloperProfile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.imageUrl),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.role,
                        style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 106, 106, 106)),
                      ),
                    ],
                  ),
                ],
              ),
              if (_isExpanded)
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    widget.description,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
