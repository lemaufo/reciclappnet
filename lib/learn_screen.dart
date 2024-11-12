import 'package:flutter/material.dart';
import 'package:reciclapp/custom_bottom_nav_bar.dart';
import 'package:reciclapp/chat_gpt_service.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final ChatGPTService _chatGptService = ChatGPTService();
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  List<String> suggestions = [
    '¿Cómo reciclar plástico?',
    'Beneficios del reciclaje',
    'Reciclaje en casa',
    'Materiales reciclables',
  ];

  Future<void> _getResponse(String query) async {
    // Verifica si el widget está montado antes de llamar a setState
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final response = await _chatGptService.obtenerRespuesta(query);
      if (mounted) {
        setState(() {
          _response = response;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _response = 'Error: No se pudo obtener respuesta.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 78.0,
        title: const Text(
          'Aprende',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: const SizedBox(),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
