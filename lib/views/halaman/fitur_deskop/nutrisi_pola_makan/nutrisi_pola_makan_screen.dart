import 'package:flutter/material.dart';

/// ====== WARNA UTAMA (samakan dengan tema app kamu) ======
const Color kBackgroundColor = Color.fromARGB(255, 201, 231, 226);
const Color kPrimaryGreen = Color(0xFF16A34A);
const Color kPrimaryGreenLight = Color(0xFF22C55E);
const Color kPrimaryBlue = Color(0xFF2563EB);
const Color kTextDark = Color(0xFF1F2937);
const Color kTextGrey = Color(0xFF6B7280);

/// ====== MODEL DATA SEDERHANA ======
class MealEntry {
  final String name;
  final int calories;
  final TimeOfDay time;
  final List<String> tags;

  MealEntry({
    required this.name,
    required this.calories,
    required this.time,
    required this.tags,
  });
}

class Recipe {
  final String title;
  final int calories;
  final int durationMinutes;
  final String imageAsset; // <-- pakai asset lokal
  final NutritionInfo nutrition;
  final List<Ingredient> ingredients;

  Recipe({
    required this.title,
    required this.calories,
    required this.durationMinutes,
    required this.imageAsset,
    required this.nutrition,
    required this.ingredients,
  });
}

class NutritionInfo {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });
}

class Ingredient {
  final String name;
  final String amount;

  Ingredient({required this.name, required this.amount});
}

/// ====== SCREEN UTAMA: NUTRISI & POLA MAKAN ======
class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  // Goal kalori harian
  final int _dailyGoal = 2000;

  // Data meal hari ini
  final List<MealEntry> _meals = [
    MealEntry(
      name: 'Breakfast',
      calories: 420,
      time: const TimeOfDay(hour: 8, minute: 0),
      tags: ['Oatmeal with berries', 'Green tea', 'Banana'],
    ),
    MealEntry(
      name: 'Lunch',
      calories: 650,
      time: const TimeOfDay(hour: 12, minute: 30),
      tags: ['Grilled chicken salad', 'Brown rice', 'Mixed vegetables'],
    ),
    MealEntry(
      name: 'Snack',
      calories: 180,
      time: const TimeOfDay(hour: 15, minute: 0),
      tags: ['Apple', 'Almonds'],
    ),
  ];

  // Data resep contoh (PAKAI ASSET)
  // GANTI path di bawah sesuai aset kamu & pastikan sudah di-declare di pubspec.yaml
  late final List<Recipe> _recipes = [
    Recipe(
      title: 'Healthy Buddha Bowl',
      calories: 450,
      durationMinutes: 25,
      imageAsset: 'assets/images/buddhabowl.jpg',
      nutrition: NutritionInfo(
        calories: 450,
        protein: 18,
        carbs: 65,
        fat: 12,
        fiber: 15,
      ),
      ingredients: [
        Ingredient(name: 'Quinoa', amount: '1 cup'),
        Ingredient(name: 'Chickpeas', amount: '1/2 cup'),
        Ingredient(name: 'Sweet potato', amount: '1 medium'),
        Ingredient(name: 'Broccoli', amount: '1 cup'),
        Ingredient(name: 'Red cabbage', amount: '1/2 cup'),
        Ingredient(name: 'Avocado', amount: '1/2 piece'),
        Ingredient(name: 'Tahini dressing', amount: '2 tbsp'),
      ],
    ),
    Recipe(
      title: 'Quinoa Salad',
      calories: 380,
      durationMinutes: 15,
      imageAsset: 'assets/images/quinoasalad.jpg',
      nutrition: NutritionInfo(
        calories: 380,
        protein: 14,
        carbs: 60,
        fat: 10,
        fiber: 12,
      ),
      ingredients: [
        Ingredient(name: 'Quinoa', amount: '1 cup'),
        Ingredient(name: 'Cucumber', amount: '1/2 cup'),
        Ingredient(name: 'Tomato', amount: '1/2 cup'),
        Ingredient(name: 'Olive oil', amount: '1 tbsp'),
      ],
    ),
    Recipe(
      title: 'Salmon Teriyaki Bowl',
      calories: 520,
      durationMinutes: 30,
      imageAsset: 'assets/images/salmonteriyaki.jpg',
      nutrition: NutritionInfo(
        calories: 520,
        protein: 30,
        carbs: 55,
        fat: 18,
        fiber: 8,
      ),
      ingredients: [
        Ingredient(name: 'Salmon', amount: '120 g'),
        Ingredient(name: 'Brown rice', amount: '1 cup'),
        Ingredient(name: 'Broccoli', amount: '1 cup'),
      ],
    ),
  ];

  // Hitung total kalori yang sudah dimakan
  int get _totalCalories {
    int sum = 0;
    for (final m in _meals) {
      sum += m.calories;
    }
    return sum;
  }

  double get _progress {
    if (_dailyGoal == 0) return 0;
    final value = _totalCalories / _dailyGoal;
    if (value < 0) return 0;
    if (value > 1) return 1;
    return value;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }

  Future<void> _showAddMealDialog() async {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final tagsController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Meal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Meal (mis. Dinner)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: caloriesController,
                  decoration: const InputDecoration(labelText: 'Kalori (kcal)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Detail (pisah dengan koma)',
                    hintText: 'Nasi, Ayam panggang, Sayur',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(selectedTime),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          selectedTime = picked;
                          (context as Element).markNeedsBuild();
                        }
                      },
                      child: const Text('Pilih Waktu'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    caloriesController.text.trim().isEmpty) {
                  return;
                }
                Navigator.pop(context, true);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final name = nameController.text.trim();
      final calories = int.tryParse(caloriesController.text.trim()) ?? 0;
      final tags = tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      setState(() {
        _meals.add(
          MealEntry(
            name: name,
            calories: calories,
            time: selectedTime,
            tags: tags,
          ),
        );
      });
    }
  }

  // dipanggil dari RecipeDetailScreen
  void _addRecipeToMeals(Recipe recipe) {
    final now = TimeOfDay.now();
    final tags = recipe.ingredients.map((e) => e.name).toList();

    setState(() {
      _meals.add(
        MealEntry(
          name: recipe.title,
          calories: recipe.calories,
          time: now,
          tags: tags,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${recipe.title} ditambahkan ke Today\'s Meals.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_back, size: 20, color: kTextDark),
                    SizedBox(width: 4),
                    Text(
                      'Back to Dashboard',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Nutrisi & Pola Makan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track your daily nutrition',
                style: TextStyle(fontSize: 14, color: kTextGrey),
              ),
              const SizedBox(height: 20),

              /// ====== CARD KALORI ======
              _CaloriesSummaryCard(
                totalCalories: _totalCalories,
                goalCalories: _dailyGoal,
                progress: _progress,
              ),
              const SizedBox(height: 16),

              /// ====== Shortcut Water & Add Meal ======
              Row(
                children: [
                  Expanded(
                    child: _ShortcutCard(
                      title: 'Water Intake',
                      subtitle: 'Track water',
                      icon: Icons.water_drop_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WaterIntakeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ShortcutCard(
                      title: 'Add Meal',
                      subtitle: 'Log food',
                      icon: Icons.add,
                      onTap: _showAddMealDialog,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// ====== Today's Meals header (tanpa tombol hijau besar) ======
              const Text(
                "Today's Meals",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 12),

              /// ====== Daftar Meal (bisa dihapus) ======
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _meals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final meal = _meals[index];
                  return _MealCard(
                    meal: meal,
                    timeLabel: _formatTime(meal.time),
                    onDelete: () {
                      setState(() {
                        _meals.removeAt(index);
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Healthy Recipes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 12),

              /// ====== Daftar Resep ======
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recipes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return _RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(
                            recipe: recipe,
                            onAddToMeals: _addRecipeToMeals,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ====== WIDGET KALORI SUMMARY ======
class _CaloriesSummaryCard extends StatelessWidget {
  final int totalCalories;
  final int goalCalories;
  final double progress;

  const _CaloriesSummaryCard({
    required this.totalCalories,
    required this.goalCalories,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Calories",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            'Goal: $goalCalories cal',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalCalories.toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/ $goalCalories cal',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const Spacer(),
              const Icon(Icons.apple, color: Colors.white, size: 32),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// ====== SHORTCUT CARD ======
class _ShortcutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ShortcutCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: kPrimaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: kTextGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ====== MEAL CARD (dengan tombol hapus) ======
class _MealCard extends StatelessWidget {
  final MealEntry meal;
  final String timeLabel;
  final VoidCallback? onDelete;

  const _MealCard({required this.meal, required this.timeLabel, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F5EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restaurant, color: kPrimaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: kTextDark,
                        ),
                      ),
                      Text(
                        '${meal.calories} calories',
                        style: const TextStyle(fontSize: 12, color: kTextGrey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeLabel,
                      style: const TextStyle(fontSize: 12, color: kTextGrey),
                    ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        onPressed: onDelete,
                        tooltip: 'Hapus meal ini',
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: meal.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F0FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: kPrimaryBlue,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====== RECIPE CARD (pakai Image.asset) ======
class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _RecipeCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(recipe.imageAsset, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${recipe.calories} cal',
                        style: const TextStyle(fontSize: 12, color: kTextGrey),
                      ),
                      const SizedBox(width: 12),
                      const Text('•', style: TextStyle(color: kTextGrey)),
                      const SizedBox(width: 12),
                      Text(
                        '${recipe.durationMinutes} min',
                        style: const TextStyle(fontSize: 12, color: kTextGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ====== WATER INTAKE SCREEN (indikator sudah bener) ======
class WaterIntakeScreen extends StatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  State<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends State<WaterIntakeScreen> {
  final double _goalLiters = 2.0;
  double _currentLiters = 1.0;
  double _glassSizeMl = 250;
  final List<double> _logs = [250, 500, 250, 300];

  double get _remaining =>
      (_goalLiters - _currentLiters).clamp(0.0, _goalLiters);
  double get _progress => (_currentLiters / _goalLiters).clamp(0.0, 1.0);

  void _addGlass() {
    setState(() {
      _currentLiters += _glassSizeMl / 1000;
      _logs.add(_glassSizeMl);
    });
  }

  void _removeLog(int index) {
    setState(() {
      final removed = _logs.removeAt(index);
      _currentLiters = (_currentLiters - removed / 1000).clamp(0.0, 100.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_back, size: 20, color: kTextDark),
                    SizedBox(width: 4),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Water Intake',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Stay hydrated, stay healthy',
                style: TextStyle(fontSize: 14, color: kTextGrey),
              ),
              const SizedBox(height: 16),

              // Card progress air
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [kPrimaryBlue, Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Water Intake',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Goal hydration for today',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 160,
                              child: CircularProgressIndicator(
                                value: _progress,
                                strokeWidth: 10,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_currentLiters.toStringAsFixed(2)}L',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'of ${_goalLiters.toStringAsFixed(1)}L',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Glasses',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              _logs.length.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Remaining',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '${_remaining.toStringAsFixed(1)}L',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Glass size
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Glass Size',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kTextDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _glassSizeMl = (_glassSizeMl - 50).clamp(
                                  100,
                                  500,
                                );
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _glassSizeMl.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryBlue,
                                  ),
                                ),
                                const Text(
                                  'ml per glass',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kTextGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _glassSizeMl = (_glassSizeMl + 50).clamp(
                                  100,
                                  500,
                                );
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addGlass,
                  icon: const Icon(Icons.water_drop_outlined),
                  label: Text('Add ${_glassSizeMl.toStringAsFixed(0)}ml Water'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Today's Log",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 8),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final ml = _logs[index];
                  return Material(
                    color: const Color(0xFFE5F0FF),
                    borderRadius: BorderRadius.circular(14),
                    child: ListTile(
                      leading: const Icon(
                        Icons.water_drop,
                        color: kPrimaryBlue,
                      ),
                      title: Text('${ml.toStringAsFixed(0)} ml'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _removeLog(index),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Tips
              Material(
                color: const Color(0xFFE6F4FF),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.water_drop,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Hydration Tips',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: kTextDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        ' Drink a glass of water when you wake up',
                        style: TextStyle(fontSize: 13, height: 1.3),
                      ),
                      const Text(
                        ' Keep water nearby throughout the day',
                        style: TextStyle(fontSize: 13, height: 1.3),
                      ),
                      const Text(
                        ' Drink before you feel thirsty',
                        style: TextStyle(fontSize: 13, height: 1.3),
                      ),
                      const Text(
                        ' Add lemon or fruit for flavor',
                        style: TextStyle(fontSize: 13, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ====== RECIPE DETAIL SCREEN ======
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final ValueChanged<Recipe> onAddToMeals;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.onAddToMeals,
  });

  @override
  Widget build(BuildContext context) {
    final n = recipe.nutrition;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gambar + title
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(recipe.imageAsset, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _ChipOverlay(
                              icon: Icons.local_fire_department_outlined,
                              label: '${recipe.calories} cal',
                            ),
                            const SizedBox(width: 8),
                            _ChipOverlay(
                              icon: Icons.timer_outlined,
                              label: '${recipe.durationMinutes} min',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Card Total Nutrition
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kPrimaryGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Nutrition',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _NutritionBox(
                            title: 'Calories',
                            value: '${n.calories}g',
                            subtitle: 'kcal',
                          ),
                          _NutritionBox(
                            title: 'Protein',
                            value: '${n.protein}g',
                            subtitle: '16% of calories',
                          ),
                          _NutritionBox(
                            title: 'Carbs',
                            value: '${n.carbs}g',
                            subtitle: '58% of calories',
                          ),
                          _NutritionBox(
                            title: 'Fat',
                            value: '${n.fat}g',
                            subtitle: '24% of calories',
                          ),
                          _NutritionBox(
                            title: 'Fiber',
                            value: '${n.fiber}g',
                            subtitle: 'per serving',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Ingredients + button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.ingredients.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Color(0xFFE5E7EB)),
                        itemBuilder: (context, index) {
                          final ing = recipe.ingredients[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.circle,
                              size: 10,
                              color: kPrimaryGreen,
                            ),
                            title: Text(
                              ing.name,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Text(
                              ing.amount,
                              style: const TextStyle(
                                fontSize: 13,
                                color: kTextGrey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          onAddToMeals(recipe);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add to Today's Meal"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipOverlay extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ChipOverlay({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _NutritionBox extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _NutritionBox({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
