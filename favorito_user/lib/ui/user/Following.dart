import 'package:favorito_user/component/FavoriteBtn.dart';
import 'package:favorito_user/component/FollowBtn.dart';
import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/user/ProfileProvider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class FollowingUser extends StatelessWidget {
  ProfileProvider vaTrue;
  ProfileProvider vaFalse;
  SizeManager sm;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      sm = SizeManager(context);
      vaTrue = Provider.of<ProfileProvider>(context, listen: true);
      vaFalse = Provider.of<ProfileProvider>(context, listen: false);
      vaTrue.getFollowing();
      isFirst = false;
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(vaTrue.followPageTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          vaTrue.getFollowing();
        },
        child: ListView(
            children: vaTrue
                .getFollowingData()
                .map((e) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: sm.w(20),
                              padding:
                                  EdgeInsets.symmetric(horizontal: sm.w(2)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Container(
                                      height: sm.h(8),
                                      // width: sm.h(8),
                                      child: ImageMaster(
                                          url: e.photo ??
                                              'data:image/jpeg;base64,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'))),
                            ),
                            Expanded(
                              child: Text(
                                e.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                            // Container(//notifier is not working here
                            //     child: FollowBtn(
                            //   id: e.targetId,
                            //   callback: () {
                            //     isFirst = true;
                            //     vaTrue.abc();
                            //   },
                            // )),
                          ],
                        ),
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
