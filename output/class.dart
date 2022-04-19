class Human {

  final String fullName;
  final num age;
  final String? nickName;

  Human(this.fullName, {
    required this.age,
    this.nickName,
    String param = ''
  }) {
    
  }

  factory Human.fromHuman(Human other)
  => Human(other.fullName, 
    age: other.age
  );
}