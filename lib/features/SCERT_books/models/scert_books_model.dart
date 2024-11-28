class ScertBooksModel {
  List<Data>? data;

  ScertBooksModel({this.data});

  ScertBooksModel.fromJson(Map<dynamic, dynamic> json) {
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
  }
}

class Data {
  String? title;
  List<Solutions>? solutions;

  Data({this.title, this.solutions});

  Data.fromJson(Map<dynamic, dynamic> json) {
    title = json["title"];
    solutions = json["solutions"] == null
        ? null
        : (json["solutions"] as List)
            .map((e) => Solutions.fromJson(e))
            .toList();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    if (solutions != null) {
      data["solutions"] = solutions?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Solutions {
  String? solutionsTitle;
  List<ChildLinks>? childLinks;

  Solutions({this.solutionsTitle, this.childLinks});

  Solutions.fromJson(Map<dynamic, dynamic> json) {
    solutionsTitle = json["solutions_title"];
    childLinks = json["child_links"] == null
        ? null
        : (json["child_links"] as List)
            .map((e) => ChildLinks.fromJson(e))
            .toList();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data["solutions_title"] = solutionsTitle;
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
