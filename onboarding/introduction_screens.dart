import 'package:flutter/material.dart';
import 'authentication_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _contentController;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      title: 'Welcome to GabayPH ! -\nYour AI Study Helper!',
      description:
          'Whether you\'re preparing for exams, learn new concepts, or just staying organized. Aide creates a personalized roadmap to success.',
      mockupType: _MockupType.dashboard,
    ),
    _OnboardingData(
      title: 'Explore Diverse Study\nMaterials',
      description:
          'Access a vast library of study sets, flashcards, & practice questions. Discover materials across various subjects.',
      mockupType: _MockupType.flashcard,
    ),
    _OnboardingData(
      title: 'AI-Powered Learning\nAssistant',
      description:
          'Meet StudyBot, your AI learning assistant. Get instant help with tough questions, personalized study tips, and adaptive learning support.',
      mockupType: _MockupType.aiScan,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AuthScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Shared background image (same swirl art) ────────────
          Image.asset(
            'assets/images/bg_opening_screen.jpg',
            fit: BoxFit.cover,
          ),

          // ── Page content ────────────────────────────────────────
          Column(
            children: [
              // Top portion: floating phone mockup
              Expanded(
                flex: 58,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                    _contentController.reset();
                    _contentController.forward();
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _MockupFrame(
                      mockupType: _pages[index].mockupType,
                      screenSize: size,
                    );
                  },
                ),
              ),

              // Bottom gradient section
              _BottomSection(
                currentPage: _currentPage,
                totalPages: _pages.length,
                data: _pages[_currentPage],
                contentController: _contentController,
                onNext: _nextPage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// iPhone-style phone mockup frame
// ─────────────────────────────────────────────
class _MockupFrame extends StatelessWidget {
  final _MockupType mockupType;
  final Size screenSize;

  const _MockupFrame({
    required this.mockupType,
    required this.screenSize,
  });

  // Thickness of the dark outer bezel
  static const double _bezel = 10.0;
  // Outer corner radius (the phone shell)
  static const double _outerRadius = 44.0;
  // Inner screen corner radius
  static const double _innerRadius = 36.0;

  @override
  Widget build(BuildContext context) {
    // Frame is wider than before so it bleeds off the sides a bit,
    // and taller so the bottom is cut off by the gradient — matching Figma
    final frameW = screenSize.width * 0.82;
    final frameH = screenSize.height * 0.56;

    return Center(
      child: SizedBox(
        width: frameW,
        height: frameH,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Dark outer phone shell ──────────────────────────────
            Positioned.fill(
              child: CustomPaint(painter: _IPhoneShellPainter()),
            ),

            // ── Screen (inset by bezel on all sides except bottom) ──
            // Bottom has no inset so content runs to the cut-off edge
            Positioned(
              top: _bezel,
              left: _bezel,
              right: _bezel,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(_innerRadius),
                  topRight: Radius.circular(_innerRadius),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                child: Column(
                  children: [
                    // ── Status bar ────────────────────────────────
                    Container(
                      height: 44,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Time — left
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '9:41',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Dynamic Island pill — center
                          Center(
                            child: Container(
                              width: 90,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          // Icons — right
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.signal_cellular_alt,
                                    size: 13, color: Colors.grey[800]),
                                const SizedBox(width: 4),
                                Icon(Icons.wifi,
                                    size: 13, color: Colors.grey[800]),
                                const SizedBox(width: 4),
                                // Battery icon
                                Container(
                                  width: 22,
                                  height: 11,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[600]!, width: 1),
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Your existing content (unchanged) ─────────
                    Expanded(child: _buildContent(mockupType)),
                  ],
                ),
              ),
            ),

            // ── Left side: volume up button ─────────────────────────
            Positioned(
              left: -4,
              top: frameH * 0.22,
              child: _PhysicalButton(height: 28),
            ),
            // ── Left side: volume down button ───────────────────────
            Positioned(
              left: -4,
              top: frameH * 0.22 + 36,
              child: _PhysicalButton(height: 28),
            ),
            // ── Right side: power button ────────────────────────────
            Positioned(
              right: -4,
              top: frameH * 0.26,
              child: _PhysicalButton(height: 50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(_MockupType type) {
    switch (type) {
      case _MockupType.dashboard:
        return const _DashboardContent();
      case _MockupType.flashcard:
        return const _FlashcardContent();
      case _MockupType.aiScan:
        return const _AiScanContent();
    }
  }
}

// Draws the dark phone shell with a glass-highlight edge
class _IPhoneShellPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const outerR = _MockupFrame._outerRadius;

    // Main dark body
    final bodyPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;

    final bodyRRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: const Radius.circular(outerR),
      topRight: const Radius.circular(outerR),
      bottomLeft: const Radius.circular(10),
      bottomRight: const Radius.circular(10),
    );
    canvas.drawRRect(bodyRRect, bodyPaint);

    // Top glass highlight — subtle white shimmer on the bezel edge
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 0.75),
        topLeft: const Radius.circular(outerR),
        topRight: const Radius.circular(outerR),
        bottomLeft: const Radius.circular(10),
        bottomRight: const Radius.circular(10),
      ),
      highlightPaint,
    );

    // Drop shadow depth line on inner bezel top
    final innerEdgePaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final innerBezelR = outerR - _MockupFrame._bezel;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          _MockupFrame._bezel - 0.5,
          _MockupFrame._bezel - 0.5,
          size.width - (_MockupFrame._bezel * 2) + 1,
          size.height - _MockupFrame._bezel + 1,
        ),
        topLeft: Radius.circular(innerBezelR),
        topRight: Radius.circular(innerBezelR),
        bottomLeft: const Radius.circular(4),
        bottomRight: const Radius.circular(4),
      ),
      innerEdgePaint,
    );
  }

  @override
  bool shouldRepaint(_IPhoneShellPainter old) => false;
}

// Physical side button (volume / power)
class _PhysicalButton extends StatelessWidget {
  final double height;
  const _PhysicalButton({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        // Slightly lighter than the shell so buttons are visible
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mockup content #1 – Dashboard
// ─────────────────────────────────────────────
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                // Profile picture circle
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/avatar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back',
                        style:
                            TextStyle(fontSize: 10, color: Colors.grey[600])),
                    const Text('Colleen Lueilwitz',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: const Icon(Icons.notifications_outlined, size: 16),
                ),
              ],
            ),
          ),

          // Large whitespace gap (as in design)
          const SizedBox(height: 20),

          // "Recent Study sets" row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Study sets',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('View All',
                    style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Study set card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  left: BorderSide(color: Colors.orange[600]!, width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cell Biology',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 3),
                        Text(
                          '45 Flashcards • 12 explanations • 20 exercise',
                          style:
                              TextStyle(fontSize: 9, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('By you',
                                style: TextStyle(
                                    fontSize: 9, color: Colors.grey[500])),
                            const SizedBox(width: 10),
                            Icon(Icons.lock_outline,
                                size: 11, color: Colors.grey[400]),
                            const Spacer(),
                            Icon(Icons.more_vert,
                                size: 14, color: Colors.grey[500]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Circular progress
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.62,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFF8C00)),
                        ),
                        const Text('62%',
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mockup content #2 – Flashcard list
// ─────────────────────────────────────────────
class _FlashcardContent extends StatelessWidget {
  const _FlashcardContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F7F7),
      child: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios, size: 14),
                const Expanded(
                  child: Column(
                    children: [
                      Text('Cell Membranes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('20 Flashcards',
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.filter_list, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Card 1 – yellow/highlighted
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What is the function of aquaporins in the cell membrance ?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Aquaporins are membrane proteins that act as channels for water transport, allowing water to move quickly in and out of cells to maintain fluid balance.',
                    style: TextStyle(fontSize: 9, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Ask Question with AideBot',
                    style: TextStyle(
                        color: Color(0xFFFF8C00),
                        fontSize: 9,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Card 2 – pink/secondary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Opacity(
              opacity: 0.85,
              child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What is the function of aquaporins in the cell membrance ?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Aquaporins are membrane proteins that act as channels for water transport, allowing water to move quickly in and out of cells to maintain fluid balance.',
                      style: TextStyle(fontSize: 9, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mockup content #3 – AI Scan Question
// ─────────────────────────────────────────────
class _AiScanContent extends StatelessWidget {
  const _AiScanContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.close, size: 16),
              const Text('Scan Question',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const Icon(Icons.more_vert, size: 16),
            ],
          ),
          const SizedBox(height: 10),

          // Handwritten equation image / box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Text(
                  'y = c₁e²ˣ + c₂e³ˣ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A6BC9)),
                ),
                SizedBox(height: 2),
                Text(
                  'y = c₁e²ˣ + c₂e⁻²ˣ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF3A6BC9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Text('Identified Question',
              style: TextStyle(fontSize: 10, color: Colors.grey[500])),
          const SizedBox(height: 3),
          const Text('y = C₁ e²ˣ + C₂ e³ˣ',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          const Text('Answer',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          const Text('1. First Solution: y = c₁e²ˣ + c₂e³ˣ',
              style: TextStyle(fontSize: 10)),
          const SizedBox(height: 8),

          const Text('Characteristic Roots',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 3),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 9, color: Colors.grey[700]),
              children: const [
                TextSpan(
                    text:
                        'The general solution has the form y = c₁e^(m₁x) + c₂e^(m₂x), where m₁ and m₂ are '),
                TextSpan(
                    text: 'real and distinct roots',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        ' of the characteristic equation. From the given solution, the roots are:'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom gradient section
// ─────────────────────────────────────────────
class _BottomSection extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final _OnboardingData data;
  final AnimationController contentController;
  final VoidCallback onNext;

  const _BottomSection({
    required this.currentPage,
    required this.totalPages,
    required this.data,
    required this.contentController,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final titleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    final descAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: contentController,
        curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3B5FC0), // blue top
            Color(0xFFD94E1F), // orange-red mid
            Color(0xFFFF9500), // amber bottom
          ],
          stops: [0.0, 0.65, 1.0],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          AnimatedBuilder(
            animation: contentController,
            builder: (_, child) => Opacity(
              opacity: titleAnim.value,
              child: Transform.translate(
                offset: Offset(0, 18 * (1 - titleAnim.value)),
                child: child,
              ),
            ),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Description
          AnimatedBuilder(
            animation: contentController,
            builder: (_, child) => Opacity(
              opacity: descAnim.value,
              child: Transform.translate(
                offset: Offset(0, 18 * (1 - descAnim.value)),
                child: child,
              ),
            ),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (i) {
              final isActive = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      isActive ? Colors.white : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Next / Get Started button
          GestureDetector(
            onTap: onNext,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B5FC0), Color(0xFFFF9500)],
                ),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  currentPage == totalPages - 1 ? 'Get Started' : 'Next',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────
enum _MockupType { dashboard, flashcard, aiScan }

class _OnboardingData {
  final String title;
  final String description;
  final _MockupType mockupType;
  const _OnboardingData({
    required this.title,
    required this.description,
    required this.mockupType,
  });
}
