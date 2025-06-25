import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srbapp/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Make sure dashboard.dart is created
// Save user
void saveUser(String name) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('username', name);
}

// Get user
Future<String?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
void main() {
  runApp(const SmartRespiratoryBeltApp());
}

class SmartRespiratoryBeltApp extends StatelessWidget {
  const SmartRespiratoryBeltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Respiratory Belt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/dashboard': (context) => const DashboardPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoginSelected = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCreateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      _usernameController.clear();
      _fullNameController.clear();
      _ageController.clear();
      _genderController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully!')),
      );

      setState(() => _isLoginSelected = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile creation failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_outlined, color: Colors.blueAccent, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    "Smart Respiratory Belt",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Monitor your respiratory health",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Toggle buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => setState(() => _isLoginSelected = true),
                          style: TextButton.styleFrom(
                            backgroundColor: _isLoginSelected ? Colors.blueAccent : Colors.grey[200],
                          ),
                          child: Text("Login",
                            style: TextStyle(
                              color: _isLoginSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () => setState(() => _isLoginSelected = false),
                          style: TextButton.styleFrom(
                            backgroundColor: !_isLoginSelected ? Colors.blueAccent : Colors.grey[200],
                          ),
                          child: Text("Create Profile",
                            style: TextStyle(
                              color: !_isLoginSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Login Form
                  if (_isLoginSelected) ...[
                    TextFormField(
                      controller: _loginEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _loginPasswordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter your password';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Create Profile Form
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => (value == null || value.length < 4)
                          ? 'Username must be at least 4 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter your full name'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: "Age",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter your age';
                        if (int.tryParse(value) == null) return 'Enter valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _genderController.text.isEmpty ? null : _genderController.text,
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        prefixIcon: Icon(Icons.people),
                      ),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(value: "Female", child: Text("Female")),
                        DropdownMenuItem(value: "Prefer not to say", child: Text("Prefer not to say")),
                      ],
                      onChanged: (value) => setState(() => _genderController.text = value ?? ''),
                      validator: (value) => value == null || value.isEmpty ? 'Select your gender' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isPasswordVisible,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) => value != _passwordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _isLoginSelected
                              ? _handleLogin
                              : _handleCreateProfile,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_isLoginSelected ? "Login" : "Create Profile"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
