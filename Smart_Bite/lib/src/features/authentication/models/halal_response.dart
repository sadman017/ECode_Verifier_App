class HalalResponse {
  final String? status;
  final String? company;
  final bool? certified;
  final String? detail;

  const HalalResponse({
    this.status,
    this.company,
    this.certified,
    this.detail,
  });

  factory HalalResponse.fromJson(Map<String, dynamic> json) {
    final bool isCertified = json['certified'] == true;
    final List<dynamic>? certs = json['certifications'] as List<dynamic>?;
    String? companyName;
    if (certs != null && certs.isNotEmpty) {
      final first = certs.first as Map<String, dynamic>;
      companyName = (first['company_name'] ?? first['premise_name']) as String?;
    }
    return HalalResponse(
      status: isCertified ? 'Halal Certified' : 'Not Certified',
      company: companyName,
      certified: isCertified,
    );
  }

  bool get isHalalCertified =>
      status?.toLowerCase().contains('halal') ?? false;

  bool get isNotFound =>
      status?.toLowerCase().contains('not found') ?? false;
}
