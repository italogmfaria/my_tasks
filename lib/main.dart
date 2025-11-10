import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'viewmodels/shared_preferences_viewmodel.dart';
import 'viewmodels/file_viewmodel.dart';
import 'viewmodels/sqlite_viewmodel.dart';
import 'views/task_list_view.dart';
import 'widgets/platform_warning.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SharedPreferencesViewModel()),
        ChangeNotifierProvider(create: (_) => FileViewModel()),
        ChangeNotifierProvider(create: (_) => SQLiteViewModel()),
      ],
      child: MaterialApp(
        title: 'MyTasks',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize all ViewModels
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SharedPreferencesViewModel>().initialize();
      context.read<FileViewModel>().initialize();
      context.read<SQLiteViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyTasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.settings_backup_restore),
              text: 'SharedPreferences',
            ),
            Tab(
              icon: Icon(Icons.insert_drive_file),
              text: 'File',
            ),
            Tab(
              icon: Icon(Icons.storage),
              text: 'SQLite',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // SharedPreferences Tab
          Consumer<SharedPreferencesViewModel>(
            builder: (context, viewModel, child) {
              return TaskListView(
                tasks: viewModel.tasks,
                isLoading: viewModel.isLoading,
                onToggle: (id) => viewModel.toggleTask(id),
                onDelete: (id) => viewModel.deleteTask(id),
                onAdd: (title) => viewModel.addTask(title),
              );
            },
          ),

          // File Tab
          Consumer<FileViewModel>(
            builder: (context, viewModel, child) {
              return TaskListView(
                tasks: viewModel.tasks,
                isLoading: viewModel.isLoading,
                onToggle: (id) => viewModel.toggleTask(id),
                onDelete: (id) => viewModel.deleteTask(id),
                onAdd: (title) => viewModel.addTask(title),
              );
            },
          ),

          // SQLite Tab
          Consumer<SQLiteViewModel>(
            builder: (context, viewModel, child) {
              return SQLiteTabWrapper(
                child: TaskListView(
                  tasks: viewModel.tasks,
                  isLoading: viewModel.isLoading,
                  onToggle: (id) => viewModel.toggleTask(id),
                  onDelete: (id) => viewModel.deleteTask(id),
                  onAdd: (title) => viewModel.addTask(title),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

