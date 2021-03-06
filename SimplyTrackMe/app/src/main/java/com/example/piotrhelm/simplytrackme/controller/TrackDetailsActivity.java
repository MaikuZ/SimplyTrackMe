package com.example.piotrhelm.simplytrackme.controller;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;

import com.example.piotrhelm.simplytrackme.R;
import com.example.piotrhelm.simplytrackme.model.DbOps;
import com.example.piotrhelm.simplytrackme.model.Track;
import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;

public class TrackDetailsActivity extends AppCompatActivity {

    Track currentTrack;
    private void updateTextView(String newText,TextView textView) {
        textView.setText(newText);
    }
    public void goToMapsView(View view) {
        Intent intent = new Intent(this, MapsActivity.class);
        MapsActivity.trackToShow = currentTrack;
        startActivity(intent);
    }

    public void onPopFromServer(View view){
        DbOps.DeleteTrack(this, currentTrack);
    }
    @SuppressLint("NewApi")
    public void onDeleteLocally(View view) {
        File f = new File(this.getFilesDir(),currentTrack.getID() + ".json");
        AlertDialog.Builder alertDialog = new AlertDialog.Builder(this);
        if(f.delete()) {
            alertDialog.setTitle("File deleted");
            alertDialog.setMessage("Deleted.");
        }
        else {
            alertDialog.setTitle("File not deleted");
            alertDialog.setMessage("Couldn't delete.");
        }
        alertDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                finish();
            }
        });
        alertDialog.show();
    }

    public void onSendToServer(View view) {
        DbOps.UploadTrack(this, currentTrack);
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
        String line;
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
        updateTextView(currentTrack.toStringDetailed()
                ,textViewDetailed);
    }
}
