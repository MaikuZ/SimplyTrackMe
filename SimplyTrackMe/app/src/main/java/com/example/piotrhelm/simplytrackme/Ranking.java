package com.example.piotrhelm.simplytrackme;

import java.sql.ResultSet;
import java.util.ArrayList;

/**
 * Created by bartek on 10.06.17.
 */

public class Ranking {
    RankingElement rankData[] = { new RankingElement("wrong", "wrong")};
    public interface RankingOp {
        public void run(Ranking r);
    };
    Ranking(ResultSet rs) {
        try {
            ArrayList<RankingElement> array = new ArrayList<>();
            rankData = new RankingElement[rs.getFetchSize()];
            while (rs.next()) {
                array.add(new RankingElement(rs.getString(2), rs.getString(1)));
            }
            rankData = array.toArray(rankData);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public RankingElement[] GetRankingData() {
        return rankData;
    }
}
