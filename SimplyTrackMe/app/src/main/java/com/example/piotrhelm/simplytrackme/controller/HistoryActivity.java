package com.example.piotrhelm.simplytrackme.controller;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.example.piotrhelm.simplytrackme.R;
import com.example.piotrhelm.simplytrackme.model.Track;
import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.util.ArrayList;

import static java.lang.StrictMath.max;
public class HistoryActivity extends AppCompatActivity {

    private ListView list;
    private ArrayAdapter<Track> adapter;
    private void startListView(){//Used to start or refresh listView
        list = (ListView) findViewById(R.id.listView1);
        final ArrayList<Track> trackList = new ArrayList<Track>();

        final String[] listOfFiles = getFilesDir().list();
        for(String x: listOfFiles){
            if(x.endsWith(".json")) {
                String id = x.substring(0,x.length() - ".json".length());
                Track.setLastID(max(Track.getLastID(), Integer.parseInt(id)+1));
                String fileName = x;
                FileInputStream inputStream = null;
                try {
                    inputStream = openFileInput(fileName);
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                }
                BufferedReader r = new BufferedReader(new InputStreamReader(inputStream));
                StringBuilder total = new StringBuilder();
                String line = new String();
                try {
                    while ((line = r.readLine()) != null) {
                        total.append(line);
                    }
                    r.close();
                    inputStream.close();
                }
                catch (Exception e)
                {
                    e.printStackTrace();
                }
                Track currentTrack = new Gson().fromJson(total.toString(),Track.class);
                trackList.add(currentTrack);
            }
        }

        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                Intent myIntent = new Intent(view.getContext(), TrackDetailsActivity.class);
                myIntent.putExtra("fileName", trackList.get((int)id).getID() + ".json");
                startActivityForResult(myIntent, 0);
            }
        });
        adapter = new ArrayAdapter<Track>(this, R.layout.row_history, trackList);
        list.setAdapter(adapter);
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history);
        startListView();///To start for the first time
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        startListView();///To refresh - because some entries might be deleted.
    }
}
