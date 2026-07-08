class KycResponse {
  String? status;
  String? message;
  bool? isVerified;
  String? beneficiaryId;

  KycResponse({this.status, this.message, this.isVerified, this.beneficiaryId});

  KycResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isVerified = json['is_verified'];
    beneficiaryId = json['beneficiary_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['is_verified'] = isVerified;
    data['beneficiary_id'] = beneficiaryId;
    return data;
  }
}
