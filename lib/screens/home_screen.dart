import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_internship/screens/about_screen.dart';
import 'package:todo_internship/screens/notification.dart';
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
  final TextEditingController _controller =
      TextEditingController(); //--> Check empty field
  int _selectedIndex = 0;
  bool isChangeView = false; //--> Change View for todo_list_widget
  //? Show dialog when input field is empty
  void _onSearch() {
    if (_controller.text.trim().isEmpty) {
      _showDeleteConfirmationDialog(context);
    } else {
      // Xử lý logic tìm kiếm tại đây
      print('Đang tìm kiếm: ${_controller.text}');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Delete Task?",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to delete this task? This action cannot be undone and will permanently remove the task from your list.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Provider.of<TodoProvider>(context, listen: false)
                        //     .deleteTodo(todo.id);
                        // Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        "Delete",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Master'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              //? Show the Bottom Sheet with options
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
                          onTap: () {
                            setState(() {
                              isChangeView = !isChangeView;
                              String text = isChangeView.toString();
                              print("$text");
                            });
                          },
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

      //? Nên cố định khung lại cho _getBodyWiget vì các bên trong chứa TodoListWidget
      //? và TodoListWidget lại gọi các Card theo dạng listView
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
        return TodoListWidget(
          todos: todoProvider.incompleteTodos,
          isChangeView: isChangeView,
        );
      case 1:
        return TodoListWidget(
            todos: todoProvider.completedTodos, isChangeView: isChangeView);
      case 2:
        return const NotificationPage();
      default:
        return TodoListWidget(
            todos: todoProvider.todos, isChangeView: isChangeView);
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
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Notification',
        ),
      ],
    );
  }
}
