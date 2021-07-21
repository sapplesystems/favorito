import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/model/RatingModel.dart';
import 'package:favorito_user/model/appModel/Review/ReviewListModel.dart';
import 'package:favorito_user/model/appModel/Review/ReviewModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class ReviewProvider extends BaseProvider {
  TextEditingController controller = TextEditingController();
  List<ReviewData1> reviewData1 = [];
  String _selectedReviewId = "null";
  String _rootId = "null";
  double myRating = 3.0;
  String businessId;
  List<double> ratingPoints = [0.0, 0.0, 0.0, 0.0, 0.0];
  List<Reviewdata> reviewModel = [];
  RatingData _ratingDatas = RatingData();
  void businessSetReview(context) async {
    print("aaa:${_selectedReviewId}");
    Map _map = {
      'business_id': businessId,
      "review": controller.text,
      "parent_id":
          (_selectedReviewId != "null" && int.parse(_selectedReviewId) > 0)
              ? reviewModel.last.id
              : _selectedReviewId,
      'b_to_u': 0
    };
    print("_map:${_map.toString()}");

    await APIManager.businessSetReview(_map).then((value) {
      if (_selectedReviewId == "null") {
        Navigator.pop(context);
        Navigator.pop(context);
      }

      Navigator.pop(context);
      controller.text = "";
      setRating();

      getReviewReplies();
    });
  }

  clearSelectedReviewId() {
    _selectedReviewId = '0';
    notifyListeners();
  }

  void getReviewListing(BuildContext context) async {
    await APIManager.getReviewListing({'business_id': businessId}, context)
        .then((value) {
      reviewData1.clear();
      if (value.status == 'success') {
        reviewData1.addAll(value.data);
        getMyRating();
      }
    });
  }

  List<ReviewData1> getAllreviewsListForUi() => reviewData1;

  setRootId(String _id) {
    _rootId = _id;
    getReviewReplies();
  }

  void getReviewReplies() async {
    print("_rootId:$_rootId");
    if (_rootId != null)
      await APIManager.getReviewReplies(
          {"business_id": businessId, "review_id": _rootId}).then((value) {
        if (value.status == 'success') {
          reviewModel?.clear();
          reviewModel.addAll(value.data);
          _selectedReviewId = reviewModel.last.id.toString();
        }
        notifyListeners();
      });
  }

  pastReviewed() {
    bool val = false;
    for (var v in reviewData1) {
      if (v.self == 1) {
        val = true;
        break;
      }
    }
    print("Past:$val");
    return val;
  }

  getSelectedReviewId() => _rootId == "null";

  // @override
  // setBusinessId(String _val) {
  //   return super.setBusinessId(_val);
  // }

  void getrating() async {
    Map _map = {"business_id": businessId};
    print("getrating:${_map.toString()}");
    await APIManager.getrating(_map).then((value) {
      _ratingDatas = value.data;
      ratingPoints[0] = (value.data?.ratingsByPoints?.rating1 ?? 0) / 10;
      ratingPoints[1] = (value.data?.ratingsByPoints?.rating2 ?? 0) / 10;
      ratingPoints[2] = (value.data?.ratingsByPoints?.rating3 ?? 0) / 10;
      ratingPoints[3] = (value.data?.ratingsByPoints?.rating4 ?? 0) / 10;
      ratingPoints[4] = (value.data?.ratingsByPoints?.rating5 ?? 0) / 10;
      getMyRating();
    });
  }

  RatingData getRatingData() => _ratingDatas;

  void setRating() async {
    Map _map = {'business_id': businessId, 'rating': myRating};
    print('ratMap:${_map.toString()}');
    await APIManager.setRating(_map).then((value) {
      BotToast.showText(text: value.message);
      getMyRating();
    });
  }

  void getMyRating() async {
    Map _map = {'business_id': businessId};
    print("_map${_map.toString()}");
    await APIManager.getMyRating(_map).then((value) {
      myRating = double.parse('${value.data[0].rating}');
      notifyListeners();
    });
  }

  getCurrentBusinessId(context) {
    businessId = Provider.of<BusinessProfileProvider>(context, listen: false)
        .getBusinessId();
  }
}
