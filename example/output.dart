class ProfileCreationState {

  final String firstName;
  final String lastName;
  final bool loading;
  final String? errorMessage;

  const ProfileCreationState({
    required this.firstName,
    required this.lastName,
    required this.loading,
    this.errorMessage,
  });

  factory ProfileCreationState.pure() {
    return ProfileCreationState(
      firstName: '',
      lastName: '',
      loading: false,
    ); 
  }

  ProfileCreationState copyWith({
    String? firstName,
    String? lastName,
    bool? loading,
    String? errorMessage
  }) => ProfileCreationState(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    loading: loading ?? this.loading,
    errorMessage: errorMessage ?? this.errorMessage
  );
}