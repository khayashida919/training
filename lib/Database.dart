/*Model*/
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TrainingModel {
  final String title;
  final String date;
  final int trainingTime;
  final int intervalTime;
  final int repeatTime;
  final String hanyou1;
  final String hanyou2;
  final String hanyou3;

  TrainingModel(this.title, this.date, this.trainingTime, this.intervalTime,
      this.repeatTime, this.hanyou1, this.hanyou2, this.hanyou3);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'trainingTime': trainingTime,
      'intervalTime': intervalTime,
      'repeatTime': repeatTime,
      'hanyou1': hanyou1,
      'hanyou2': hanyou2,
      'hanyou3': hanyou3,
    };
  }
}

class TrainingSetModel {
  final String title;
  final int trainingTime;
  final int intervalTime;
  final int repeatTime;
  int isEnable;
  final String hanyou1;
  final String hanyou2;
  final String hanyou3;

  TrainingSetModel(this.title, this.trainingTime, this.intervalTime,
      this.repeatTime, this.isEnable, this.hanyou1, this.hanyou2, this.hanyou3);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'trainingTime': trainingTime,
      'intervalTime': intervalTime,
      'repeatTime': repeatTime,
      'isEnable': isEnable,
      'hanyou1': hanyou1,
      'hanyou2': hanyou2,
      'hanyou3': hanyou3,
    };
  }
}

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();
  Database _instance;

  String get databaseName => "database.db";
  String get tableName => "training";
  String get trainingSetTableName => "trainingSet";

  Future<Database> get database async {
    if (_instance == null) {
      _instance = await openDatabase(
        join(
          await getDatabasesPath(),
          databaseName,
        ),
        onCreate: createDatabase,
        version: 1,
      );
    }
    return _instance;
  }

  createDatabase(Database db, int version) {
    db.execute(
        '''
            CREATE TABLE $tableName
              (
                title TEXT,
                date TEXT INTEGER PRIMARY KEY,
                trainingTime INTEGER,
                intervalTime INTEGER,
                repeatTime INTEGER,
                hanyou1 TEXT,
                hanyou2 TEXT,
                hanyou3 TEXT
              )
      '''
    );

    db.execute(
        '''
            CREATE TABLE $trainingSetTableName
              (
                title TEXT PRIMARY KEY,
                trainingTime INTEGER,
                intervalTime INTEGER,
                repeatTime INTEGER,
                isEnable INTEGER,
                hanyou1 TEXT,
                hanyou2 TEXT,
                hanyou3 TEXT
              )
      '''
    );
  }

  Future<List<TrainingModel>> getTrainingModels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('$tableName');
    return List.generate(maps.length, (i) {
      return TrainingModel(
        maps[i]['title'],
        maps[i]['date'],
        maps[i]['trainingTime'],
        maps[i]['intervalTime'],
        maps[i]['repeatTime'],
        maps[i]['hanyou1'], maps[i]['hanyou2'], maps[i]['hanyou3'],
      );
    });
  }

  Future<List<TrainingSetModel>> getTrainingSetModels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('$trainingSetTableName');
//    if(maps.isEmpty) {
//      return null;
//    }
    List<TrainingSetModel> temp =  List.generate(maps.length, (i) {
      return TrainingSetModel(
        maps[i]['title'],
        maps[i]['trainingTime'],
        maps[i]['intervalTime'],
        maps[i]['repeatTime'],
        maps[i]['isEnable'],
        maps[i]['hanyou1'], maps[i]['hanyou2'], maps[i]['hanyou3'],
      );
    });
    print(temp);
    return temp;
  }

  /*
  *   渡したモデルを有効フラグオンに、それ以外はオフにしてDBに保存
  * */
  void updateSetModels(TrainingSetModel trainingSetModel) async {
    final List<TrainingSetModel> models = await getTrainingSetModels();
    final db = await database;

    if(models.contains(trainingSetModel.title)) {   //同じ名前のトレーニングセットが既に登録されている場合
      final List<TrainingSetModel> offModels = models.map((e) {
        e.isEnable = e.title == trainingSetModel.title ? 1 : 0;
        return e;
      }).toList();

      offModels.forEach((element) {
        db.update('$trainingSetTableName',
            element.toMap(),
            where: "title = ?",
            whereArgs: [element.title],
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    } else {  //トレーニングセットが一つも登録されてなかった場合
      //TODO: フラグがONのモデルが複数存在してしまう
      await db.insert(
          DbProvider.db.trainingSetTableName,
          trainingSetModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

}



