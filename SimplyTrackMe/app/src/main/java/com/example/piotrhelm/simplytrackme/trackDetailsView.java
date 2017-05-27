package com.example.piotrhelm.simplytrackme;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;

import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;

public class trackDetailsView extends AppCompatActivity {

    Track currentTrack;
    private void updateTextView(String newText,TextView textView) {
        textView.setText(newText);
    }
    public void goToMapsView(View view) {
        Intent intent = new Intent(this, MapsActivity.class);
        MapsActivity.trackToShow = currentTrack;
        startActivity(intent);
    }
    public void onSendToServer(View view) {
        DbOps.referenceToApp = this;
        DbOps.UploadTrack(currentTrack);
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_track_details_view);
        String fileName = this.getIntent().getStringExtra("fileName");
        ///reading .json file to currentTrack
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
        currentTrack = new Gson().fromJson(total.toString(),Track.class);
        ///.json file read.

        final TextView textViewDetailed = (TextView)findViewById(R.id.textView2);
        updateTextView(currentTrack.toString()
                ,textViewDetailed);
    }
}
