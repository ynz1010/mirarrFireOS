import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Mirarr/functions/regionprovider_class.dart';
import 'package:Mirarr/functions/themeprovider_class.dart';
import 'package:Mirarr/functions/supabase_provider.dart';
import 'package:Mirarr/services/supabase_sync_service.dart';
import 'package:Mirarr/widgets/custom_divider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _supabaseUrlController = TextEditingController();
  final TextEditingController _supabaseAnonKeyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool _isSyncing = false;
  Map<String, dynamic>? _syncStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final supabaseProvider = Provider.of<SupabaseProvider>(context, listen: false);
      _supabaseUrlController.text = supabaseProvider.supabaseUrl ?? '';
      _supabaseAnonKeyController.text = supabaseProvider.supabaseAnonKey ?? '';
      _loadSyncStatus();
    });
  }

  @override
  void dispose() {
    _supabaseUrlController.dispose();
    _supabaseAnonKeyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadSyncStatus() async {
    final supabaseProvider = Provider.of<SupabaseProvider>(context, listen: false);
    if (supabaseProvider.isConfigured) {
      final syncService = SupabaseSyncService(supabaseProvider.client);
      final status = await syncService.getSyncStatus();
      setState(() {
        _syncStatus = status;
      });
    }
  }

  void _saveSupabaseConfig() async {
    if (_formKey.currentState!.validate()) {
      final supabaseProvider = Provider.of<SupabaseProvider>(context, listen: false);
      await supabaseProvider.setSupabaseConfig(
        _supabaseUrlController.text.trim().isEmpty ? null : _supabaseUrlController.text.trim(),
        _supabaseAnonKeyController.text.trim().isEmpty ? null : _supabaseAnonKeyController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration saved')),
      );
    }
  }

  void _syncData() async {
    setState(() => _isSyncing = true);
    final supabaseProvider = Provider.of<SupabaseProvider>(context, listen: false);
    final syncService = SupabaseSyncService(supabaseProvider.client);
    await syncService.syncData();
    await _loadSyncStatus();
    setState(() => _isSyncing = false);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        // Optional: Add global key handling here
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children
