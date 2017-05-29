package com.example.piotrhelm.simplytrackme;

import android.Manifest;
import android.app.AlertDialog;
import android.app.Service;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

/**
 * Created by mz on 07.05.17.
 */

class GPSTracker extends Service implements LocationListener {
    private final Context mContext;

    //flag for the GPS
    boolean isGPSOn = false;
    //flag for network
    boolean isNetworkOn = false;

    boolean isPossibleGetLocation = false;

    Location location;//location
    double lat;
    double lon;
    private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 10;//IN METERS
    private static final long MIN_TIME_BW_UPDATES = 1000 * 1 * 1; // IN miliseconds; Currently one minute

    protected LocationManager locationManager;
    private AlertDialog.Builder alertDialog;
    private boolean isSettingsAlertOn = false;

    public GPSTracker(Context context) {
        this.mContext = context;
        getLocation();
    }
    public Location getUpdatedLocation() {
        if(locationManager == null)
            return null;
        //noinspection MissingPermission
        Location newLocation = locationManager.getLastKnownLocation(locationManager.GPS_PROVIDER);
        if(newLocation == null)//noinspection MissingPermission
            newLocation = locationManager.getLastKnownLocation(locationManager.NETWORK_PROVIDER);
        if(newLocation != null)
            location = newLocation;
        if(location != null) {
            lat = location.getLatitude();
            lon = location.getLongitude();
        }
        return location;
    }
    public Location getLocation() {
        try {
            locationManager = (LocationManager) mContext
                    .getSystemService(LOCATION_SERVICE);

            // getting GPS status
            isGPSOn = locationManager
                    .isProviderEnabled(LocationManager.GPS_PROVIDER);

            // getting network status
            isNetworkOn = locationManager
                    .isProviderEnabled(LocationManager.NETWORK_PROVIDER);

            if (!isGPSOn && !isNetworkOn) {
                // no network provider is enabled
            } else {
                this.isPossibleGetLocation = true;
                // First get location from Network Provider
                if (isNetworkOn) {
                    //noinspection MissingPermission
                    locationManager.requestLocationUpdates(
                            LocationManager.NETWORK_PROVIDER,
                            MIN_TIME_BW_UPDATES,
                            MIN_DISTANCE_CHANGE_FOR_UPDATES, this);
                    Log.d("Network", "Network");
                    if (locationManager != null) {
                        //noinspection MissingPermission
                        location = locationManager
                                .getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
                        if (location != null) {
                            lat = location.getLatitude();
                            lon = location.getLongitude();
                        }
                    }
                }
                // if GPS Enabled get lat/long using GPS Services
                if (isGPSOn) {
                    if (true) {
                        //noinspection MissingPermission
                        locationManager.requestLocationUpdates(
                                LocationManager.GPS_PROVIDER,
                                MIN_TIME_BW_UPDATES,
                                MIN_DISTANCE_CHANGE_FOR_UPDATES, this);
                        Log.d("GPS Enabled", "GPS Enabled");
                        if (locationManager != null) {
                            Location temp = location;
                            //noinspection MissingPermission
                            location = locationManager
                                    .getLastKnownLocation(LocationManager.GPS_PROVIDER);
                            if(location == null)
                                location = temp;
                            if (location != null) {
                                lat = location.getLatitude();
                                lon = location.getLongitude();
                            }
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return location;
    }

    public double getLat() {
        if(location != null)
            lat = location.getLatitude();
        return lat;
    }

    public double getLon() {
        if(location != null)
            lon = location.getLongitude();
        return lon;
    }
    public boolean isPossibleGetLocation() {
        return this.isPossibleGetLocation;
    }
    @Override
    public void onLocationChanged(Location location) {
    }

    @Override
    public void onProviderDisabled(String provider) {
    }

    @Override
    public void onProviderEnabled(String provider) {
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
    }

    @Override
    public IBinder onBind(Intent arg0) {
        return null;
    }
    public boolean isSettingsAlertOn(){
        return isSettingsAlertOn;
    }
    public void showSettingsAlert(){
        if(isSettingsAlertOn)
            return;
        alertDialog = new AlertDialog.Builder(mContext);
        isSettingsAlertOn = true;
        // Setting Dialog Title
        alertDialog.setTitle("GPS settings");

        // Setting Dialog Message
        alertDialog.setMessage("GPS is not enabled. Do you want to go to settings menu?");

        // Setting Icon to Dialog
        //alertDialog.setIcon(R.drawable.delete);

        // On pressing SettingsActivity button
        alertDialog.setPositiveButton("Settings", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog,int which) {
                Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                mContext.startActivity(intent);
                isSettingsAlertOn = false;
            }
        });

        // on pressing cancel button
        alertDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                isSettingsAlertOn = false;
                dialog.cancel();
            }
        });

        // Showing Alert Message
        alertDialog.show();
    }
    public void stopUsingGPS(){
        if(locationManager != null){
            locationManager.removeUpdates(GPSTracker.this);
        }
    }

}
