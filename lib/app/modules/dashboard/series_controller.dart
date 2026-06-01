import 'package:cncours_quiz/app/core/controllers/crud_controller.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';

class SerieController extends CrudController<SerieResource, SerieResource> {
  SerieController()
      : super(
            resource: 'series',
            mE: (json) => SerieResource.fromJson(json),
            rE: (json) => SerieResource.fromJson(json));

  @override
  void onInit() {
    super.onInit();
    list(load: true);
  }
}
