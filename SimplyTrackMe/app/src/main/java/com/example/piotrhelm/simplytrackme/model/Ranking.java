package com.example.piotrhelm.simplytrackme.model;

import com.example.piotrhelm.simplytrackme.controller.RankingElement;

import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.util.ArrayList;

/**
 * Created by bartek on 10.06.17.
 */

public class Ranking {
    RankingElement rankData[] = { new RankingElement("wrong", "wrong")};
    public Ranking(ResultSet rs, String postfix) {
        try {
            ArrayList<RankingElement> array = new ArrayList<>();
            rankData = new RankingElement[rs.getFetchSize()];
            while (rs.next()) {
                float metres = rs.getInt(2);
                String result = new DecimalFormat("#0.0").format(Double.valueOf(metres/1000));
                array.add(new RankingElement(rs.getString(1), result + postfix));
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
