package com.example.piotrhelm.simplytrackme;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RankingActivity extends AppCompatActivity {

    private ListView list;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ranking);
        list = (ListView) findViewById(R.id.rankListView);
        final Context c = this;
        DbOps.GetRanking(this, new Ranking.RankingOp() {
            @Override
            public void run(final Ranking r) {
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
