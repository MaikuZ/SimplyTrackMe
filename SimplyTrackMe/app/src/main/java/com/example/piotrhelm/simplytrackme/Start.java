package com.example.piotrhelm.simplytrackme;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;

import java.util.Calendar;

public class Start extends AppCompatActivity {

    ///TODO:
    ///1) RETURNING TO THE PREVIOUS SCREEN NOT ALLOWED, UNTIL THE USER ENDS THE SESSION. IT SHALL THEN BE SAVED AS .JSON FILE
    ///IN THE INTERNAL STORAGE DONE!
    ///2) BACKUP EVERY n seconds. I.E. saving .json file
    ///3) ADD button to end session. Add text showing current stats. WIP.
    private Track currentTrack;
    private Thread GPSUpdater;
    private int MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION;
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        return;
    }
    private void updateTextView(String newText,TextView textView) {
        textView.setText(newText);
    }
    @Override
    public void onBackPressed() {
        moveTaskToBack(true);///Disables returning to the main menu.
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start);
        final TextView currentStats = (TextView)findViewById(R.id.textView);
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
            alertDialog.setTitle("GPS location");
            alertDialog.setMessage("Current Lat: " + tracker.getLat() + "Current Lon: " + tracker.getLon());
            alertDialog.show();
        }
        currentTrack = new Track();
        currentTrack.setOwner(new Person(
                PreferenceManager.getDefaultSharedPreferences(this).getString("person_name", "none"),
                PreferenceManager.getDefaultSharedPreferences(this).getString("user_name", "none"),
                Integer.parseInt(PreferenceManager.getDefaultSharedPreferences(this).getString("person_age", "0")),
                Integer.parseInt(PreferenceManager.getDefaultSharedPreferences(this).getString("person_height", "0")),
                Integer.parseInt(PreferenceManager.getDefaultSharedPreferences(this).getString("person_weight", "0"))
        ));
        GPSUpdater = new Thread() {
            @Override
            public void run() {
                try {
                    while (!isInterrupted()) {
                        Thread.sleep(1000*1);
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                tracker.getUpdatedLocation();
                                currentTrack.addNode(tracker.getLat(),tracker.getLon(), Calendar.getInstance().getTime().getTime(),tracker.getAltitude());
                                updateTextView("Current Distance: " +
                                        currentTrack.getTotalDistance()/1000 + " km" + "\n" +
                                        "Current Location: " + tracker.getUpdatedLocation() + "\n" +
                                        "Current altitude: " + tracker.getAltitude() + "\n"+
                                        "Elapsed time: " + (Calendar.getInstance().getTime().getTime() - currentTrack.getStart_date())/1000/60 +"minutes"+"\n"+
                                        "Average speed: " + (currentTrack.getTotalDistance()/1000)/(Calendar.getInstance().getTime().getTime() - currentTrack.getStart_date())*1000*60*60 + "km/h",currentStats
                                );
                            }
                        });
                    }
                } catch (InterruptedException e) {
                }
            }
        };
        GPSUpdater.start();
    }
    public void endSession(View view) {
        moveTaskToBack(false);
        currentTrack.setEnd_date(currentTrack.getStart_date() + currentTrack.getLast().getTime_elapsed());
        currentTrack.saveToFile(this);
        GPSUpdater.interrupt();

        Intent myIntent = new Intent(view.getContext(), trackDetailsView.class);
        myIntent.putExtra("fileName", currentTrack.getID() + ".json");
        startActivityForResult(myIntent, 0);
        finish();
    }
}
