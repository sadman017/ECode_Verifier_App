import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

// ---------------------------------------------------------------------------
// Open Food Facts UI Helper Widgets
// ---------------------------------------------------------------------------
// This file provides reusable widgets for displaying enriched product data
// fetched via the official openfoodfacts Dart package.
// ---------------------------------------------------------------------------

/// Color mapping for Nutri-Score / Eco-Score letter grades.
Color scoreColor(String? grade) {
  switch (grade?.toUpperCase()) {
    case 'A':
      return const Color(0xFF038141); // dark green
    case 'B':
      return const Color(0xFF85BB2F); // light green
    case 'C':
      return const Color(0xFFFECC00); // yellow
    case 'D':
      return const Color(0xFFEE8100); // orange
    case 'E':
      return const Color(0xFFe63e11); // red
    default:
      return Colors.grey;
  }
}

/// Displays a colored badge for Nutri-Score (A-E).
class NutriScoreBadge extends StatelessWidget {
  final String? score;
  const NutriScoreBadge({super.key, this.score});

  @override
  Widget build(BuildContext context) {
    final display = (score ?? 'N/A').toUpperCase();
    return _ScoreBadge(
      label: 'Nutri-Score',
      value: display,
      color: scoreColor(score),
      icon: Icons.restaurant_menu,
    );
  }
}

/// Displays a colored badge for Eco-Score (A-E).
class EcoScoreBadge extends StatelessWidget {
  final String? grade;
  const EcoScoreBadge({super.key, this.grade});

  @override
  Widget build(BuildContext context) {
    final display = (grade ?? 'N/A').toUpperCase();
    return _ScoreBadge(
      label: 'Eco-Score',
      value: display,
      color: scoreColor(grade),
      icon: Icons.eco,
    );
  }
}

/// Displays a colored badge for JAKIM Halal status.
class HalalStatusBadge extends StatelessWidget {
  final String? status;
  final String? company;
  const HalalStatusBadge({super.key, this.status, this.company});

  @override
  Widget build(BuildContext context) {
    final bool isCertified =
        status?.toLowerCase().contains('halal') ?? false;
    final bool isError = status != null && !isCertified;

    final Color color = isCertified
        ? const Color(0xFF038141)
        : isError
            ? Colors.red
            : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCertified ? Icons.verified : Icons.warning_amber,
            color: color,
            size: 20,
          ),
          const Gap(6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'JAKIM Halal',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.9),
                  ),
                ),
                Text(
                  status ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                if (company != null && company!.isNotEmpty)
                  Text(
                    company!,
                    style: TextStyle(
                      fontSize: 10,
                      color: color.withOpacity(0.8),
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable score badge widget.
class _ScoreBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _ScoreBadge({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const Gap(6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.9),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Displays diet-status chips: Vegan, Vegetarian, Non-Vegan, Palm Oil Free.
class DietStatusChips extends StatelessWidget {
  final List<String>? analysisTags;
  const DietStatusChips({super.key, this.analysisTags});

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    if (analysisTags == null || analysisTags!.isEmpty) {
      return const Text(
        'Diet status unknown',
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      );
    }

    final tagsLower = analysisTags!.map((t) => t.toLowerCase()).toList();

    // Vegan status
    if (tagsLower.any((t) => t.contains('non-vegan'))) {
      chips.add(_buildChip('Non-Vegan', Icons.cancel, Colors.red));
    } else if (tagsLower.any((t) => t.contains('vegan'))) {
      chips.add(_buildChip('Vegan', Icons.check_circle, Colors.green));
    }

    // Vegetarian status
    if (tagsLower.any((t) => t.contains('non-vegetarian'))) {
      chips.add(_buildChip('Non-Vegetarian', Icons.cancel, Colors.red));
    } else if (tagsLower.any((t) => t.contains('vegetarian'))) {
      chips.add(_buildChip('Vegetarian', Icons.check_circle, Colors.lightGreen));
    }

    // Palm oil
    if (tagsLower.any((t) => t.contains('palm-oil-free'))) {
      chips.add(_buildChip('Palm Oil Free', Icons.forest, Colors.teal));
    } else if (tagsLower.any((t) => t.contains('palm-oil'))) {
      chips.add(_buildChip('Contains Palm Oil', Icons.warning, Colors.orange));
    }

    if (chips.isEmpty) {
      return const Text(
        'Diet status unknown',
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _buildChip(String label, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(
        label,
        style: TextStyle(
          color: color.withOpacity(0.9),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

/// Displays a list of allergens with a warning icon.
class AllergenList extends StatelessWidget {
  final String? allergens;
  const AllergenList({super.key, this.allergens});

  @override
  Widget build(BuildContext context) {
    if (allergens == null || allergens!.trim().isEmpty) {
      return const ListTile(
        leading: Icon(Icons.health_and_safety, color: Colors.green),
        title: Text(
          'Allergens',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('No known allergens'),
      );
    }

    // OFF often returns allergens as comma-separated tags like "en:milk, en:gluten"
    final cleaned = allergens!
        .replaceAll(RegExp(r'en:'), '')
        .replaceAll(RegExp(r'_'), ' ')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return ListTile(
      leading: const Icon(Icons.warning_amber, color: Colors.orange),
      title: const Text(
        'Allergens',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        cleaned.join(', '),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

/// Formats a nutrient value for display.
String? _formatNutrient(double? value) {
  if (value == null) return null;
  return value.toStringAsFixed(1);
}

/// Main product result card combining all data sections.
class ProductResultCard extends StatelessWidget {
  final String? productName;
  final String? brands;
  final String? quantity;
  final String? imageUrl;
  final String? ingredientsText;
  final Nutriments? nutriments;
  final String? allergens;
  final String? nutriScore;
  final String? ecoScoreGrade;
  final int? ecoScoreValue;
  final List<String>? ingredientsAnalysisTags;
  final String? halalStatus;
  final String? halalCompany;

  const ProductResultCard({
    super.key,
    this.productName,
    this.brands,
    this.quantity,
    this.imageUrl,
    this.ingredientsText,
    this.nutriments,
    this.allergens,
    this.nutriScore,
    this.ecoScoreGrade,
    this.ecoScoreValue,
    this.ingredientsAnalysisTags,
    this.halalStatus,
    this.halalCompany,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            if (imageUrl != null && imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey.shade100,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            if (imageUrl != null && imageUrl!.isNotEmpty) const Gap(12),

            // Product name
            Text(
              productName ?? 'Unknown Product',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(4),

            // Brand & quantity
            if (brands != null && brands!.isNotEmpty)
              Text(
                brands!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (quantity != null && quantity!.isNotEmpty)
              Text(
                quantity!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            const Gap(16),

            // Score badges row
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                NutriScoreBadge(score: nutriScore),
                EcoScoreBadge(grade: ecoScoreGrade),
                HalalStatusBadge(status: halalStatus, company: halalCompany),
              ],
            ),
            const Gap(20),

            // Diet status
            const Text(
              'Diet & Sustainability',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            const Gap(8),
            DietStatusChips(analysisTags: ingredientsAnalysisTags),
            const Gap(20),

            // Allergens
            AllergenList(allergens: allergens),
            const Gap(20),

            // Ingredients
            if (ingredientsText != null && ingredientsText!.isNotEmpty) ...[
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
              ),
              const Gap(8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  ingredientsText!,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
              const Gap(20),
            ],

            // Nutrition facts
            if (nutriments != null) ...[
              const Text(
                'Nutrition Facts (per 100g)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
              ),
              const Gap(8),
              _NutritionTable(nutriments: nutriments!),
              const Gap(12),
            ],

            // Eco-score numeric
            if (ecoScoreValue != null)
              ListTile(
                leading: const Icon(Icons.leaderboard, color: Colors.blue),
                title: const Text(
                  'Environment Score',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('$ecoScoreValue / 100'),
              ),
          ],
        ),
      ),
    );
  }
}

class _NutritionTable extends StatelessWidget {
  final Nutriments nutriments;
  const _NutritionTable({required this.nutriments});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    void addRow(String label, double? value, String unit) {
      if (value == null) return;
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              Text(
                '${_formatNutrient(value)} $unit',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
      rows.add(Divider(height: 1, color: Colors.grey.shade200));
    }

    addRow('Energy', nutriments.getValue(Nutrient.energyKJ, PerSize.oneHundredGrams), 'kJ');
    addRow('Fat', nutriments.getValue(Nutrient.fat, PerSize.oneHundredGrams), 'g');
    addRow('Saturated Fat', nutriments.getValue(Nutrient.saturatedFat, PerSize.oneHundredGrams), 'g');
    addRow('Carbohydrates', nutriments.getValue(Nutrient.carbohydrates, PerSize.oneHundredGrams), 'g');
    addRow('Sugars', nutriments.getValue(Nutrient.sugars, PerSize.oneHundredGrams), 'g');
    addRow('Protein', nutriments.getValue(Nutrient.proteins, PerSize.oneHundredGrams), 'g');
    addRow('Salt', nutriments.getValue(Nutrient.salt, PerSize.oneHundredGrams), 'g');
    addRow('Fiber', nutriments.getValue(Nutrient.fiber, PerSize.oneHundredGrams), 'g');

    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: rows),
    );
  }
}
