import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/alert_utils.dart';

// Mock data model for opened accounts
class OpenedAccount {
  final String id;
  final String name;
  final String contact; //  "account number" placeholder)
  final String accountType;
  final DateTime dateOpened;
  final String status; // 'Active' => Account opened, 'Pending' => Document review
  final String onboardingLink;

  OpenedAccount({
    required this.id,
    required this.name,
    required this.contact,
    required this.accountType,
    required this.dateOpened,
    required this.status,
    required this.onboardingLink,
  });
}

// Mock data - replace with actual data source later
final List<OpenedAccount> mockOpenedAccounts = [
  OpenedAccount(
    id: 'ACC001',
    name: 'Grace Wanjiku',
    contact: '1234567890',
    accountType: 'Individual',
    dateOpened: DateTime.now().subtract(const Duration(minutes: 2)),
    status: 'Active',
    onboardingLink: 'https://ecobank-app.com/onboard?agent=AG001&name=Grace%20Wanjiku&contact=1234567890',
  ),
  OpenedAccount(
    id: 'ACC002',
    name: 'Mary Njeri',
    contact: '0987654321',
    accountType: 'Individual',
    dateOpened: DateTime.now().subtract(const Duration(minutes: 5)),
    status: 'Pending',
    onboardingLink: 'https://ecobank-app.com/onboard?agent=AG001&name=Mary%20Njeri&contact=0987654321',
  ),
  OpenedAccount(
    id: 'ACC003',
    name: 'John Kamau',
    contact: '1122334455',
    accountType: 'Individual',
    dateOpened: DateTime.now().subtract(const Duration(hours: 1)),
    status: 'Active',
    onboardingLink: 'https://ecobank-app.com/onboard?agent=AG001&name=John%20Kamau&contact=1122334455',
  ),
  OpenedAccount(
    id: 'ACC004',
    name: 'Sarah Mwende',
    contact: '5566778899',
    accountType: 'Business',
    dateOpened: DateTime.now().subtract(const Duration(minutes: 30)),
    status: 'Pending',
    onboardingLink: 'https://ecobank-app.com/onboard?agent=AG001&name=Sarah%20Mwende&contact=5566778899',
  ),
  OpenedAccount(
    id: 'ACC005',
    name: 'David Ochieng',
    contact: '9988776655',
    accountType: 'Individual',
    dateOpened: DateTime.now().subtract(const Duration(days: 1)),
    status: 'Active',
    onboardingLink: 'https://ecobank-app.com/onboard?agent=AG001&name=David%20Ochieng&contact=9988776655',
  ),
];

// View All Accounts Screen
class ViewAllAccountsScreen extends StatefulWidget {
  @override
  State<ViewAllAccountsScreen> createState() => _ViewAllAccountsScreenState();
}

class _ViewAllAccountsScreenState extends State<ViewAllAccountsScreen> {
  List<OpenedAccount> accounts = List.from(mockOpenedAccounts);
  String selectedFilter = 'All';
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<OpenedAccount> get filteredAccounts {
    return accounts.where((account) {
      final matchesSearch = account.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          account.contact.contains(searchQuery);
      final matchesFilter = selectedFilter == 'All' || account.status == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _reinviteCustomer(OpenedAccount account) {
    // Placeholder for copy/share logic
    showEcobankAlert(
      context,
      message: 'Reinvite link for ${account.name} copied to clipboard!',
      type: AlertType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppTheme.lightBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Opened Accounts',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.darkGray,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search accounts...',
                hintStyle: const TextStyle(fontFamily: 'Gilroy', color: Color(0xFF9CA3AF)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0E7490), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: selectedFilter == 'All',
                    onTap: () => setState(() => selectedFilter = 'All'),
                    selectedBg: AppTheme.lightGreen,
                    selectedText: AppTheme.darkBlueHighlight,
                    selectedBorder: AppTheme.lightGreen,
                    unselectedBg: Colors.white,
                    unselectedText: AppTheme.midGray,
                    unselectedBorder: const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: 'Active',
                    isSelected: selectedFilter == 'Active',
                    onTap: () => setState(() => selectedFilter = 'Active'),
                    selectedBg: AppTheme.lightGreen,
                    selectedText: AppTheme.darkBlueHighlight,
                    selectedBorder: AppTheme.lightGreen,
                    unselectedBg: Colors.white,
                    unselectedText: AppTheme.midGray,
                    unselectedBorder: const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: 'Pending',
                    isSelected: selectedFilter == 'Pending',
                    onTap: () => setState(() => selectedFilter = 'Pending'),
                    selectedBg: AppTheme.lightGreen,
                    selectedText: AppTheme.darkBlueHighlight,
                    selectedBorder: AppTheme.lightGreen,
                    unselectedBg: Colors.white,
                    unselectedText: AppTheme.midGray,
                    unselectedBorder: const Color(0xFFE5E7EB),
                  ),
                ],
              ),
            ),
          ),

          // Accounts List
          Expanded(
            child: filteredAccounts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: const Color(0xFF9CA3AF).withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'No accounts found',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredAccounts.length,
              itemBuilder: (context, index) {
                final account = filteredAccounts[index];
                return _MinimalAccountCard(
                  account: account,
                  onReinvite: () => _reinviteCustomer(account),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedBg;
  final Color unselectedBg;
  final Color selectedText;
  final Color unselectedText;
  final Color selectedBorder;
  final Color unselectedBorder;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedBg = AppTheme.lightBlue,
    this.unselectedBg = Colors.white,
    this.selectedText = Colors.white,
    this.unselectedText = const Color(0xFF6B7280),
    this.selectedBorder = AppTheme.lightBlue,
    this.unselectedBorder = const Color(0xFFE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? selectedBorder : unselectedBorder, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? selectedText : unselectedText,
          ),
        ),
      ),
    );
  }
}

// Ultra-minimal Account Card
class _MinimalAccountCard extends StatelessWidget {
  final OpenedAccount account;
  final VoidCallback onReinvite;

  const _MinimalAccountCard({
    required this.account,
    required this.onReinvite,
  });

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hr ago';
    if (difference.inDays == 1) return 'Yesterday';
    return '${difference.inDays} days ago';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Active':
        return 'Account opened';
      case 'Pending':
        return 'Document review';
      default:
        return status;
    }
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'Active':
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(color: Color(0xFFE0F2FE), shape: BoxShape.circle),
          child: const Icon(Icons.check, color: AppTheme.lightBlue, size: 22),
        );
      case 'Pending':
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(color: Color(0xFFFEF3C7), shape: BoxShape.circle),
          child: const Icon(Icons.schedule, color: AppTheme.warningYellow, size: 22),
        );
      default:
        return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
          child: const Icon(Icons.help_outline, color: AppTheme.midGray, size: 22),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPending = account.status == 'Pending';
    final bool isActive = account.status == 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          _getStatusIcon(account.status),
          const SizedBox(width: 16),

          // Left: Name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkGray,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getStatusText(account.status),
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.midGray,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Right: (Account number only for Active), time, reinvite
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isActive) ...[
                Text(
                  account.contact, // treat as account number once opened
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                _formatTimeAgo(account.dateOpened),
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.midGray,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),

              // Reinvite button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onReinvite,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
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
            ],
          ),
        ],
      ),
    );
  }
}
