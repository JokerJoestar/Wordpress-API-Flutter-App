class Category {
  final int id;
  final String name;
  final String slug;
  final int parent;

  Category({
    this.id,
    this.name,
    this.slug,
    this.parent
  }) ;

  factory Category.fromJson(Map<String, dynamic> json){
    return new Category(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      slug: json['slug'],
      parent: json['parent'] 
    );
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'parent': parent
  };
}