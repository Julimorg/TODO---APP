import 'package:hive/hive.dart';

part 'todo_model.g.dart';

//Step 1: Loại bỏ Hive
//Step 2: Tạo Entity tương xứng chứa tên bảng, tên cột
//Step 3: Thêm entity đó và Model Class --> để dễ truy xuất thông tin

//Những model cần tạo
//Pritory (giữ nguyên)
//TodoModel (Thêm imagePath, userId, trashId) --> Xử lý multitask như thế nào ? (progress)
// --> TableTodoModel (kTableName, kCol<Tên>)
//Notification (userId, notificationId, header, title, content, dateSent)
// --> TableNotification (kTableName, kCol<Tên>)
//User (userId (deviceId), deviceName)
// --> TableUser (kTableName, kCol<Tên>)
//Trash (userId, trashId, dateDeleted)
// --> TableTrash (kTableName, kCol<Tên>)

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  Priority priority;

  //? Đã thêm một trường DateTime mới
  //? Set DateTime? để tránh bị null
  @HiveField(6)
  DateTime? setDateTime;

  @HiveField(7)
  String imageDescription;

  TodoModel({
    required this.id,
    required this.title,
    this.description = '',
    this.imageDescription = '',
    DateTime? setDateTime,
    this.isCompleted = false,
    this.priority = Priority.low,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        setDateTime = setDateTime ?? DateTime.now();
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high
}
