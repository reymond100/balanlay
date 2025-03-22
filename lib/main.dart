import 'package:flutter/material.dart';

void main() {
  runApp(const PetTrackerApp());
}

class PetTrackerApp extends StatelessWidget {
  const PetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown, // Changed to brown
        scaffoldBackgroundColor: Colors.grey[200], // Light gray background
      ),
      home: const PetTrackerHomePage(),
    );
  }
}

class PetTrackerHomePage extends StatefulWidget {
  const PetTrackerHomePage({super.key});

  @override
  State<PetTrackerHomePage> createState() => _PetTrackerHomePageState();
}

class _PetTrackerHomePageState extends State<PetTrackerHomePage> {
  final Map<String, String> _petTypes = {};
  final Map<String, List<String>> _activities = {};
  final Map<String, String> _petHealth = {};
  final List<String> _petProfiles = ["Buddy", "Mittens"];
  String _selectedPet = "Buddy";
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petTypeController = TextEditingController();
  int _selectedIndex = 0; // For bottom navigation bar

  void _changePet(String pet) {
    setState(() {
      _selectedPet = pet;
    });
  }

  void _renamePet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Rename Pet"),
          content: TextField(
            controller: _petNameController,
            decoration: const InputDecoration(hintText: "Enter new pet name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_petNameController.text.isNotEmpty) {
                  setState(() {
                    int index = _petProfiles.indexOf(_selectedPet);
                    if (index != -1) {
                      _petProfiles[index] = _petNameController.text;
                      _selectedPet = _petNameController.text;
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Rename"),
            ),
          ],
        );
      },
    );
  }

  void _addActivity() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController activityController = TextEditingController();
        DateTime selectedDate = DateTime.now();
        TimeOfDay selectedTime = TimeOfDay.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Pet Activity"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: activityController,
                    decoration: const InputDecoration(hintText: "Enter activity"),
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text("Select Date"),
                  ),
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                    child: const Text("Select Time"),
                  ),
                  Text(
                      "Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}"),
                  Text("Selected Time: ${selectedTime.format(context)}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (activityController.text.isNotEmpty) {
                      setState(() {
                        _activities.putIfAbsent(_selectedPet, () => []);
                        _activities[_selectedPet]!.add(
                            "${activityController.text} on ${selectedDate.toLocal().toString().split(' ')[0]} at ${selectedTime.format(context)}");
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addHealthRecord() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController healthController = TextEditingController();

        return AlertDialog(
          title: const Text("Add Health Record"),
          content: TextField(
            controller: healthController,
            decoration: const InputDecoration(hintText: "Enter health details"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (healthController.text.isNotEmpty) {
                  setState(() {
                    _petHealth[_selectedPet] = healthController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _viewHealthCondition() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Health Condition"),
          content: Text(_petHealth[_selectedPet] ?? "No health record available"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _addPet() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newPetNameController = TextEditingController();
        TextEditingController newPetTypeController = TextEditingController();

        return AlertDialog(
          title: const Text("Add New Pet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPetNameController,
                decoration: const InputDecoration(hintText: "Enter pet name"),
              ),
              TextField(
                controller: newPetTypeController,
                decoration: const InputDecoration(hintText: "Enter pet type (e.g., Dog, Cat)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (newPetNameController.text.isNotEmpty &&
                    newPetTypeController.text.isNotEmpty) {
                  setState(() {
                    _petProfiles.add(newPetNameController.text);
                    _petTypes[newPetNameController.text] =
                        newPetTypeController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deleteActivity(int index) {
    setState(() {
      _activities[_selectedPet]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Tracker"),
        backgroundColor: Colors.brown[700], // Dark brown app bar
        elevation: 10,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown[700]!, Colors.brown[400]!], // Brown gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add notifications functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add settings functionality
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown[700]!, Colors.brown[400]!], // Brown gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 80, color: Colors.white),
                  Text(
                    "$_selectedPet's Profile",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text("Switch Pet"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Select Pet"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _petProfiles.map((pet) {
                          return ListTile(
                            title: Text(pet),
                            onTap: () {
                              _changePet(pet);
                              Navigator.of(context).pop();
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Rename Pet"),
              onTap: _renamePet,
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety),
              title: const Text("Add Health Record"),
              onTap: _addHealthRecord,
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text("View Health Condition"),
              onTap: _viewHealthCondition,
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add New Pet"),
              onTap: _addPet,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.grey[300]!], // Light gray gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: _activities[_selectedPet]?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              elevation: 5,
              shadowColor: Colors.brown.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  _activities[_selectedPet]![index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.pets, color: Colors.brown),
                tileColor: Colors.white,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteActivity(index),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[700], // Dark brown FAB
        onPressed: _addActivity,
        tooltip: 'Add Activity',
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.brown[700], // Dark brown selected icon
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}