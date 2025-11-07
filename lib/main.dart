import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  ThemeData get _lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      );

  ThemeData get _darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced UI Techniques',
      theme: _isDark ? _darkTheme : _lightTheme,
      home: HomePage(
        isDark: _isDark,
        onThemeToggle: (v) => setState(() => _isDark = v),
      ),
    );
  }
}

/// 2. Custom Stateless Widget – bold 24, text + color params
class CustomTitle extends StatelessWidget {
  final String text;
  final Color color;
  const CustomTitle(this.text, {super.key, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: color,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// 3. Custom Stateful Widget – counter with + and –
class CustomCounter extends StatefulWidget {
  final int initial;
  const CustomCounter({super.key, this.initial = 0});

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => setState(() => _count--),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('$_count', style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          onPressed: () => setState(() => _count++),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeToggle;
  const HomePage({super.key, required this.isDark, required this.onThemeToggle});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // 5. AnimatedContainer state
  double _boxSize = 100;
  double _boxRadius = 16;
  Color _boxColor = Colors.teal;

  // 6. Explicit animation – Flutter logo moves across screen
  late final AnimationController _controller;
  late final Animation<double> _logoTween;

  // 7. GestureDetector – change background color by gesture
  Color _bgColor = Colors.transparent;

  // 9. AnimatedList
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = [];
  int _nextItem = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoTween = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAnimatedContainerTap() {
    setState(() {
      _boxSize = _boxSize == 100 ? 150 : 100;
      _boxRadius = _boxRadius == 16 ? 48 : 16;
      _boxColor = _boxColor == Colors.teal ? Colors.deepPurple : Colors.teal;
    });
  }

  void _runLogoAnimation() {
    if (_controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.reverse) return;
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _insertItem() {
    final index = _items.length;
    _items.add('Item ${_nextItem++}');
    _listKey.currentState?.insertItem(index, duration: const Duration(milliseconds: 350));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _bgColor = cs.surfaceVariant.withOpacity(0.2)),
      onDoubleTap: () => setState(() => _bgColor = cs.primaryContainer.withOpacity(0.25)),
      onLongPress: () => setState(() => _bgColor = cs.tertiaryContainer.withOpacity(0.25)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: _bgColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Themed Interactive UI'),
            actions: [
              Row(
                children: [
                  const Icon(Icons.light_mode, size: 18),
                  Switch(
                    value: widget.isDark,
                    onChanged: widget.onThemeToggle,
                  ),
                  const Icon(Icons.dark_mode, size: 18),
                  const SizedBox(width: 8),
                ],
              )
            ],
          ),
          body: Center(
            // 4. Combine CustomTitle + CustomCounter in a Column & Center
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomTitle('Advanced UI Design Techniques', color: Colors.blue),
                  const SizedBox(height: 6),
                  CustomTitle('Tap/Double‑tap/Long‑press background', color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 12),
                  const CustomCounter(),
                  const SizedBox(height: 24),

                  // 1. Widgets: Container, Row, Column, Wrap with at least 4 colored boxes
                  _ColoredBoxesShowcase(),
                  const SizedBox(height: 24),

                  // 5. Implicit animation – AnimatedContainer
                  Text('AnimatedContainer (tap me)', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _onAnimatedContainerTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _boxSize,
                      height: _boxSize,
                      decoration: BoxDecoration(
                        color: _boxColor,
                        borderRadius: BorderRadius.circular(_boxRadius),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 6. Explicit Animation – Flutter logo slides horizontally
                  Text('Explicit Animation (press button)', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final maxX = constraints.maxWidth - 100; // 100 = logo size
                      return SizedBox(
                        height: 120,
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: _logoTween,
                              builder: (context, child) {
                                return Positioned(
                                  left: _logoTween.value * (maxX > 0 ? maxX : 0),
                                  top: 10,
                                  child: child!,
                                );
                              },
                              child: const FlutterLogo(size: 100),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _runLogoAnimation,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Run Animation'),
                  ),

                  const SizedBox(height: 24),

                  // 9. AnimatedList
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('AnimatedList', style: Theme.of(context).textTheme.titleMedium),
                      FilledButton.icon(
                        onPressed: _insertItem,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Item'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedList(
                        key: _listKey,
                        initialItemCount: _items.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: Card(
                              child: ListTile(
                                leading: const Icon(Icons.label_important_outline),
                                title: Text(_items[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 10. Mini Project requirement already satisfied by combining components
                  Text(
                    'This home screen combines themes, custom widgets, gestures, animations, and layouts.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
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

class _ColoredBoxesShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Layout Widgets Showcase', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            children: [
              // Row with 2 boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _ColorBox(Colors.red),
                  _ColorBox(Colors.green),
                ],
              ),
              const SizedBox(height: 8),
              // Wrap with 2+ boxes
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _ColorBox(Colors.blue),
                  _ColorBox(Colors.orange),
                  _ColorBox(Colors.purple),
                  _ColorBox(Colors.cyan),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorBox extends StatelessWidget {
  final Color color;
  const _ColorBox(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
