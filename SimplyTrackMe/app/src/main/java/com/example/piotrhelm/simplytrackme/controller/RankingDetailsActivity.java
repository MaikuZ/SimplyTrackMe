package com.example.piotrhelm.simplytrackme.controller;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

import com.example.piotrhelm.simplytrackme.R;

public class RankingDetailsActivity extends AppCompatActivity {

    RankingElement element;
    TextView userField;
    TextView resultField;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ranking_details);
//        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        userField = (TextView) findViewById(R.id.author);
        resultField = (TextView) findViewById(R.id.result);
//        setSupportActionBar(toolbar);
        element = (RankingElement) this.getIntent().getSerializableExtra("rankdata");
        userField.setText(element.owner);
        resultField.setText(element.result);
    }

}
