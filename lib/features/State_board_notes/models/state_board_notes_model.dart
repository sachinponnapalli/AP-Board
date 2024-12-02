class StateBoardNotesModel {
  String? mainTitle;
  List<Solutions>? solutions;

  StateBoardNotesModel({this.mainTitle, this.solutions});

  StateBoardNotesModel.fromJson(Map<String, dynamic> json) {
    mainTitle = json["mainTitle"];
    solutions = json["solutions"] == null
        ? null
        : (json["solutions"] as List)
            .map((e) => Solutions.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["mainTitle"] = mainTitle;
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

  Solutions.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    childLinks = json["child_links"] == null
        ? null
        : (json["child_links"] as List)
            .map((e) => ChildLinks.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

  ChildLinks.fromJson(Map<String, dynamic> json) {
    childTitle = json["child_title"];
    childHref = json["child_href"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["child_title"] = childTitle;
    data["child_href"] = childHref;
    return data;
  }
}
