import 'package:flutter/material.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/theme/ayureze_theme.dart';
import 'package:doctro/services/astra_api_service.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/model/wallet.dart';

class EarningsDashboard extends StatefulWidget {
  const EarningsDashboard({Key? key}) : super(key: key);

  @override
  _EarningsDashboardState createState() => _EarningsDashboardState();
}

class _EarningsDashboardState extends State<EarningsDashboard> {
  final AstraApiService _astraApiService = AstraApiService();
  bool _isLoading = true;
  WalletResponse? _walletResponse;

  @override
  void initState() {
    super.initState();
    _fetchWallet();
  }

  Future<void> _fetchWallet() async {
    setState(() => _isLoading = true);
    try {
      String doctorId = SharedPreferenceHelper.getString(Preferences.uniqueId);
      if (doctorId == 'N_A' || doctorId.isEmpty) {
        doctorId = SharedPreferenceHelper.getString(Preferences.doctorId);
      }
      final res = await _astraApiService.getWallet(doctorId);
      _walletResponse = WalletResponse.fromJson(res);
    } catch (e) {
      _walletResponse = null;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = double.tryParse(_walletResponse?.data?.availableBalance ?? "0") ?? 0.0;
    final bool isEligible = balance >= 300;

    return Scaffold(
      backgroundColor: AyurezeTheme.canvas,
      appBar: AppBar(
        title: Text("Earnings & Payouts", style: TextStyle(color: AyurezeTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 22)),
        backgroundColor: AyurezeTheme.surface,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: AyurezeTheme.textPrimary, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: AyurezeTheme.healingGreen100))
        : RefreshIndicator(
            onRefresh: _fetchWallet,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceCard(balance),
                  const SizedBox(height: 15),
                  _buildStatusBanner(isEligible, balance),
                  const SizedBox(height: 30),
                  Text("Transaction History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AyurezeTheme.textPrimary)),
                  const SizedBox(height: 15),
                  _buildTransactionsList(),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AyurezeTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AyurezeTheme.shadow.withOpacity(0.08), blurRadius: 10)],
        border: Border.all(color: AyurezeTheme.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text("Available Balance", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AyurezeTheme.textSecondary)),
          const SizedBox(height: 10),
          Text("₹${balance.toStringAsFixed(2)}", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AyurezeTheme.healingGreen100)),
          const SizedBox(height: 20),
          Divider(color: AyurezeTheme.border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Lifetime Earnings: ", style: TextStyle(fontSize: 13, color: AyurezeTheme.textSecondary)),
              Text("₹${_walletResponse?.data?.totalEarned ?? "0"}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AyurezeTheme.textPrimary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusBanner(bool isEligible, double balance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEligible ? AyurezeTheme.healingGreen10 : const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isEligible ? AyurezeTheme.healingGreen50.withOpacity(0.5) : Colors.orangeAccent.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isEligible ? Icons.check_circle : Icons.info, color: isEligible ? AyurezeTheme.healingGreen100 : Colors.orange, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEligible ? "Payout Scheduled" : "Minimum Balance Not Reached", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AyurezeTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(
                  isEligible 
                    ? "Your available balance is over ₹300. It will be automatically processed to your bank account on the upcoming Tuesday or Friday via Cashfree."
                    : "You need at least ₹300 in available balance to qualify for the automated Tuesday/Friday payouts. You are short by ₹${(300 - balance).toStringAsFixed(2)}.",
                  style: TextStyle(fontSize: 13, color: AyurezeTheme.textSecondary, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    final txs = _walletResponse?.data?.transactions ?? [];
    if (txs.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(30), child: Text("No transactions yet.", style: TextStyle(color: AyurezeTheme.textSecondary))));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: txs.length,
      itemBuilder: (context, index) {
        final tx = txs[index];
        final isCredit = tx.type == "CREDIT_CONSULTATION";
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AyurezeTheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AyurezeTheme.border.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: isCredit ? AyurezeTheme.healingGreen10 : Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? AyurezeTheme.healingGreen100 : Colors.red, size: 20),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.description ?? "", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AyurezeTheme.textPrimary)),
                    const SizedBox(height: 4),
                    Text(tx.createdAt ?? "", style: TextStyle(fontSize: 12, color: AyurezeTheme.textSecondary)),
                  ],
                ),
              ),
              Text(
                "${isCredit ? '+' : '-'}₹${tx.amount}", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isCredit ? AyurezeTheme.healingGreen100 : Colors.red)
              ),
            ],
          ),
        );
      },
    );
  }
}
