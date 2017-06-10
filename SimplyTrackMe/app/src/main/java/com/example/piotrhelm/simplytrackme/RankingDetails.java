package com.example.piotrhelm.simplytrackme;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.widget.TextView;

public class RankingDetails extends AppCompatActivity {

    RankingElement element;
    TextView userField;
    TextView resultField;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ranking_details);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        userField = (TextView) findViewById(R.id.author);
        resultField = (TextView) findViewById(R.id.result);
        setSupportActionBar(toolbar);
        element = (RankingElement) this.getIntent().getSerializableExtra("rankdata");
        userField.setText(element.owner);
        resultField.setText(element.result);
    }

}
