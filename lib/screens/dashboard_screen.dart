import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';
import '../utils/alert_utils.dart';
import 'view_all_accounts_screen.dart';
import 'splash_screen.dart';

String _getTimeBasedGreeting() {
  final hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) return 'Good Morning';
  if (hour >= 12 && hour < 17) return 'Good Afternoon';
  if (hour >= 17 && hour < 21) return 'Good Evening';
  return 'Hello';
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
    );
  }

  // ---------------- SHARE DIALOG ----------------
  void _openShareDialog() {
    final nameCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    String? generated;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: StatefulBuilder(
            builder: (_, setMState) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Share Onboarding Link',
                                style: TextStyle(
                                  fontFamily: 'Calibri',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                        const Divider(color: AppTheme.medium),
                        const SizedBox(height: 16),

                        // Name
                        TextField(
                          controller: nameCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration('Customer name'),
                        ),
                        const SizedBox(height: 12),

                        // Contact
                        TextField(
                          controller: contactCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration('Phone number or email'),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameCtrl.text.trim().isEmpty ||
                                  contactCtrl.text.trim().isEmpty) {
                                showSidianAlert(ctx,
                                    message: 'Please fill in both fields',
                                    type: AlertType.error);
                                return;
                              }
                              const agentCode = 'AG001';
                              generated =
                              'https://sidianbank.co.ke/onboard?agent=$agentCode'
                                  '&name=${Uri.encodeComponent(nameCtrl.text)}'
                                  '&contact=${Uri.encodeComponent(contactCtrl.text)}';
                              setMState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              'Generate link',
                              style: TextStyle(
                                fontFamily: 'Calibri',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                        if (generated != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary.withOpacity(.1),
                              border: Border.all(color: AppTheme.secondary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Generated link',
                                  style: TextStyle(
                                    fontFamily: 'Calibri',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SelectableText(
                                  generated!,
                                  style: const TextStyle(
                                    fontFamily: 'Calibri',
                                    fontSize: 13,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      showSidianAlert(ctx,
                                          message: 'Onboarding Link Shared!',
                                          type: AlertType.success);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppTheme.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                    ),
                                    icon: const Icon(Icons.share, size: 16),
                                    label: const Text('Share'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
        fontFamily: 'Calibri', color: AppTheme.textPrimary, fontSize: 14),
    filled: true,
    fillColor: Colors.white,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppTheme.medium),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
      const BorderSide(color: AppTheme.primary, width: 1.5),
    ),
  );

  // ---------------- ACCOUNT TYPE MODAL ----------------
  void _openStartOnboardingModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                  color: AppTheme.medium,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const Text(
              'Choose account type',
              style: TextStyle(
                fontFamily: 'Calibri',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _AccountTypeCard(
              imagePath: 'assets/images/individual-account.png',
              title: 'Individual Account',
              subtitle: 'For personal banking customers',
              accent: AppTheme.secondary,
              onTap: () {
                Navigator.pop(ctx);
                OnboardingData.I.reset();
                OnboardingData.I.accountCategory = 'Individual';
                Navigator.pushNamed(context, '/individual-account');
              },
            ),
            const SizedBox(height: 10),
            _AccountTypeCard(
              imagePath: 'assets/images/joint-account.png',
              title: 'Joint Account',
              subtitle: 'Shared account (coming soon)',
              accent: AppTheme.primary.withOpacity(0.7),
              onTap: () => showSidianAlert(context,
                  message: 'Coming soon', type: AlertType.info),
            ),
            const SizedBox(height: 10),
            _AccountTypeCard(
              imagePath: 'assets/images/business-account.png',
              title: 'Business Account',
              subtitle: 'For SMEs & enterprises (coming soon)',
              accent: AppTheme.infoBlue,
              onTap: () => showSidianAlert(context,
                  message: 'Coming soon', type: AlertType.info),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- MAIN DASHBOARD ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _TopHeroSection(
              loading: _loading,
              onLogout: _handleLogout,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: _loading
                  ? const _DashboardSkeletonBelow()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      // onPressed: _openStartOnboardingModal,
                      onPressed: () {
                        Navigator.pushNamed(context, '/individual-account');
                      },
                      icon: const Icon(Icons.add,
                          color: AppTheme.secondary),
                      label: const Text('Start New Onboarding'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: const [
                        Expanded(
                          child: _StatCardVertical(
                            icon: Icons.group_outlined,
                            value: '23',
                            label: 'Pending',
                            tint: Color(0xFFE3F2FD), // Soft sky blue
                            iconColor: Color(0xFF2196F3), // Bright blue
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCardVertical(
                            icon: Icons.workspace_premium_rounded,
                            value: 'Gold',
                            label: 'Agent Level',
                            tint: Color(0xFFF6F7E0),
                            iconColor: AppTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      _ViewAllButton(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ActivityItem(
                    leadingBg: AppTheme.successGreen.withOpacity(0.15),
                    leadingIcon: Icons.check_circle_outline,
                    title: 'Grace Wanjiku',
                    subtitle: 'Account opened',
                    trailing: '2 min ago',
                    trailingTop: '1234567890',
                    trailingMeta: 'Reinvite',
                    showActionChip: true,
                    iconColor: AppTheme.successGreen,
                  ),
                  const SizedBox(height: 10),
                  _ActivityItem(
                      leadingBg: AppTheme.secondary.withOpacity(0.15),
                    leadingIcon: Icons.access_time_outlined,
                    title: 'Mary Njeri',
                    subtitle: 'Document review',
                    trailing: '5 min ago',
                    trailingMeta: 'Reinvite',
                    showActionChip: true,
                    iconColor: AppTheme.secondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openShareDialog,
        backgroundColor: AppTheme.secondary,
        child: const Icon(Icons.share_rounded, color: AppTheme.primary),
      ),
    );
  }
}

// ---------------- TOP HERO SECTION ----------------
class _TopHeroSection extends StatelessWidget {
  final bool loading;
  final VoidCallback onLogout;
  const _TopHeroSection({required this.loading, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, Color(0xFF282C43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_getTimeBasedGreeting()},\nAgent',
                    style: const TextStyle(
                      fontFamily: 'Calibri',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onLogout,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.logout_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            loading
                ? _ProgressSkeleton()
                : const _ProgressTintCard(),
          ],
        ),
      ),
    );
  }
}

// ---------------- PROGRESS CARD ----------------
class _ProgressTintCard extends StatelessWidget {
  const _ProgressTintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: const _ProgressContent(),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Progress",
              style: TextStyle(
                fontFamily: 'Calibri',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            _TrendChip(),
          ],
        ),
        SizedBox(height: 8),
        Text(
          '8 Accounts',
          style: TextStyle(
            fontFamily: 'Calibri',
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _MetricItem(value: '96%', label: 'Success Rate')),
            Expanded(child: _MetricItem(value: '142', label: 'This Month')),
          ],
        ),
      ],
    );
  }
}

class _TrendChip extends StatelessWidget {
  const _TrendChip({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.trending_up, size: 16, color: AppTheme.primary),
          SizedBox(width: 4),
          Text(
            '+25%',
            style: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String value;
  final String label;
  const _MetricItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontFamily: 'Calibri',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontFamily: 'Calibri',
                fontSize: 13,
                color: Colors.white70)),
      ],
    );
  }
}

// ---------------- ACTIVITY ITEM ----------------
class _ActivityItem extends StatelessWidget {
  final Color leadingBg;
  final IconData leadingIcon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String trailing;
  final String? trailingTop;
  final String? trailingMeta;
  final bool showActionChip;

  const _ActivityItem({
    required this.leadingBg,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.trailingTop,
    this.trailingMeta,
    this.iconColor = AppTheme.primary,
    this.showActionChip = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: leadingBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(leadingIcon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.primary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 13,
                        color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (trailingTop != null)
                Text(trailingTop!,
                    style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 12,
                        color: AppTheme.textSecondary)),
              if (showActionChip)
                InkWell(
                  onTap: () {
                    showSidianAlert(
                      context,
                      message: 'Reinvite sent successfully!',
                      type: AlertType.success,
                    );
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.primary, width: 1.3),
                    ),
                    child: const Text(
                      'Reinvite',
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 4),
              Text(trailing,
                  style: const TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 11,
                      color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------- OTHER COMPONENTS ----------------
class _StatCardVertical extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color tint;
  final Color iconColor;
  const _StatCardVertical({
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
    required this.iconColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tint),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: AppTheme.primary)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 13,
                  color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.medium.withOpacity(0.6), width: 1),
          ),
          child: Row(
            children: [
              // Illustration box
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}


class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton();
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => ViewAllAccountsScreen())),
      icon: const Icon(Icons.search, size: 16),
      label: const Text('View All'),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.olive,
        textStyle: const TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            decoration: TextDecoration.none),
      ),
    );
  }
}

class _ProgressSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}


class _DashboardSkeletonBelow extends StatelessWidget {
  const _DashboardSkeletonBelow();

  @override
  Widget build(BuildContext context) {
    Widget shimmerBox({
      double h = 16,
      double w = double.infinity,
      double r = 10,
      EdgeInsets? m,
    }) =>
        Container(
          height: h,
          width: w,
          margin: m ?? const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.medium.withOpacity(0.25),
            borderRadius: BorderRadius.circular(r),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Onboarding button skeleton
        shimmerBox(h: 48, r: 12, m: const EdgeInsets.symmetric(vertical: 8)),

        const SizedBox(height: 20),

        // Stat cards skeleton
        Row(
          children: [
            Expanded(child: shimmerBox(h: 130, r: 12)),
            const SizedBox(width: 12),
            Expanded(child: shimmerBox(h: 130, r: 12)),
          ],
        ),

        const SizedBox(height: 24),

        // Section title
        shimmerBox(h: 18, w: 160, r: 8),

        const SizedBox(height: 16),

        // Activity items skeleton
        shimmerBox(h: 74, r: 12),
        shimmerBox(h: 74, r: 12),
      ],
    );
  }
}

