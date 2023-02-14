import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myferrykl/bookings.dart';
import 'package:myferrykl/db/db.dart';

import 'db/User.dart';

// Create a Form widget.
class ViewBookingForm extends StatefulWidget {
  final String userID;
  final String bookingId;
  const ViewBookingForm({required this.userID, required this.bookingId});
  @override
  ViewBookingFormState createState() {
    return ViewBookingFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class ViewBookingFormState extends State<ViewBookingForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController surnameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController departCtrl = TextEditingController();
  TextEditingController destCtrl = TextEditingController();
  TextEditingController journeyCtrl = TextEditingController();

  String dropdownvalue1 = '';
  String dropdownvalue2 = '';

  // List of items in our dropdown menu
  var items = [
    'Kuala Lumpur',
    'Johor',
    'Penang',
    'Langkawi',
    'Malacca',
    'Jakarta',
    'Singapore',
    'Dumai',
  ];

  bool _checkbox = false;
  bool _checkboxListTile = false;

  @override
  void initState() {
    final db = DBService();
    var data = db.findSpeceficBooking(widget.userID, widget.bookingId);
    data.then((value) => assignTextValues(value));

    super.initState();
  }

  Future<List<dynamic>> GetAllData() async {
    final db = DBService();
    var data = db.findSpeceficBooking(widget.userID, widget.bookingId);
    data.then((value) => assignTextValues(value));

    return data;
  }
  bool initialValuesAssigned = false;
  void assignTextValues(var value) {
    if(initialValuesAssigned ==false) {
      nameCtrl.text = value[0];
      surnameCtrl.text = value[1];
      phoneCtrl.text = value[2];
      dateInput.text = value[4];
      dropdownvalue1 = value[6];
      dropdownvalue2 = value[7];
      initialValuesAssigned = true;
    }

  }

  String handleJourney(String journeyType) {
    if (journeyType == "One Way" || journeyType == "true") {
      return "One way";
    } else {
      return "With return ticket";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return FutureBuilder(
        future: GetAllData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Form(
                key: _formKey,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppBar(
                        title: Text('MyFerryKL',
                            style:
                                TextStyle(color: Colors.white, fontSize: 35)),
                        backgroundColor: Colors.blue,
                      ),
                      Text(
                        "View Booking",
                        style: Theme.of(context)
                            .textTheme
                            .headline5, // like <h1> in HTML
                      ),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your name',
                          labelText: 'Name',
                        ),
                      ),
                      TextFormField(
                        controller: surnameCtrl,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your Surname',
                          labelText: 'Surname',
                        ),
                      ),
                      TextFormField(
                        controller: phoneCtrl,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.phone),
                          hintText: 'Enter a phone number',
                          labelText: 'Phone',
                        ),
                      ),
                      Container(
                          child: TextField(
                        controller: dateInput,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "Enter Date" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              dateInput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      )),
                      SizedBox(height: 10),
                      Container(
                          margin: const EdgeInsets.only(left: 40.0),
                          child: Text('Departing From')),
                      Container(
                          margin: const EdgeInsets.only(left: 40.0),
                          child: DropdownButton(
                            // Initial Value
                            value: dropdownvalue1,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue1 = newValue!;
                              });
                            },
                          )),
                      SizedBox(height: 10),
                      Container(
                          margin: const EdgeInsets.only(left: 40.0),
                          child: Text('Arriving at')),
                      Container(
                          margin: const EdgeInsets.only(left: 40.0),
                          child: DropdownButton(
                            // Initial Value
                            value: dropdownvalue2,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue2 = newValue!;
                              });
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text('One way'),
                          value: _checkbox,
                          onChanged: (value) {
                            setState(() {
                              _checkbox = !_checkbox;
                            });
                          },
                        ),
                      ),
                      Center(
                        child: ButtonBar(
                          alignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                          ElevatedButton(
                            child: Text('Save'),
                            onPressed: () {
                              final db = DBService();
                              db.updateBooking(
                                  widget.userID,
                                  widget.bookingId,
                                  nameCtrl.text,
                                  surnameCtrl.text,
                                  phoneCtrl.text,
                                  DateTime.parse(dateInput.text).toString(),
                                  dropdownvalue1,
                                  dropdownvalue2,
                                  handleJourney(_checkbox.toString()));
                            },
                          ),
                          ElevatedButton(
                            child: Text('Delete'),
                            onPressed: () {
                              final db = DBService();
                              db.deleteBooking(widget.userID, widget.bookingId);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Bookings(userID: widget.userID)));

                            },
                          ),
                          ElevatedButton(
                            child: Text('Back to Bookings'),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Bookings(userID: widget.userID)));
                            },
                          ),
                        ],
                      ),),
                    ],
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
