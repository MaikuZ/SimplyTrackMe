package com.example.piotrhelm.simplytrackme;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.provider.Settings;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class Main extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void goToHistory(View view) {
        Intent intent = new Intent(this, History.class);
        startActivity(intent);
    }

    public void goToProfile(View view) {
        Intent intent = new Intent(this, Profile.class);
        startActivity(intent);
    }

    public void goToStart(View view) {
        GPSTracker tracker = new GPSTracker(this);
        if(!tracker.isGPSOn) {
            tracker.showSettingsAlert();
        }
        if(tracker.isGPSOn) {
            Intent intent = new Intent(this, Start.class);
            startActivity(intent);
        }
    }

    public void goToSettings(View view) {
        Intent intent = new Intent(this, Settings.class);
        startActivity(intent);
    }

}
