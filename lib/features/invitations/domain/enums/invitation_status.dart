enum InvitationStatus {
  pending,
  accepted,
  declined;

  static InvitationStatus fromValue(String? value) => switch (value) {
    'accepted' => InvitationStatus.accepted,
    'declined' => InvitationStatus.declined,
    _ => InvitationStatus.pending,
  };
}
