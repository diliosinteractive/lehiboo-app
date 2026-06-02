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

  const RefundPolicyRouteArgs({
    required this.title,
    required this.policies,
  });
}
