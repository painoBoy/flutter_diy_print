class ModelLibraryModel {
  int totalCount;
  List<ModelItems> items;

  ModelLibraryModel({this.totalCount, this.items});

  ModelLibraryModel.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    if (json['items'] != null) {
      items = new List<ModelItems>();
      json['items'].forEach((v) {
        items.add(new ModelItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelItems {
  int id;
  String name;
  String url;
  String slug;
  int popularity;
  Null parent;

  ModelItems(
      {this.id, this.name, this.url, this.slug, this.popularity, this.parent});

  ModelItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    slug = json['slug'];
    popularity = json['popularity'];
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['slug'] = this.slug;
    data['popularity'] = this.popularity;
    data['parent'] = this.parent;
    return data;
  }
}