package com.example.piotrhelm.simplytrackme;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.PolylineOptions;

import java.util.ArrayList;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback {

    private GoogleMap mMap;
    static Track trackToShow;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps2);
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
    }


    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;

        // Add a marker in Sydney and move the camera
        /*LatLng marker = new LatLng(new GPSTracker(this).getLat(),new GPSTracker(this).getLon());
        mMap.addMarker(new MarkerOptions().position(marker).title("Tu jesteś!!!"));*/

        ArrayList<Track.Node> Temp = trackToShow.getList();
        ArrayList<LatLng> List = new ArrayList<>();

        for(int i = 0; i < Temp.size(); i++) {
            LatLng e = new LatLng(Temp.get(i).getLat(), Temp.get(i).getLon());
            List.add(e);
        }

        PolylineOptions polylineOptions = new PolylineOptions();

        // Create polyline options with existing LatLng ArrayList
        polylineOptions.addAll(List);
        polylineOptions
                .width(5)
                .color(Color.RED);

        mMap.addPolyline(polylineOptions);

        LatLng marker = new LatLng(trackToShow.getLast().getLat(),trackToShow.getLast().getLon());
        mMap.addMarker(new MarkerOptions().position(marker));
        mMap.setMinZoomPreference(14.0f);
        mMap.setMaxZoomPreference(14.0f);
        mMap.moveCamera(CameraUpdateFactory.newLatLng(marker));
    }
}
