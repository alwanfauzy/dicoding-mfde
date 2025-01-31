import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertTv(TvTable tv);
  Future<String> removeTv(TvTable tv);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getTvList();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertTv(TvTable tv) async {
    try {
      await databaseHelper.insertTv(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTv(TvTable tv) async {
    try {
      await databaseHelper.removeTv(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getTvById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getTvList() async {
    final result = await databaseHelper.getTvList();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }
}
