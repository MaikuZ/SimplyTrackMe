package com.example.piotrhelm.simplytrackme;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import java.util.Calendar;
import java.util.Timer;
import java.util.TimerTask;

public class Start extends AppCompatActivity {

    ///TODO:
    ///1) RETURNING TO THE PREVIOUS SCREEN NOT ALLOWED, UNTIL THE USER ENDS THE SESSION. IT SHALL THEN BE SAVED AS .JSON FILE
    ///IN THE INTERNAL STORAGE
    ///2) BACKUP EVERY n seconds. I.E. saving .json file
    ///3) ADD button to end session. Add text showing current stats.
    private Track currentTrack;
    private int MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start);
        final GPSTracker tracker = new GPSTracker(this);
        if(!tracker.isGPSOn) {
            tracker.showSettingsAlert();
        }
        // Here, thisActivity is the current activity
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {

            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this,
                    Manifest.permission.ACCESS_FINE_LOCATION)) {

                // Show an explanation to the user *asynchronously* -- don't block
                // this thread waiting for the user's response! After the user
                // sees the explanation, try again to request the permission.

            } else {

                // No explanation needed, we can request the permission.

                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                        MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION);

                // MY_PERMISSIONS_REQUEST_READ_CONTACTS is an
                // app-defined int constant. The callback method gets the
                // result of the request.
            }
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
        new Timer().scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                tracker.getLocation();
                currentTrack.addNode(tracker.getLat(),tracker.getLon(), Calendar.getInstance().getTime().getTime());
            }
        }, 0, 1000*1);//Time to continue;
    }
}
