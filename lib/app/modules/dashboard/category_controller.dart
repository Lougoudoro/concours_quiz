import 'package:cncours_quiz/app/core/controllers/crud_controller.dart';
import 'package:cncours_quiz/app/data/resources/category_resource.dart';

class CategoryController extends CrudController<CategoryResource, CategoryResource>
{
  CategoryController():super(resource: 'categories', mE:(json)=>CategoryResource.fromJson(json),rE:(json)=>CategoryResource.fromJson(json));

  @override
  void onInit() {
    super.onInit();
    list();
  }
}