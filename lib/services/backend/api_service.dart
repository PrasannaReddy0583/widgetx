import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/ai_context.dart';
import '../../models/project_model.dart';
import '../../models/screen_model.dart';
import '../ai_context_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api'; // Configure your backend URL
  static const Duration timeout = Duration(seconds: 30);
  
  final http.Client _client = http.Client();
  String? _authToken;
  
  // Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(timeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        return data;
      }
      throw Exception('Login failed: ${response.body}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      ).timeout(timeout);
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        return data;
      }
      throw Exception('Registration failed: ${response.body}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  // Project Management
  Future<List<ProjectModel>> getProjects() async {
    final response = await _authenticatedGet('/projects');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => ProjectModel.fromJson(json)).toList();
  }
  
  Future<ProjectModel> createProject(ProjectModel project) async {
    final response = await _authenticatedPost('/projects', project.toJson());
    return ProjectModel.fromJson(jsonDecode(response.body));
  }
  
  Future<ProjectModel> updateProject(String id, ProjectModel project) async {
    final response = await _authenticatedPut('/projects/$id', project.toJson());
    return ProjectModel.fromJson(jsonDecode(response.body));
  }
  
  Future<void> deleteProject(String id) async {
    await _authenticatedDelete('/projects/$id');
  }
  
  // AI Services
  Future<Map<String, dynamic>> analyzeUIImage(String base64Image) async {
    final response = await _authenticatedPost('/ai/analyze-ui', {
      'image': base64Image,
      'type': 'screenshot',
    });
    return jsonDecode(response.body);
  }
  
  Future<Map<String, dynamic>> analyzeVideo(String videoUrl) async {
    final response = await _authenticatedPost('/ai/analyze-video', {
      'videoUrl': videoUrl,
    });
    return jsonDecode(response.body);
  }
  
  Future<String> generateCode(AIContext context, List<ScreenModel> screens) async {
    final response = await _authenticatedPost('/ai/generate-code', {
      'context': context.toJson(),
      'screens': screens.map((s) => s.toJson()).toList(),
    });
    final data = jsonDecode(response.body);
    return data['code'];
  }
  
  Future<Map<String, dynamic>> generateBackend(AIContext context) async {
    final response = await _authenticatedPost('/ai/generate-backend', {
      'context': context.toJson(),
    });
    return jsonDecode(response.body);
  }
  
  Future<Map<String, dynamic>> suggestImprovements(String code) async {
    final response = await _authenticatedPost('/ai/suggest-improvements', {
      'code': code,
    });
    return jsonDecode(response.body);
  }
  
  // Learning Platform
  Future<List<Map<String, dynamic>>> getCourses(String? category) async {
    final uri = category != null 
      ? Uri.parse('$baseUrl/courses?category=$category')
      : Uri.parse('$baseUrl/courses');
    final response = await _authenticatedGetUri(uri);
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }
  
  Future<Map<String, dynamic>> getCourseProgress(String courseId) async {
    final response = await _authenticatedGet('/courses/$courseId/progress');
    return jsonDecode(response.body);
  }
  
  Future<Map<String, dynamic>> submitLabSolution(String labId, String solution) async {
    final response = await _authenticatedPost('/labs/$labId/submit', {
      'solution': solution,
    });
    return jsonDecode(response.body);
  }
  
  // Community Features
  Future<List<Map<String, dynamic>>> getCommunityPosts({
    int page = 1,
    int limit = 20,
    String? tag,
  }) async {
    final uri = Uri.parse('$baseUrl/posts').replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
      if (tag != null) 'tag': tag,
    });
    final response = await _authenticatedGetUri(uri);
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }
  
  Future<Map<String, dynamic>> createPost(String title, String content, List<String> tags) async {
    final response = await _authenticatedPost('/posts', {
      'title': title,
      'content': content,
      'tags': tags,
    });
    return jsonDecode(response.body);
  }
  
  Future<void> upvotePost(String postId) async {
    await _authenticatedPost('/posts/$postId/upvote', {});
  }
  
  Future<Map<String, dynamic>> shareCodeSnippet(String code, String language, String description) async {
    final response = await _authenticatedPost('/snippets/share', {
      'code': code,
      'language': language,
      'description': description,
    });
    return jsonDecode(response.body);
  }
  
  // Deployment Services
  Future<Map<String, dynamic>> deployProject(String projectId, Map<String, dynamic> config) async {
    final response = await _authenticatedPost('/deploy/$projectId', config);
    return jsonDecode(response.body);
  }
  
  Future<Map<String, dynamic>> getDeploymentStatus(String deploymentId) async {
    final response = await _authenticatedGet('/deployments/$deploymentId/status');
    return jsonDecode(response.body);
  }
  
  // Helper methods
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };
  
  Future<http.Response> _authenticatedGet(String path) async {
    return _authenticatedGetUri(Uri.parse('$baseUrl$path'));
  }
  
  Future<http.Response> _authenticatedGetUri(Uri uri) async {
    final response = await _client.get(
      uri,
      headers: _headers,
    ).timeout(timeout);
    
    if (response.statusCode >= 400) {
      throw Exception('Request failed: ${response.body}');
    }
    return response;
  }
  
  Future<http.Response> _authenticatedPost(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    ).timeout(timeout);
    
    if (response.statusCode >= 400) {
      throw Exception('Request failed: ${response.body}');
    }
    return response;
  }
  
  Future<http.Response> _authenticatedPut(String path, Map<String, dynamic> body) async {
    final response = await _client.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    ).timeout(timeout);
    
    if (response.statusCode >= 400) {
      throw Exception('Request failed: ${response.body}');
    }
    return response;
  }
  
  Future<http.Response> _authenticatedDelete(String path) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    ).timeout(timeout);
    
    if (response.statusCode >= 400) {
      throw Exception('Request failed: ${response.body}');
    }
    return response;
  }
  
  void dispose() {
    _client.close();
  }
}

// Singleton instance
final apiService = ApiService();
