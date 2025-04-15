import 'package:flutter/material.dart';

class Request {
  final String id;
  final String title;
  final String description;
  final String submittedBy;
  String status; // "Pending", "Accepted", "Rejected"

  Request({
    required this.id,
    required this.title,
    required this.description,
    required this.submittedBy,
    this.status = "Pending",
  });
}

class RequestBody extends StatefulWidget {
  const RequestBody({super.key});

  @override
  createState() => _RequestBodyState();
}

class _RequestBodyState extends State<RequestBody> {
  List<Request> requests = [
    Request(
      id: '1',
      title: 'Add Building A',
      description: 'Request to add a new building on campus map.',
      submittedBy: 'Hadeel123',
    ),
    Request(
      id: '2',
      title: 'Add Library',
      description: 'New library wing needs to be added.',
      submittedBy: 'User456',
    ),
  ];

  void acceptRequest(String id) {
    setState(() {
      requests.firstWhere((req) => req.id == id).status = "Accepted";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Request Accepted")),
    );
  }

  void rejectRequest(String id) {
    setState(() {
      requests.firstWhere((req) => req.id == id).status = "Rejected";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Request Rejected")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(req.title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(req.description),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 18, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("By: ${req.submittedBy}",
                        style: TextStyle(color: Colors.grey)),
                    Spacer(),
                    Chip(
                      label: Text(req.status),
                      backgroundColor: req.status == "Accepted"
                          ? Colors.green.withOpacity(0.2)
                          : req.status == "Rejected"
                              ? Colors.red.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: req.status == "Accepted"
                            ? Colors.green
                            : req.status == "Rejected"
                                ? Colors.red
                                : Colors.orange,
                      ),
                    ),
                  ],
                ),
                if (req.status == "Pending") ...[
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: Icon(Icons.close, color: Colors.red),
                        label: Text("Reject"),
                        onPressed: () => rejectRequest(req.id),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: Icon(Icons.check),
                        label: Text("Accept"),
                        onPressed: () => acceptRequest(req.id),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
