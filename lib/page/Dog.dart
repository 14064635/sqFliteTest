class Dog {
  final int id;
  final String name;
  final int age;
  final String family;

  Dog({this.id, this.name, this.age,this.family});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'family':family,
    };
  }
}

