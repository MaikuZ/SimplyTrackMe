package com.example.piotrhelm.simplytrackme;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.provider.Settings;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class Start extends AppCompatActivity {

    Track currentTrack;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start);
        GPSTracker tracker = new GPSTracker(this);
        if(!tracker.isGPSOn) {
            tracker.showSettingsAlert();
        }
        tracker.getLocation();

        {///Alert with current location
            AlertDialog.Builder alertDialog = new AlertDialog.Builder(this);
            // Setting Dialog Title
            alertDialog.setTitle("GPS location");

            // Setting Dialog Message
            alertDialog.setMessage("Current Lat: " + tracker.getLat() + "Current Lon: " + tracker.getLon());

            // Setting Icon to Dialog
            //alertDialog.setIcon(R.drawable.delete);


            // Showing Alert Message
            alertDialog.show();
        }
        currentTrack = new Track();

    }
}
