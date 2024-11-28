class ClassSolutionsModel {
  String? mainTitle;
  List<Solutions>? solutions;

  ClassSolutionsModel({this.mainTitle, this.solutions});

  ClassSolutionsModel.fromJson(Map<dynamic, dynamic> json) {
    mainTitle = json["main_title"];
    solutions = json["solutions"] == null
        ? null
        : (json["solutions"] as List)
            .map((e) => Solutions.fromJson(e))
            .toList();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data["main_title"] = mainTitle;
    if (solutions != null) {
      data["solutions"] = solutions?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Solutions {
  String? title;
  List<ChildLinks>? childLinks;

  Solutions({this.title, this.childLinks});

  Solutions.fromJson(Map<dynamic, dynamic> json) {
    title = json["title"];
    childLinks = json["child_links"] == null
        ? null
        : (json["child_links"] as List)
            .map((e) => ChildLinks.fromJson(e))
            .toList();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    if (childLinks != null) {
      data["child_links"] = childLinks?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class ChildLinks {
  String? childTitle;
  String? childHref;

  ChildLinks({this.childTitle, this.childHref});

  ChildLinks.fromJson(Map<dynamic, dynamic> json) {
    childTitle = json["child_title"];
    childHref = json["child_href"];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data["child_title"] = childTitle;
    data["child_href"] = childHref;
    return data;
  }
}
