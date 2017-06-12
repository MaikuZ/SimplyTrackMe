package com.example.piotrhelm.simplytrackme;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import java.sql.ResultSet;

public class RankingActivity extends AppCompatActivity {

    private ListView list;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ranking);
        list = (ListView) findViewById(R.id.rankListView);
        final Context c = this;

        DbOps.ProcessQuery(this, "SELECT * FROM ranking_distance(INTERVAL '1 month');", new DbOps.ResultOp() {
            @Override
            public void processResult(ResultSet rs) {
                final Ranking r = new Ranking(rs);
                list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                    public void onItemClick(AdapterView<?> parent, View view,
                                            int position, long id) {
                        Intent myIntent = new Intent(view.getContext(), RankingDetails.class);
                        myIntent.putExtra("rankdata", r.GetRankingData()[position]);
                        startActivityForResult(myIntent, 0);
                    }
                });
                RankingAdapter adapter = new RankingAdapter(c, R.layout.ranking_element, r.GetRankingData());
                list.setAdapter(adapter);
            }
        });
    }
}
