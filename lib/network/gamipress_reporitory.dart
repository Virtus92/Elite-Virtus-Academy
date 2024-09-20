import 'package:socialv/models/gamipress/common_gamipress_model.dart';
import 'package:socialv/models/gamipress/rewards_model.dart';
import 'package:socialv/network/network_utils.dart';
import 'package:socialv/utils/app_constants.dart';

Future<List<CommonGamiPressModel>> badgesList({int page = 1}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.badges}?page=$page&per_page=$PER_PAGE', method: HttpMethod.GET));
  return it.map((e) => CommonGamiPressModel.fromJson(e)).toList();
}

Future<List<CommonGamiPressModel>> levelsList({int page = 1}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.levels}?page=$page&per_page=$PER_PAGE', method: HttpMethod.GET));
  return it.map((e) => CommonGamiPressModel.fromJson(e)).toList();
}

Future<RewardsModel> rewards({required int userID}) async {
  return RewardsModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.gamipressEndPoint}/$userID/${APIEndPoint.earningsEndPoint}')));
}

Future<List<Rank>> userAchievements({required int userID, int page = 1}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.gamipressEndPoint}/$userID/${APIEndPoint.achievementEndPoint}/&page=$page&per_page=$PER_PAGE', method: HttpMethod.GET));
  return it.map((e) => Rank.fromJson(e)).toList();
}
