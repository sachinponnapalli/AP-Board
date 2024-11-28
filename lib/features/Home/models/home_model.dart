class HomeModel {
  List<MenuItems>? menuItems;
  List<ClassItems>? classItems;

  HomeModel({this.menuItems, this.classItems});

  HomeModel.fromJson(Map<dynamic, dynamic> json) {
    menuItems = json["menu_items"] == null
        ? null
        : (json["menu_items"] as List)
            .map((e) => MenuItems.fromJson(e))
            .toList();
    classItems = json["class_items"] == null
        ? null
        : (json["class_items"] as List)
            .map((e) => ClassItems.fromJson(e))
            .toList();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    if (menuItems != null) {
      data["menu_items"] = menuItems?.map((e) => e.toJson()).toList();
    }
    if (classItems != null) {
      data["class_items"] = classItems?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ClassItems {
  String? text;
  String? href;

  ClassItems({this.text, this.href});

  ClassItems.fromJson(Map<dynamic, dynamic> json) {
    text = json["text"];
    href = json["href"];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    data["href"] = href;
    return data;
  }
}

class MenuItems {
  String? text;
  String? href;

  MenuItems({this.text, this.href});

  MenuItems.fromJson(Map<dynamic, dynamic> json) {
    text = json["text"];
    href = json["href"];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    data["href"] = href;
    return data;
  }
}
