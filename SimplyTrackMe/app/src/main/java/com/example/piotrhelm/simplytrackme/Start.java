package com.example.piotrhelm.simplytrackme;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentActivity;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.PolylineOptions;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;

public class Start extends FragmentActivity implements OnMapReadyCallback {

    private GoogleMap mMap;
    private Thread GPSUpdater;
    private Marker currentMarker = null;
    private Track currentTrack = null;
    
    private int MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION;

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        return;
    }//Necessary

    private void updateTextView(String newText,TextView textView) {
        textView.setText(newText);
    }
    @Override
    public void onBackPressed() {
        moveTaskToBack(true);///Disables returning to the main menu.
    }
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start);

        //This is code for loading mapFragment
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        //This is the textView that show currentStats
        final TextView currentStats = (TextView)findViewById(R.id.textView);

        //New instance of GPSTracker, a class that gives data from gps module.
        final GPSTracker tracker = new GPSTracker(this);


        if(!tracker.isGPSOn) {
            tracker.showSettingsAlert();
        }

        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {

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
            }
        }
        int permissionCheck = ContextCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION);
        //We check if the permission for GPS was granted

        if(permissionCheck == PackageManager.PERMISSION_DENIED)
        {
            Toast.makeText(this,"No permission for gps. Please permit it.",Toast.LENGTH_SHORT).show();
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                    MY_PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION);
            //We stop it
            updateTextView("You didn't allow the use of GPS.\nTo track your activity this application " +
                    "needs the access to GPS.\nPlease allow it and then click the red button to go back to main Activity."
            , currentStats);
            return;
        }
        tracker.getLocation();
        currentTrack = new Track();//createNewTrack
        currentTrack.setOwner(new Person(
                PreferenceManager.getDefaultSharedPreferences(this).getString("person_name", "none"),
                PreferenceManager.getDefaultSharedPreferences(this).getString("user_name", "none"),
                Integer.parseInt(PreferenceManager.getDefaultSharedPreferences(this).getString("person_age", "0")),
                Integer.parseInt(PreferenceManager.getDefaultSharedPreferences(this).getString("person_height", "0")),
                Integer.parseInt(PreferenceManager.getDefaultSharedPreferences(this).getString("person_weight", "0"))
        ));
        currentTrack.setTrainingType(this.getIntent().getIntExtra("training_type", 0));

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
                                if(tracker.isPossibleGetLocation())
                                if(tracker.getLocation() != null) {
                                    currentTrack.addNode(tracker.getLat(), tracker.getLon(), Calendar.getInstance().getTime().getTime(), tracker.getAltitude());
                                    updateTextView("Current Distance: "
                                            + new DecimalFormat("#0.0").format(currentTrack.getTotalDistance() / 1000) + " km" + "\n"
                                            + "Current altitude: " + tracker.getAltitude() + "\n"
                                            + "Elapsed time: " + (Calendar.getInstance().getTime().getTime() - currentTrack.getStart_date()) / 1000 / 60 + " minutes" + "\n"
                                            + "Average speed: " + new DecimalFormat("#0.0").format((currentTrack.getTotalDistance() / 1000) / (Calendar.getInstance().getTime().getTime() - currentTrack.getStart_date()) * 1000 * 60 * 60) + " km/h"
                                            , currentStats);
                                    if(currentTrack.getList().size() >= 1)//Update the map only if there is at least one node
                                        onUptadeMap();
                                }
                            }
                        });
                    }
                } catch (InterruptedException e) {
                }
            }
        };
        GPSUpdater.start();
    }

    //This is executed each time the list in currentTrack is updated
    //I.E. there is a new node => we need to add the line between last 2 nodes
    public void onUptadeMap(){
        ArrayList<Track.Node> Temp = currentTrack.getList();
        ArrayList<LatLng> List = new ArrayList<>();

        //We add at most 2 nodes to the list. 2 last nodes.
        //This is different than in MapsActivity where we add all nodes at once, because
        //this function is called each update in the currentTrack list is made
        for(int i = Temp.size()-2; i < Temp.size(); i++) {
            if(i < 0)
                continue;
            LatLng e = new LatLng(Temp.get(i).getLat(), Temp.get(i).getLon());
            List.add(e);
        }

        LatLng marker = new LatLng(currentTrack.getLast().getLat(),currentTrack.getLast().getLon());
        if(currentMarker != null) {///Remove last marker
            currentMarker.remove();
            currentMarker = null;
        }
        currentMarker = mMap.addMarker(new MarkerOptions().position(marker).title("You're here."));


        PolylineOptions polylineOptions = new PolylineOptions();

        // Create polyline options with existing LatLng ArrayList
        polylineOptions.addAll(List);
        polylineOptions
                .width(5)
                .color(Color.RED);

        mMap.addPolyline(polylineOptions);
        mMap.moveCamera(CameraUpdateFactory.zoomTo(15.0f));
        mMap.moveCamera(CameraUpdateFactory.newLatLng(marker));
    }

    public void endSession(View view) {
        moveTaskToBack(false);
        if(currentTrack == null || currentTrack.getList().size() < 2) {//current track needs to have at least 2 points.
            finish();
            return;
        }

        currentTrack.setEnd_date(currentTrack.getStart_date() + currentTrack.getLast().getTime_elapsed());
        currentTrack.saveToFile(this);
        GPSUpdater.interrupt();

        Intent myIntent = new Intent(view.getContext(), trackDetailsView.class);
        myIntent.putExtra("fileName", currentTrack.getID() + ".json");///pass filename to trackDetailsView activity
        startActivityForResult(myIntent, 0);
        finish();
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;
    }
}
