import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/alert_utils.dart';

// Mock data model
class OpenedAccount {
  final String id;
  final String name;
  final String contact;
  final String accountType;
  final DateTime dateOpened;
  final String status;
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

// Mock data
final List<OpenedAccount> mockOpenedAccounts = [
  OpenedAccount(
    id: 'ACC001',
    name: 'Grace Wanjiku',
    contact: '1234567890',
    accountType: 'Individual',
    dateOpened: DateTime.now().subtract(const Duration(minutes: 2)),
    status: 'Active',
    onboardingLink: 'https://sidianbank.co.ke/onboard?agent=AG001&name=Grace%20Wanjiku',
  ),
  OpenedAccount(
    id: 'ACC002',
    name: 'Mary Njeri',
    contact: '0987654321',
    accountType: 'Individual',
    dateOpened: DateTime.now().subtract(const Duration(minutes: 5)),
    status: 'Pending',
    onboardingLink: 'https://sidianbank.co.ke/onboard?agent=AG001&name=Mary%20Njeri',
  ),
  OpenedAccount(
    id: 'ACC003',
    name: 'John Kamau',
    contact: '1122334455',
    accountType: 'Individual',
    dateOpened: DateTime.now().subtract(const Duration(hours: 1)),
    status: 'Active',
    onboardingLink: 'https://sidianbank.co.ke/onboard?agent=AG001&name=John%20Kamau',
  ),
  OpenedAccount(
    id: 'ACC004',
    name: 'Sarah Mwende',
    contact: '5566778899',
    accountType: 'Business',
    dateOpened: DateTime.now().subtract(const Duration(minutes: 30)),
    status: 'Pending',
    onboardingLink: 'https://sidianbank.co.ke/onboard?agent=AG001&name=Sarah%20Mwende',
  ),
];

class ViewAllAccountsScreen extends StatefulWidget {
  const ViewAllAccountsScreen({super.key});

  @override
  State<ViewAllAccountsScreen> createState() => _ViewAllAccountsScreenState();
}

class _ViewAllAccountsScreenState extends State<ViewAllAccountsScreen> {
  List<OpenedAccount> accounts = List.from(mockOpenedAccounts);
  String selectedFilter = 'All';
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  List<OpenedAccount> get filteredAccounts {
    return accounts.where((a) {
      final matchSearch = a.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          a.contact.contains(searchQuery);
      final matchFilter = selectedFilter == 'All' || a.status == selectedFilter;
      return matchSearch && matchFilter;
    }).toList();
  }

  void _reinviteCustomer(OpenedAccount account) {
    showSidianAlert(
      context,
      message: 'Reinvite link for ${account.name} copied to clipboard!',
      type: AlertType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Opened Accounts',
          style: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search accounts...',
                hintStyle: const TextStyle(
                  fontFamily: 'Calibri',
                  color: Colors.grey,
                  fontSize: 15,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.medium),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.medium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: AppTheme.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // 🟨 Filter Chips
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
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: 'Active',
                    isSelected: selectedFilter == 'Active',
                    onTap: () => setState(() => selectedFilter = 'Active'),
                  ),
                  const SizedBox(width: 10),
                  _FilterChip(
                    label: 'Pending',
                    isSelected: selectedFilter == 'Pending',
                    onTap: () => setState(() => selectedFilter = 'Pending'),
                  ),
                ],
              ),
            ),
          ),

          // 📋 Account List
          Expanded(
            child: filteredAccounts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.people_outline,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No accounts found',
                    style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredAccounts.length,
              itemBuilder: (_, i) {
                final account = filteredAccounts[i];
                return _AccountCard(
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

// 🟨 Filter chip
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
          isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.medium,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

// 📦 Account Card
class _AccountCard extends StatelessWidget {
  final OpenedAccount account;
  final VoidCallback onReinvite;

  const _AccountCard({required this.account, required this.onReinvite});

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = account.status == 'Active';
    final isPending = account.status == 'Pending';
    final Color statusColor =
    isActive ? Colors.green : (isPending ? AppTheme.secondary : Colors.grey);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.medium),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // status icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? Icons.check_circle_outline : Icons.schedule_outlined,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isActive ? 'Account opened' : 'Document review',
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // trailing column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isActive)
                Text(
                  account.contact,
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                _formatTimeAgo(account.dateOpened),
                style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              StatefulBuilder(
                builder: (context, setMState) {
                  bool sending = false;
                  return InkWell(
                    onTap: sending
                        ? null
                        : () async {
                      setMState(() => sending = true);
                      await Future.delayed(const Duration(seconds: 2));
                      setMState(() => sending = false);
                      showSidianAlert(
                        context,
                        message: 'Reinvite sent successfully to ${account.name}!',
                        type: AlertType.success,
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.primary, width: 1.3),
                      ),
                      child: sending
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primary,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Sending...',
                            style: TextStyle(
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      )
                          : const Text(
                        'Reinvite',
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}
