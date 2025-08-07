import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_context_service.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

/// Screen for inputting comprehensive project context for AI
class AIContextScreen extends ConsumerStatefulWidget {
  const AIContextScreen({super.key});

  @override
  ConsumerState<AIContextScreen> createState() => _AIContextScreenState();
}

class _AIContextScreenState extends ConsumerState<AIContextScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;

  // Controllers for text fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _businessContextController = TextEditingController();
  final _targetAudienceController = TextEditingController();
  final _architectureController = TextEditingController();
  final _dataFlowController = TextEditingController();
  final _frontendController = TextEditingController(text: 'Flutter');
  final _backendController = TextEditingController();
  final _databaseController = TextEditingController();

  // Lists for dynamic fields
  final List<String> _components = [];
  final List<String> _services = [];
  final List<String> _functionalReqs = [];
  final List<String> _nonFunctionalReqs = [];
  final List<ImplementationStep> _implementationSteps = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _businessContextController.dispose();
    _targetAudienceController.dispose();
    _architectureController.dispose();
    _dataFlowController.dispose();
    _frontendController.dispose();
    _backendController.dispose();
    _databaseController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('AI Project Context', style: AppTypography.buttonLarge),
        actions: [
          TextButton.icon(
            onPressed: _importTemplate,
            icon: const Icon(Icons.file_download, color: AppColors.primary),
            label: const Text(
              'Import Template',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    for (int i = 0; i < _steps.length; i++) ...[
                      _buildStepIndicator(i),
                      if (i < _steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: i < _currentStep
                                ? AppColors.primary
                                : AppColors.borderLight,
                          ),
                        ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _steps[_currentStep]['title']!,
                  style: AppTypography.buttonMedium,
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  _buildBasicInfoStep(),
                  _buildSystemDesignStep(),
                  _buildTechStackStep(),
                  _buildRequirementsStep(),
                  _buildImplementationStep(),
                  _buildReviewStep(),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  OutlinedButton.icon(
                    onPressed: _previousStep,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                const Spacer(),
                if (_currentStep < _steps.length - 1)
                  ElevatedButton.icon(
                    onPressed: _nextStep,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _generateProject,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generate Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index) {
    final isActive = index == _currentStep;
    final isCompleted = index < _currentStep;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : isCompleted
            ? AppColors.success
            : AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive || isCompleted
              ? Colors.transparent
              : AppColors.borderLight,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Project Information'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _titleController,
            label: 'Project Title',
            hint: 'e.g., E-Commerce Mobile App',
            icon: Icons.title,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Title is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Project Description',
            hint: 'Brief description of what the app does',
            icon: Icons.description,
            maxLines: 3,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Description is required' : null,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Business Context'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _businessContextController,
            label: 'Business Context & Goals',
            hint: 'What business problem does this solve? What are the goals?',
            icon: Icons.business,
            maxLines: 4,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Business context is required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _targetAudienceController,
            label: 'Target Audience',
            hint: 'Who will use this application?',
            icon: Icons.people,
            maxLines: 2,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Target audience is required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSystemDesignStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Architecture Pattern'),
          const SizedBox(height: 16),
          _buildDropdown(
            value: _architectureController.text.isEmpty
                ? null
                : _architectureController.text,
            label: 'Select Architecture',
            items: [
              'Clean Architecture',
              'MVC',
              'MVP',
              'MVVM',
              'BLoC Pattern',
              'Provider Pattern',
              'Riverpod Architecture',
              'Layered Architecture',
            ],
            onChanged: (value) {
              setState(() {
                _architectureController.text = value ?? '';
              });
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('System Components'),
          const SizedBox(height: 16),
          _buildDynamicList(
            items: _components,
            label: 'Add Component',
            hint: 'e.g., Authentication Service, Payment Gateway',
            icon: Icons.widgets,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Data Flow'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _dataFlowController,
            label: 'Data Flow Description',
            hint: 'Describe how data flows through the system',
            icon: Icons.swap_horiz,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildTechStackStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Technology Stack'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _frontendController,
            label: 'Frontend Framework',
            hint: 'e.g., Flutter, React Native',
            icon: Icons.phone_android,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _backendController,
            label: 'Backend Technology',
            hint: 'e.g., Node.js, Firebase, Django',
            icon: Icons.cloud,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _databaseController,
            label: 'Database',
            hint: 'e.g., PostgreSQL, MongoDB, Firebase Firestore',
            icon: Icons.storage,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Third-party Services'),
          const SizedBox(height: 16),
          _buildDynamicList(
            items: _services,
            label: 'Add Service',
            hint: 'e.g., Stripe, SendGrid, AWS S3',
            icon: Icons.api,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Functional Requirements'),
          const SizedBox(height: 8),
          Text(
            'What features must the application have?',
            style: AppTypography.buttonSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDynamicList(
            items: _functionalReqs,
            label: 'Add Requirement',
            hint: 'e.g., User authentication, Product search',
            icon: Icons.check_circle,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Non-Functional Requirements'),
          const SizedBox(height: 8),
          Text(
            'Performance, security, and quality requirements',
            style: AppTypography.buttonSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDynamicList(
            items: _nonFunctionalReqs,
            label: 'Add Requirement',
            hint: 'e.g., Load time < 2s, 99.9% uptime',
            icon: Icons.speed,
          ),
        ],
      ),
    );
  }

  Widget _buildImplementationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Implementation Plan'),
          const SizedBox(height: 8),
          Text(
            'Define step-by-step implementation phases',
            style: AppTypography.buttonSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _addImplementationStep,
            icon: const Icon(Icons.add),
            label: const Text('Add Implementation Step'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
          const SizedBox(height: 16),
          ..._implementationSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return _buildImplementationStepCard(index, step);
          }),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Review Project Context'),
          const SizedBox(height: 24),
          _buildReviewCard('Basic Information', [
            'Title: ${_titleController.text}',
            'Description: ${_descriptionController.text}',
            'Target Audience: ${_targetAudienceController.text}',
          ]),
          const SizedBox(height: 16),
          _buildReviewCard('System Design', [
            'Architecture: ${_architectureController.text}',
            'Components: ${_components.join(', ')}',
            'Data Flow: ${_dataFlowController.text}',
          ]),
          const SizedBox(height: 16),
          _buildReviewCard('Tech Stack', [
            'Frontend: ${_frontendController.text}',
            'Backend: ${_backendController.text}',
            'Database: ${_databaseController.text}',
            'Services: ${_services.join(', ')}',
          ]),
          const SizedBox(height: 16),
          _buildReviewCard('Requirements', [
            'Functional: ${_functionalReqs.length} requirements',
            'Non-Functional: ${_nonFunctionalReqs.length} requirements',
          ]),
          const SizedBox(height: 16),
          _buildReviewCard('Implementation', [
            'Steps: ${_implementationSteps.length} phases defined',
            'Estimated Time: ${_calculateTotalTime()} hours',
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.buttonMedium.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }

  Widget _buildDropdown({
    String? value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDynamicList({
    required List<String> items,
    required String label,
    String? hint,
    IconData? icon,
  }) {
    final controller = TextEditingController();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  prefixIcon: icon != null
                      ? Icon(icon, color: AppColors.primary)
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    items.add(controller.text);
                    controller.clear();
                  });
                }
              },
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      items.remove(item);
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.error,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildImplementationStepCard(int index, ImplementationStep step) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.description,
                    style: AppTypography.buttonSmall,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _implementationSteps.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete, color: AppColors.error),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Tasks:',
              style: AppTypography.buttonSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            ...step.tasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(left: 44, bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
                    Text(
                      task,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 44, top: 8),
              child: Text(
                'Estimated: ${step.estimatedHours} hours',
                style: AppTypography.buttonSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String title, List<String> items) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.codeSmall.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.arrow_right,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addImplementationStep() {
    showDialog(
      context: context,
      builder: (context) {
        final descController = TextEditingController();
        final hoursController = TextEditingController();
        final tasks = <String>[];

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: const Text('Add Implementation Step'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Step Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Estimated Hours',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Tasks:'),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final taskController = TextEditingController();
                                return AlertDialog(
                                  title: const Text('Add Task'),
                                  content: TextField(
                                    controller: taskController,
                                    decoration: const InputDecoration(
                                      labelText: 'Task Description',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setDialogState(() {
                                          tasks.add(taskController.text);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    ...tasks.map(
                      (task) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.check, size: 16),
                        title: Text(task),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () {
                            setDialogState(() {
                              tasks.remove(task);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _implementationSteps.add(
                        ImplementationStep(
                          order: _implementationSteps.length + 1,
                          description: descController.text,
                          tasks: tasks,
                          estimatedHours:
                              int.tryParse(hoursController.text) ?? 0,
                        ),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add Step'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int _calculateTotalTime() {
    return _implementationSteps.fold(
      0,
      (sum, step) => sum + step.estimatedHours,
    );
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _importTemplate() {
    // Show template selection dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Select Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _templateOption('E-Commerce App', _loadEcommerceTemplate),
            _templateOption('Social Media App', _loadSocialTemplate),
            _templateOption('Educational Platform', _loadEducationalTemplate),
            _templateOption('Healthcare App', _loadHealthcareTemplate),
          ],
        ),
      ),
    );
  }

  Widget _templateOption(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _loadEcommerceTemplate() {
    setState(() {
      _titleController.text = 'E-Commerce Mobile Application';
      _descriptionController.text =
          'A comprehensive e-commerce platform for buying and selling products';
      _businessContextController.text =
          'Enable businesses to sell products online with seamless user experience';
      _targetAudienceController.text = 'Online shoppers aged 18-65';
      _architectureController.text = 'Clean Architecture';
      _components.clear();
      _components.addAll([
        'Authentication Service',
        'Product Catalog',
        'Shopping Cart',
        'Payment Gateway',
        'Order Management',
      ]);
      _services.clear();
      _services.addAll(['Stripe', 'Firebase Auth', 'SendGrid']);
    });
  }

  void _loadSocialTemplate() {
    // Load social media template
  }

  void _loadEducationalTemplate() {
    // Load educational platform template
  }

  void _loadHealthcareTemplate() {
    // Load healthcare app template
  }

  Future<void> _generateProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: AppColors.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16),
            Text('Generating your project...'),
          ],
        ),
      ),
    );

    try {
      // Create project context
      final context = await AIContextService.createProjectContext(
        projectTitle: _titleController.text,
        projectDescription: _descriptionController.text,
        businessContext: _businessContextController.text,
        targetAudience: _targetAudienceController.text,
        systemDesign: SystemDesign(
          architecture: _architectureController.text,
          components: _components,
          dataFlow: _dataFlowController.text,
        ),
        techStack: TechStack(
          frontend: _frontendController.text,
          backend: _backendController.text,
          database: _databaseController.text,
          services: _services,
        ),
        requirements: RequirementsDocument(
          functional: _functionalReqs,
          nonFunctional: _nonFunctionalReqs,
        ),
        implementationPlan: ImplementationPlan(
          steps: _implementationSteps,
          estimatedDays: _calculateTotalTime() ~/ 8,
        ),
      );

      // Generate project
      final generatedProject =
          await AIContextService.generateProjectFromContext(context);

      // Navigate back with generated project
      if (mounted) {
        Navigator.pop(this.context); // Close loading dialog
        Navigator.pop(this.context, generatedProject); // Return to editor
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating project: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  final List<Map<String, String>> _steps = [
    {'title': 'Basic Information', 'icon': 'info'},
    {'title': 'System Design', 'icon': 'architecture'},
    {'title': 'Tech Stack', 'icon': 'stack'},
    {'title': 'Requirements', 'icon': 'checklist'},
    {'title': 'Implementation Plan', 'icon': 'timeline'},
    {'title': 'Review & Generate', 'icon': 'preview'},
  ];
}
