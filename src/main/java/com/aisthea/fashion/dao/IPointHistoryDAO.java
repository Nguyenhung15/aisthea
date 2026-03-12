package com.aisthea.fashion.dao;

import com.aisthea.fashion.model.PointHistory;
import java.util.List;

public interface IPointHistoryDAO {
    void addPointHistory(PointHistory history);
    List<PointHistory> getPointHistoryByUserId(int userId);
}
