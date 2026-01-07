enum MODELS_TYPE { THOME, TADV, TNEWS, TSLIDER }

abstract class BaseModel extends Object {
  fromJson(Map<String, dynamic> json);

  BaseModel();
}
