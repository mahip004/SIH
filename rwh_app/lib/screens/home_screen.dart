import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:provider/provider.dart'; // Add this import
import 'feasibility_form.dart';
import 'trends_screen.dart';
import 'past_reports_screen.dart';
import 'profile_screen.dart';
import 'users_in_district_screen.dart';
import '../providers/app_provider.dart'; // Import your AppProvider
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Animation controller for card tap scaling effect
  late final AnimationController _animationController;

  // Cards data model
  late List<_HomeCardData> _homeCards;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onCardTap(_HomeCardData card) async {
    // Haptic feedback for authentic interaction
    HapticFeedback.lightImpact();

    // Animate scale down and up
    await _animationController.reverse();
    await _animationController.forward();

    // Navigate after animation
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => card.screenBuilder()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = const Color(0xFF1565C0);
    final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [primaryColor.withOpacity(0.07), Colors.white],
    );

    final l10n = AppLocalizations.of(context);

    _homeCards = [
      _HomeCardData(
        icon: FontAwesomeIcons.chartLine,
        title: l10n.homeWaterInsightsTitle,
        subtitle: l10n.homeWaterInsightsSub,
        gradientColors: const [Color(0xFF1976D2), Color(0xFF42A5F5)],
        screenBuilder: () => const TrendsScreen(),
      ),
      _HomeCardData(
        icon: FontAwesomeIcons.droplet,
        title: l10n.homeFeasibilityTitle,
        subtitle: l10n.homeFeasibilitySub,
        gradientColors: const [Color(0xFF00897B), Color(0xFF26A69A)],
        screenBuilder: () => const FeasibilityForm(),
      ),
      _HomeCardData(
        icon: FontAwesomeIcons.clockRotateLeft,
        title: l10n.homePastReportsTitle,
        subtitle: l10n.homePastReportsSub,
        gradientColors: const [Color(0xFF3949AB), Color(0xFF5C6BC0)],
        screenBuilder: () => const PastReportsScreen(),
      ),
      _HomeCardData(
        icon: FontAwesomeIcons.users,
        title: l10n.homeUsersInDistrictTitle,
        subtitle: l10n.homeUsersInDistrictSub,
        gradientColors: const [Color(0xFF43CEA2), Color(0xFF185A9D)],
        screenBuilder: () => const UsersInDistrictScreen(),
      ),
    ];

    // Fetch userr from AppProvider
    final userName = Provider.of<AppProvider>(context).userName;
    final firstName = userName.trim().split(' ').first; // <-- Only first name

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(primaryColor, l10n),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildWelcomeSection(theme, primaryColor, l10n.homeWelcomeBack(firstName)), // <-- localized
                    ..._buildHomeCardsList(),
                    _buildWaterSavingTip(theme, primaryColor, l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(Color primaryColor, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.darken(0.1), primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.appTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.7,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            borderRadius: BorderRadius.circular(24),
            splashColor: Colors.white24,
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF1565C0), size: 26),
            ),
          ),
        ],
      ),
    );
  }

  // Update _buildWelcomeSection to accept string
  Widget _buildWelcomeSection(ThemeData theme, Color primaryColor, String welcomeText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28, top: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  welcomeText,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                    letterSpacing: 0.8,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).homeTagline,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                    letterSpacing: 0.3,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(1, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.cloud,
              color: Color(0xFF1565C0),
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHomeCardsList() {
    return _homeCards
        .map(
          (card) => AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _animationController.value,
                child: child,
              );
            },
            child: _HomeCard(
              icon: card.icon,
              title: card.title,
              subtitle: card.subtitle,
              gradientColors: card.gradientColors,
              onTap: () => _onCardTap(card),
            ),
          ),
        )
        .toList();
  }

  Widget _buildWaterSavingTip(ThemeData theme, Color primaryColor, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(top: 28, bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.15),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "💧 ${l10n.waterSavingTip}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: primaryColor,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.waterSavingBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade900,
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// Data model for the home cards
class _HomeCardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Widget Function() screenBuilder;

  _HomeCardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.screenBuilder,
  });
}

// Home card widget with elevated modern design
class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _HomeCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: gradientColors[1].withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: gradientColors[1].withOpacity(0.3),
          highlightColor: gradientColors[0].withOpacity(0.15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[1].withOpacity(0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF263238),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: gradientColors[0].withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: gradientColors[0],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extension method to darken a color by [amount] (0-1)
extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}