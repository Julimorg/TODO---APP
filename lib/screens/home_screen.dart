import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_internship/screens/about_screen.dart';
import 'package:todo_internship/screens/settings_screen.dart';
import '../providers/todo_provider.dart';
import '../widgets/animated_fab.dart';
import '../widgets/resuble_navigation_push.dart';
import '../widgets/todo_list_widget.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Master'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show the Bottom Sheet with options
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25)), // Rounded top corners
                ),
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header title
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "App Settings",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        //? SETTING
                        ListTile(
                          leading:
                              const Icon(Icons.settings, color: Colors.blue),
                          title: const Text(
                            "Settings",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text("Manage your app settings"),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            navigateWithFadeTransition(
                              context: context,
                              targetPage: const SettingsScreen(),
                            );
                          },
                        ),
                        //? ABOUT
                        ListTile(
                          leading: const Icon(Icons.info_outline,
                              color: Colors.green),
                          title: const Text(
                            "About",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text("Learn more about the app"),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            navigateWithFadeTransition(
                              context: context,
                              targetPage: const AboutScreen(),
                            );
                          },
                        ),
                        //? CHANGE VIEW
                        ListTile(
                          leading: const Icon(Icons.account_tree_outlined,
                              color: Colors.orange),
                          title: const Text(
                            "Change View",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle:
                              const Text("Change your view from list to grid"),
                          onTap: () {},
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: _getBodyWidget(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: AnimatedFAB(
        onAddTask: () {
          navigateWithFadeTransition(
            context: context,
            targetPage: const AddTodoScreen(),
          );
        },
      ),
    );
  }

  //** Main Body Show List Items */
  Widget _getBodyWidget() {
    final todoProvider = Provider.of<TodoProvider>(context);
    //? Switch Navigation
    //? Case 1 -> Incompletet Items
    //? Case 2 -> CompleteItems
    switch (_selectedIndex) {
      case 0:
        return TodoListWidget(todos: todoProvider.incompleteTodos);
      case 1:
        return TodoListWidget(todos: todoProvider.completedTodos);
      default:
        return TodoListWidget(todos: todoProvider.todos);
    }
  }

  //? Bottom Navigation Widget
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Active',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          label: 'Completed',
        ),
      ],
    );
  }
}
