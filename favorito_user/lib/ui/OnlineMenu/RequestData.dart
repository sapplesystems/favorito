class CatItem {
  String buId;
  int catId;
  String cat;
  String txt;
  List filter;
  int selectedCatId = 0;
  bool isVeg = false;
  CatItem(
      {this.buId,
      this.catId,
      this.cat,
      this.filter,
      this.txt,
      this.selectedCatId,
      this.isVeg});
}
