class RefundPolicyEntry {
  final String eventTitle;
  final String policy;

  const RefundPolicyEntry({
    required this.eventTitle,
    required this.policy,
  });
}

class RefundPolicyRouteArgs {
  final String title;
  final List<RefundPolicyEntry> policies;
  final String? ownerAccountId;

  const RefundPolicyRouteArgs({
    required this.title,
    required this.policies,
    this.ownerAccountId,
  });
}
