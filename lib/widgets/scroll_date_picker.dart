import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScrollDatePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final Function(String) onDateSelected;

  const ScrollDatePicker({
    Key? key,
    required this.initialDateTime,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<ScrollDatePicker> createState() => _EditPageScrollDateEvent();
}

class _EditPageScrollDateEvent extends State<ScrollDatePicker> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    //? Fixing Dark Mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final shadowColor =
        isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.2);
    final textBorderColor = isDarkMode ? Colors.white : Colors.black;
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Center(
      child: Container(
        width: width * 0.75,
        height: height * 0.55,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(children: [
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: Container(
              child: CupertinoDatePicker(
                initialDateTime: dateTime,
                backgroundColor: backgroundColor,
                onDateTimeChanged: (DateTime newTime) {
                  if (newTime != dateTime) {
                    setState(() => dateTime = newTime);
                  }
                },
                use24hFormat: true,
                mode: CupertinoDatePickerMode.date,
                minimumDate: DateTime(2010, 1, 1),
                maximumDate: DateTime(2050, 12, 31),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    // Trả lại giá trị ngày đã chọn
                    Navigator.pop(context,
                        "${dateTime.day}/${dateTime.month}/${dateTime.year}");
                    widget.onDateSelected(
                        "${dateTime.day}/${dateTime.month}/${dateTime.year}"); // Gọi callback
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 1, color: textBorderColor),
                    ),
                  ),
                  child: Text(
                    "Confirm !",
                    style: TextStyle(
                      color: textColor,
                      fontFamily: "intern",
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 1, color: textBorderColor),
                    ),
                  ),
                  child: Text(
                    "Cancel!",
                    style: TextStyle(
                      color: textColor,
                      fontFamily: "intern",
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

void showEditDateDialog(BuildContext context, DateTime initialDateTime,
    Function(String) onDateSelected) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: ScrollDatePicker(
          initialDateTime: initialDateTime,
          onDateSelected: onDateSelected,
        ),
      );
    },
  );
}
