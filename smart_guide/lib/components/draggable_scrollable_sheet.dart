import 'package:flutter/material.dart';
import 'package:smart_guide/components/quick_button.dart';

class MapWithBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.20,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // The scrollable content
              SizedBox(height: 20),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Where to go?',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          QuickButton(icon: Icons.home, label: "Home"),
                          QuickButton(icon: Icons.work, label: "Work"),
                          QuickButton(icon: Icons.add, label: "New"),
                        ],
                      ),
                      // Add more items here
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
