import 'package:flutter/material.dart';

class FinancialStatementsScreen extends StatelessWidget {
  // Dummy data for financial records
  final List<Map<String, String>> financialRecords = [
    {
      'date': '2024-10-01',
      'amount': 'KSH 5,000.00',
      'description': 'Rent for October',
    },
    {
      'date': '2024-09-01',
      'amount': 'KSH 5,000.00',
      'description': 'Rent for September',
    },
    {
      'date': '2024-08-01',
      'amount': 'KSH 5,000.00',
      'description': 'Rent for August',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Statements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: financialRecords.length,
          itemBuilder: (context, index) {
            final record = financialRecords[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: ${record['date']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Amount: ${record['amount']}'),
                          Text('Description: ${record['description']}'),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.download, color: Colors.blue),
                          onPressed: () {
                            // Handle download action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Download ${record['description']}')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Handle delete action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Deleted ${record['description']}')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
