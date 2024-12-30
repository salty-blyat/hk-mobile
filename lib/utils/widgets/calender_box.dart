import 'package:flutter/material.dart';

class CalenderBox extends StatelessWidget {
  const CalenderBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 221, 221, 221),
              spreadRadius: 0.1,
              blurRadius: 1,
              offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: const Center(
                child: Text(
                  'សុក្រ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
                child: Text(
              '27',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
          )
        ],
      ),
    );
  }
}
