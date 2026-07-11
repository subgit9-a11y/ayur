class WalletResponse {
  bool? success;
  WalletData? data;
  String? msg;

  WalletResponse({this.success, this.data, this.msg});

  WalletResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? WalletData.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    return data;
  }
}

class WalletData {
  String? availableBalance;
  String? totalEarned;
  String? withdrawnAmount;
  List<WalletTransaction>? transactions;

  WalletData(
      {this.availableBalance,
      this.totalEarned,
      this.withdrawnAmount,
      this.transactions});

  WalletData.fromJson(Map<String, dynamic> json) {
    availableBalance = json['available_balance']?.toString();
    totalEarned = json['total_earned']?.toString();
    withdrawnAmount = json['withdrawn_amount']?.toString();
    if (json['transactions'] != null) {
      transactions = <WalletTransaction>[];
      json['transactions'].forEach((v) {
        transactions!.add(WalletTransaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['available_balance'] = availableBalance;
    data['total_earned'] = totalEarned;
    data['withdrawn_amount'] = withdrawnAmount;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletTransaction {
  int? id;
  String? type;
  String? amount;
  String? description;
  String? createdAt;

  WalletTransaction(
      {this.id, this.type, this.amount, this.description, this.createdAt});

  WalletTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    amount = json['amount']?.toString();
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['amount'] = amount;
    data['description'] = description;
    data['created_at'] = createdAt;
    return data;
  }
}
