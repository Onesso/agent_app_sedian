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

  // Share bottom sheet
  // Share modal dialog
  void _openShareDialog() {
    final nameCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    String? generated;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: StatefulBuilder(
            builder: (_, setMState) {
              final content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Share Onboarding Link',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppTheme.darkGray,
                            ),
                          ),
                        ),
                        IconButton(
                          splashRadius: 20,
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close, color: AppTheme.midGray),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Customer name
                        TextField(
                          controller: nameCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Customer name',
                            filled: true,
                            fillColor: AppTheme.white, // filled white
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // radius
                              borderSide: const BorderSide(color: AppTheme.textFieldOutline, width: 1), // color & thickness
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.textFieldOutline, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.lightBlue, width: 1.5), // focus color & thickness
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Phone number or email
                        TextField(
                          controller: contactCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Phone number or email',
                            filled: true,
                            fillColor: AppTheme.white, // filled white
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), // radius
                              borderSide: const BorderSide(color: AppTheme.textFieldOutline, width: 1), // color & thickness
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.textFieldOutline, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppTheme.lightBlue, width: 1.5), // focus color & thickness
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameCtrl.text.trim().isEmpty || contactCtrl.text.trim().isEmpty) {
                                showEcobankAlert(ctx, message: 'Please fill in both fields', type: AlertType.error);
                                return;
                              }
                              const agentCode = 'AG001'; // TODO: inject real agent code
                              generated = 'https://ecobank-app.com/onboard'
                                  '?agent=$agentCode'
                                  '&name=${Uri.encodeComponent(nameCtrl.text.trim())}'
                                  '&contact=${Uri.encodeComponent(contactCtrl.text.trim())}';
                              setMState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.lightGreen,
                              foregroundColor: AppTheme.darkBlueHighlight,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: const Text('Generate link'),
                          ),
                        ),

                        if (generated != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.lightGreen.withOpacity(.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.lightGreen),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Generated link',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: AppTheme.darkGray,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SelectableText(
                                  generated!,
                                  style: const TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 12,
                                    color: AppTheme.darkGray,
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  height: 38,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      if (generated == null) {
                                        showEcobankAlert(ctx, message: 'Please generate a link first.', type: AlertType.error);
                                        return;
                                      }
                                      showEcobankAlert(ctx, message: 'Onboarding link ready to share!', type: AlertType.success);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppTheme.secondaryButton,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                ],
              );

              // Make dialog content scrollable & keyboard-safe
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  child: SingleChildScrollView(child: content),
                ),
              );
            },
          ),
        );
      },
    );
  }




  //  Account Type Modal
  void _openStartOnboardingModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightGray, borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Choose account type',
              style: TextStyle(
                fontFamily: 'Gilroy', fontWeight: FontWeight.w700, fontSize: 18,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 12),

            // Minimal image cards
            _AccountTypeCard(
              imagePath: 'assets/images/individual-account.png',
              title: 'Individual Account',
              subtitle: 'For personal banking customers',
              accent: AppTheme.lightBlue,
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
              accent: AppTheme.darkBlueHighlight,
              onTap: () => showEcobankAlert(context, message: 'Coming soon', type: AlertType.info),
            ),
            const SizedBox(height: 10),
            _AccountTypeCard(
              imagePath: 'assets/images/business-account.png',
              title: 'Business Account',
              subtitle: 'For SMEs & enterprises (coming soon)',
              accent: AppTheme.mobileAppGreen,
              onTap: () => showEcobankAlert(context, message: 'Coming soon', type: AlertType.info),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ONE continuous hero with rounded bottom that contains greeting + logout + progress
          SliverToBoxAdapter(
            child: _TopHeroSection(
              loading: _loading,
              onLogout: _handleLogout,
            ),
          ),

          // CONTENT BELOW HERO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: _loading
                  ? const _DashboardSkeletonBelow()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start New Onboarding FIRST
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _openStartOnboardingModal,
                      icon: const Icon(Icons.add, color: AppTheme.darkBlueHighlight),
                      label: const Text('Start New Onboarding'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightGreen,
                        foregroundColor: AppTheme.darkBlueHighlight,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(
                          fontFamily: 'Gilroy', fontWeight: FontWeight.w700, fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // stat cards
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCardVertical(
                            icon: Icons.group_sharp,
                            value: '23',
                            label: 'Pending',
                            tint: const Color(0xFFEAF5FC),
                            iconColor: AppTheme.lightBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCardVertical(
                            icon: Icons.workspace_premium_rounded,
                            value: 'Gold',
                            label: 'Agent Level',
                            tint: const Color(0xFFF5FAE8),
                            iconColor: AppTheme.lightGreen,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppTheme.darkGray,
                          ),
                        ),
                      ),
                      _ViewAllButton(),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Account opened
                  const _ActivityItem(
                    leadingBg: Color(0xFFE6F3FB),
                    leadingIcon: Icons.check_circle_outline_rounded,
                    title: 'Grace Wanjiku',
                    subtitle: 'Account opened',
                    trailingTop: '1234567890',
                    trailing: '2 min ago',
                    trailingMeta: 'Reinvite',
                    showActionChip: true,
                  ),
                  const SizedBox(height: 10),

                  // Pending: reinvite button
                  const _ActivityItem(
                    leadingBg: Color(0xFFF2F8E1),
                    leadingIcon: Icons.access_time_outlined,
                    title: 'Mary Njeri',
                    subtitle: 'Document review',
                    trailing: '5 min ago',
                    trailingMeta: 'Reinvite',
                    showActionChip: true,
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),

      // FAB: SHARE (icon only)
      floatingActionButton: FloatingActionButton(
        onPressed: _openShareDialog,
        backgroundColor: AppTheme.secondaryButton,
        elevation: 2,
        child: const Icon(Icons.share_rounded, color: Colors.white),
      ),
    );
  }
}

//  New minimal image card tile
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Row(
            children: [
              // Illustration with soft background
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: accent.withOpacity(.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Center(
                  child: Image.asset(imagePath, width: 36, height: 36, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 12),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkGray,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 13,
                        color: AppTheme.darkGrayT,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron
              const Icon(Icons.chevron_right, color: AppTheme.midGray),
            ],
          ),
        ),
      ),
    );
  }
}

// Top section with greeting (left) + logout (right), then progress card
class _TopHeroSection extends StatelessWidget {
  final bool loading;
  final VoidCallback onLogout;
  const _TopHeroSection({required this.loading, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0E7490), // cyan-700
              Color(0xFF065F46), // emerald-800
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Gilroy',
                          height: 1.25,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                        children: [
                          TextSpan(text: '${_getTimeBasedGreeting()},\n'),
                          const TextSpan(
                            text: 'Agent',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _HeroCircleIcon(
                    icon: Icons.logout_rounded,
                    tooltip: 'Log out',
                    onTap: onLogout,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              loading ? _ProgressSkeleton() : const _ProgressTintCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// logout
class _HeroCircleIcon extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback onTap;
  const _HeroCircleIcon({
    required this.icon,
    this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final btn = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.22)),
        ),
        child: const Center(
          child: Icon(Icons.logout_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
    return tooltip != null
        ? Tooltip(message: tooltip!, child: btn)
        : btn;
  }
}


class _ProgressTintCard extends StatelessWidget {
  const _ProgressTintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      constraints: const BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0E7490).withOpacity(0.14),
            const Color(0xFF065F46).withOpacity(0.10),
          ],
        ),
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
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
            fontFamily: 'Gilroy',
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 1.1,
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
        color: AppTheme.lightGreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.trending_up, size: 16, color: AppTheme.darkBlueHighlight),
          SizedBox(width: 4),
          Text(
            '+25%',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkBlueHighlight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget box(double h, double w) => Container(
      height: h,
      width: w,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      constraints: const BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [box(14, 120), const Spacer(), box(20, 58)]),
          box(26, 180),
          Row(children: [Expanded(child: box(18, double.infinity)), const SizedBox(width: 10), Expanded(child: box(18, double.infinity))]),
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
              fontFamily: 'Gilroy', fontSize: 24, color: Colors.white, fontWeight: FontWeight.w800,
            )),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
              fontFamily: 'Gilroy', fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Color leadingBg;
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final String trailing;       // time ago
  final String? trailingMeta;  // for "Reinvite" semantics
  final String? trailingTop;
  final bool showActionChip;

  const _ActivityItem({
    required this.leadingBg,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.trailingMeta,
    this.trailingTop,
    this.showActionChip = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final double trailingMax = (c.maxWidth * 0.30).clamp(108.0, 140.0).toDouble();

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // leading icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: leadingBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(leadingIcon, color: AppTheme.lightBlue),
              ),
              const SizedBox(width: 12),

              // middle texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 13,
                        color: AppTheme.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // trailing column
              SizedBox(
                width: trailingMax,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // optional top line (e.g., account number)
                    if (trailingTop != null)
                      Text(
                        trailingTop!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkGray,
                        ),
                      ),

                    if (showActionChip)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showEcobankAlert(
                                ctx,
                                message: 'Reinvite link copied to clipboard!',
                                type: AlertType.success,
                              );
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.lightBlue, width: 1),
                              ),
                              child: const Text(
                                'Reinvite',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.darkBlueHighlight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 4),
                    Text(
                      trailing,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 11,
                        color: AppTheme.midGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.push(
        context, MaterialPageRoute(builder: (_) => ViewAllAccountsScreen()),
      ),
      icon: const Icon(Icons.search, size: 16),
      label: const Text('View All'),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.lightBlue,
        textStyle: const TextStyle(
          fontFamily: 'Gilroy', fontWeight: FontWeight.w700, fontSize: 13, decoration: TextDecoration.none,
        ),
      ),
    );
  }
}


class _StatCardVertical extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color tint;
  final Color iconColor;

  const _StatCardVertical({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tint.withOpacity(0.75), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // top icon
          Icon(icon, color: iconColor, size: 28),

          // center value
          const Spacer(),
          Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.darkGray,
                height: 1.0,
              ),
            ),
          ),
          const Spacer(),

          // bottom label
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkGray,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// skeleton placeholders for content below hero
class _DashboardSkeletonBelow extends StatelessWidget {
  const _DashboardSkeletonBelow();

  @override
  Widget build(BuildContext context) {
    Widget box({double h = 16, double w = double.infinity, double r = 10}) => Container(
      height: h, width: w,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: Colors.black.withOpacity(.06), borderRadius: BorderRadius.circular(r)),
    );
    return Column(
      children: [
        Container(height: 48, decoration: BoxDecoration(color: AppTheme.lightGrayT1, borderRadius: BorderRadius.circular(10))),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: Container(height: 130, decoration: BoxDecoration(color: AppTheme.lightGrayT1, borderRadius: BorderRadius.circular(12)))),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 130, decoration: BoxDecoration(color: AppTheme.lightGrayT1, borderRadius: BorderRadius.circular(12)))),
        ]),
        const SizedBox(height: 12),
        Align(alignment: Alignment.centerLeft, child: box(h: 18, w: 160)),
        const SizedBox(height: 10),
        Container(height: 74, decoration: BoxDecoration(color: AppTheme.lightGrayT1, borderRadius: BorderRadius.circular(12))),
        const SizedBox(height: 10),
        Container(height: 74, decoration: BoxDecoration(color: AppTheme.lightGrayT1, borderRadius: BorderRadius.circular(12))),
      ],
    );
  }
}
