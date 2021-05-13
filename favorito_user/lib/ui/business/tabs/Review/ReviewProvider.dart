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
  String rating = '3.0';
  String businessId;
  List<double> ratingPoints = [0.0, 0.0, 0.0, 0.0, 0.0];
  List<Reviewdata> reviewModel = [];
  RatingData _ratingData = RatingData();
  void businessSetReview(context) async {
    Map _map = {
      'business_id': businessId,
      // 'business_id': 'KIR4WQ4N7KF697HRQ',
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
      }
      controller.text = "";

      getReviewReplies();
    });
  }

  void getReviewListing(BuildContext context) async {
    await APIManager.getReviewListing({'business_id': businessId}, context)
        .then((value) {
      reviewData1.clear();
      if (value.status == 'success') {
        reviewData1.addAll(value.data);
        notifyListeners();
      }
    });
  }

  List<ReviewData1> getAllreviewsListForUi() => reviewData1;

  setRootId(String _id) {
    _rootId = _id;
    getReviewReplies();
  }

  void getReviewReplies() async {
    if (_rootId != "null")
      await APIManager.getReviewReplies({
        "business_id": businessId,
        // "business_id": 'KIR4WQ4N7KF697HRQ',
        "review_id": _rootId
      }).then((value) {
        if (value.status == 'success') {
          reviewModel?.clear();
          reviewModel.addAll(value.data);
          _selectedReviewId = reviewModel.last.id.toString();
        }
        notifyListeners();
      });
  }

  getSelectedReviewId() => _rootId == "null";

  // @override
  // setBusinessId(String _val) {
  //   return super.setBusinessId(_val);
  // }

  void getrating() async {
    Map _map = {"business_id": businessId};
    await APIManager.getrating(_map).then((value) {
      _ratingData = value.data;
      ratingPoints[0] = value.data.ratingsByPoints.rating1 / 10;
      ratingPoints[1] = value.data.ratingsByPoints.rating2 / 10;
      ratingPoints[2] = value.data.ratingsByPoints.rating3 / 10;
      ratingPoints[3] = value.data.ratingsByPoints.rating4 / 10;
      ratingPoints[4] = value.data.ratingsByPoints.rating5 / 10;
      notifyListeners();
    });
  }

  RatingData getRatingData() => _ratingData;

  void setRating() async {
    Map _map = {'business_id': businessId, 'rating': rating};
    print('ratMap:${_map.toString()}');
    await APIManager.setRating(_map).then((value) {
      BotToast.showText(text: value.message);
    });
  }

  void getRating() async {
    Map _map = {'business_id': businessId};
    await APIManager.getRating(_map).then((value) {
      rating = '${value.data[0].rating}';
    });
  }

  getCurrentBusinessId(context) {
    businessId = Provider.of<BusinessProfileProvider>(context, listen: true)
        .getBusinessId();
  }
}
