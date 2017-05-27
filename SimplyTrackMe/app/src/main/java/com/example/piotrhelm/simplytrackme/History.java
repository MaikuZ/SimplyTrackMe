package com.example.piotrhelm.simplytrackme;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import static java.lang.StrictMath.max;
public class History extends AppCompatActivity {

    private ListView list;
    private ArrayAdapter<Track> adapter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history);

        list = (ListView) findViewById(R.id.listView1);
        final ArrayList<Track> trackList = new ArrayList<Track>();

        final String[] listOfFiles = getFilesDir().list();
        for(String x: listOfFiles){
            if(x.endsWith(".json")) {
                String id = x.substring(0,x.length() - ".json".length());
                Track.lastID = max(Track.lastID, Integer.parseInt(id)+1);
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
                Intent myIntent = new Intent(view.getContext(), trackDetailsView.class);
                myIntent.putExtra("fileName", trackList.get((int)id).getID() + ".json");
                startActivityForResult(myIntent, 0);
            }
        });
        adapter = new ArrayAdapter<Track>(this, R.layout.row_history, trackList);
        list.setAdapter(adapter);
    }
}
