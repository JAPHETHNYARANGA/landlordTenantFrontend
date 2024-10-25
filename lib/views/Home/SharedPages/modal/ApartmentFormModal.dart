import 'package:flutter/material.dart';
import '../../../../Services/apartmentService.dart';

class ApartmentFormModal extends StatefulWidget {
  final VoidCallback? onApartmentAdded; // Add this line

  ApartmentFormModal({this.onApartmentAdded}); // Update the constructor

  @override
  _ApartmentFormModalState createState() => _ApartmentFormModalState();
}

class _ApartmentFormModalState extends State<ApartmentFormModal> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _location = '';
  String _description = '';
  int _bedrooms = 0;
  int _bathrooms = 0;
  double _price = 0.0;

  final ApartmentService _apartmentService = ApartmentService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Apartment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apartment Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the apartment name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Bedrooms'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bedrooms = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Bathrooms'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bathrooms = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price per Month'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    var apartmentData = {
                      'name': _name,
                      'location': _location,
                      'description': _description,
                      'bedrooms': _bedrooms,
                      'bathrooms': _bathrooms,
                      'price': _price,
                    };

                    bool success = await _apartmentService.addApartment(apartmentData);
                    if (success) {
                      Navigator.pop(context);
                      if (widget.onApartmentAdded != null) {
                        widget.onApartmentAdded!(); // Call the callback
                      }
                    } else {
                      // Handle failure case (e.g., show a dialog)
                    }
                  }
                },
                child: Text('Add Apartment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
