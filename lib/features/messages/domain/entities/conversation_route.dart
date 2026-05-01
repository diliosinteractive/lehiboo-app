enum ConversationRoute {
  participant,        // /user/conversations              (auto-mark read on GET)
  participantSupport, // /user/support-conversations      (auto-mark read on GET)
  vendor,             // /vendor/conversations            (POST /read required)
  vendorOrgOrg,       // /vendor/org-conversations        (POST /read required)
  admin,              // /admin/conversations             (POST /read required)
  adminReadonly,      // /admin/conversations — observe   (read-only, linked to report)
}
