import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/stock_entry_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../application/update_stock_controller.dart';

const _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

class UpdateStockScreen extends ConsumerStatefulWidget {
  const UpdateStockScreen({super.key});

  @override
  ConsumerState<UpdateStockScreen> createState() => _UpdateStockScreenState();
}

class _UpdateStockScreenState extends ConsumerState<UpdateStockScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPartnerId;
  String? _prefilledForPartnerId;

  final Map<String, TextEditingController> _controllers = {
    for (final group in _bloodGroups) group: TextEditingController(),
  };
  Map<String, int> _baseline = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _prefillFrom(Map<String, StockEntryModel> stock) {
    final baseline = <String, int>{};
    for (final group in _bloodGroups) {
      final unitCount = stock[group]?.unitCount ?? 0;
      _controllers[group]!.text = unitCount.toString();
      baseline[group] = unitCount;
    }
    _baseline = baseline;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    final partnerId = _selectedPartnerId;
    if (partnerId == null) return;
    if (!_formKey.currentState!.validate()) return;

    final changedCells = <String, int>{};
    for (final group in _bloodGroups) {
      final text = _controllers[group]!.text.trim();
      final unitCount = int.tryParse(text) ?? 0;
      if (unitCount != _baseline[group]) {
        changedCells[group] = unitCount;
      }
    }

    if (changedCells.isEmpty) {
      _showMessage('No changes to save');
      return;
    }

    final success = await ref
        .read(updateStockControllerProvider.notifier)
        .save(partnerId: partnerId, changedCells: changedCells);

    if (!mounted || !success) return;
    ref.invalidate(partnerStockProvider(partnerId));
    setState(() => _baseline = {..._baseline, ...changedCells});
    _showMessage('Stock updated');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final partnersAsync = ref.watch(stockPartnerListProvider);
    final saveState = ref.watch(updateStockControllerProvider);

    ref.listen(updateStockControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        _showMessage(error.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Update stock')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Partner', style: textTheme.labelSmall),
              const SizedBox(height: 6),
              partnersAsync.when(
                data: (partners) => DropdownButtonFormField<String>(
                  initialValue: _selectedPartnerId,
                  hint: const Text('Select a partner'),
                  items: partners
                      .map(
                        (record) => DropdownMenuItem(
                          value: record.id,
                          child: Text(record.partner.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedPartnerId = value),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Failed to load partners: $error'),
              ),
              if (_selectedPartnerId != null) ...[
                const SizedBox(height: 24),
                _buildStockGrid(_selectedPartnerId!, textTheme),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Save stock update',
                  isLoading: saveState.isLoading,
                  onPressed: _save,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockGrid(String partnerId, TextTheme textTheme) {
    final stockAsync = ref.watch(partnerStockProvider(partnerId));

    return stockAsync.when(
      data: (stock) {
        if (_prefilledForPartnerId != partnerId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _prefilledForPartnerId == partnerId) return;
            setState(() {
              _prefillFrom(stock);
              _prefilledForPartnerId = partnerId;
            });
          });
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.4,
            children: [
              for (final group in _bloodGroups)
                AppInput(
                  label: group,
                  controller: _controllers[group]!,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid unit count';
                    }
                    return null;
                  },
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Failed to load stock: $error'),
    );
  }
}
