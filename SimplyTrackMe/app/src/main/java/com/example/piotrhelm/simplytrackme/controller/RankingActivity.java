package com.example.piotrhelm.simplytrackme.controller;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

import com.example.piotrhelm.simplytrackme.R;
import com.example.piotrhelm.simplytrackme.model.DbOps;
import com.example.piotrhelm.simplytrackme.model.Ranking;

import java.sql.ResultSet;

public class RankingActivity extends AppCompatActivity {

    private ListView list;
    private Spinner spinner;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ranking);
        list = (ListView) findViewById(R.id.rankListView);
        spinner = (Spinner)findViewById(R.id.ranking_spinner);
        ArrayAdapter<CharSequence> ad = ArrayAdapter.createFromResource(this,
                R.array.rankings, android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(ad);
        final Context c = this;

        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                final Context c = RankingActivity.this;
                if (position == 0) {
                    DbOps.ProcessQuery(RankingActivity.this, "SELECT * FROM ranking_distance(INTERVAL '1 month') limit 9;", new DbOps.ResultOp() {
                        @Override
                        public void processResult(ResultSet rs) {
                            final Ranking r = new Ranking(rs, " km");
                            list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                public void onItemClick(AdapterView<?> parent, View view,
                                                        int position, long id) {
                                    Intent myIntent = new Intent(view.getContext(), RankingDetailsActivity.class);
                                    myIntent.putExtra("rankdata", r.GetRankingData()[position]);
                                    startActivityForResult(myIntent, 0);
                                }
                            });
                            RankingAdapter adapter = new RankingAdapter(RankingActivity.this, R.layout.ranking_element, r.GetRankingData());
                            list.setAdapter(adapter);
                        }
                    });
                } else if (position == 1) {
                    String sql = "SELECT u.user_name, distance " +
                        "FROM simplytrackme.sessions JOIN simplytrackme.users u ON sessions.id_owner = u.id_user" +
                        " ORDER BY distance DESC limit 9;";
                    DbOps.ProcessQuery(RankingActivity.this, sql, new DbOps.ResultOp() {
                        @Override
                        public void processResult(ResultSet rs) {
                            final Ranking r = new Ranking(rs, " km");
                            list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                public void onItemClick(AdapterView<?> parent, View view,
                                                        int position, long id) {
                                    Intent myIntent = new Intent(view.getContext(), RankingDetailsActivity.class);
                                    myIntent.putExtra("rankdata", r.GetRankingData()[position]);
                                    startActivityForResult(myIntent, 0);
                                }
                            });
                            RankingAdapter adapter = new RankingAdapter(RankingActivity.this, R.layout.ranking_element, r.GetRankingData());
                            list.setAdapter(adapter);
                        }
                    });
                } else {
                    String sql = "SELECT u.user_name, s.elevation*1000 " +
                            "FROM simplytrackme.sessions s JOIN simplytrackme.users u ON s.id_owner = u.id_user" +
                            " ORDER BY s.elevation DESC limit 9;";
                    DbOps.ProcessQuery(RankingActivity.this, sql, new DbOps.ResultOp() {
                        @Override
                        public void processResult(ResultSet rs) {
                            final Ranking r = new Ranking(rs, " metres");
                            list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                public void onItemClick(AdapterView<?> parent, View view,
                                                        int position, long id) {
                                    Intent myIntent = new Intent(view.getContext(), RankingDetailsActivity.class);
                                    myIntent.putExtra("rankdata", r.GetRankingData()[position]);
                                    startActivityForResult(myIntent, 0);
                                }
                            });
                            RankingAdapter adapter = new RankingAdapter(RankingActivity.this, R.layout.ranking_element, r.GetRankingData());
                            list.setAdapter(adapter);
                        }
                    });
                }

            }
            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }
    private static class RankingAdapter extends ArrayAdapter<RankingElement> {
        Context context;
        int layoutResourceId;
        RankingElement elements[] = {};

        public RankingAdapter(@NonNull Context context, @LayoutRes int resource, @NonNull RankingElement[] objects) {
            super(context, resource, objects);
            this.layoutResourceId = resource;
            this.context = context;
            this.elements = objects;
        }

        @Override
        public View getView(int pos, View convertView, ViewGroup parent) {
            View row = convertView;
            RankingElementHolder holder = null;

            if (row == null) {
                LayoutInflater inflater = ((Activity) context).getLayoutInflater();
                row = inflater.inflate(layoutResourceId, parent, false);

                holder = new RankingElementHolder();
                holder.title = (TextView) row.findViewById(R.id.rankTitle);
                holder.subtitle = (TextView) row.findViewById(R.id.rankSubtitle);

                row.setTag(holder);
            } else {
                holder = (RankingElementHolder) row.getTag();
            }

            RankingElement object = elements[pos];
            holder.title.setText(object.owner);
            holder.subtitle.setText(object.result);

            return row;
        }
        static class RankingElementHolder {
            TextView title;
            TextView subtitle;
        }
    }
}
