package com.example.piotrhelm.simplytrackme;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;


import static java.lang.StrictMath.max;

public class Main extends AppCompatActivity {
    private ListView drawerList;
    private TextView greetingTextView;
    private DrawerLayout drawerLayout;
    private ActionBarDrawerToggle drawerToggle;
    private ArrayAdapter<String> adapter;
    private Spinner spinner;
    public String trainingStr;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        String[] listOfFiles = getFilesDir().list();
        for(String x: listOfFiles){
            if(x.endsWith(".json")) {
                String id = x.substring(0,x.length() - ".json".length());
                Track.lastID = max(Track.lastID, Integer.parseInt(id)+1);
            }
        }
        drawerList = (ListView)findViewById(R.id.navList);
        drawerLayout = (DrawerLayout)findViewById(R.id.drawer_layout);
        greetingTextView = (TextView)findViewById(R.id.greeting_text_view);
        spinner = (Spinner)findViewById(R.id.spinner2);
        ArrayAdapter<CharSequence> ad = ArrayAdapter.createFromResource(this,
                R.array.trainings, android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(ad);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                trainingStr = ((CharSequence)parent.getItemAtPosition(position)).toString();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        greetingTextView.setText("Hello " +
                PreferenceManager.getDefaultSharedPreferences(this).getString("person_name", "none") + "!");
        addDrawerItems();
        setupDrawer();
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

    }
    private void addDrawerItems() {
        String[] osArray = { "History", "Ranks", "Settings", "Profile" };
        adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, osArray);
        drawerList.setAdapter(adapter);

        drawerList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent;
                switch (position) {
                case 0:
                    intent = new Intent(Main.this, History.class);
                    startActivity(intent);
                    break;
                case 1:
                    intent = new Intent(Main.this, RankingActivity.class);
                    startActivity(intent);
                    break;
                case 2:
                    intent = new Intent(Main.this, SettingsActivity.class);
                    startActivity(intent);
                    break;
                case 3:
                    intent = new Intent(Main.this, Profile.class);
                    startActivity(intent);
                    break;
                }
            }
        });
    }
    private void setupDrawer() {
        drawerToggle = new ActionBarDrawerToggle(this, drawerLayout, R.string.drawer_open, R.string.drawer_close) {

            /** Called when a drawer has settled in a completely open state. */
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
                getSupportActionBar().setTitle("Navigate");
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }

            /** Called when a drawer has settled in a completely closed state. */
            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);
                getSupportActionBar().setTitle("SimplyTrackMe");
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }
        };

        drawerToggle.setDrawerIndicatorEnabled(true);
        drawerLayout.addDrawerListener(drawerToggle);
    }

        @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        // Sync the toggle state after onRestoreInstanceState has occurred.
        drawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        drawerToggle.onConfigurationChanged(newConfig);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu., menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        // Activate the navigation drawer toggle
        if (drawerToggle.onOptionsItemSelected(item)) {
            return true;
        }

        return super.onOptionsItemSelected(item);
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
    public void startSession(View view) {
        GPSTracker tracker = new GPSTracker(this);
        if (!tracker.isGPSOn) {
            tracker.showSettingsAlert();
        }
        if (tracker.isGPSOn) {
            Intent intent = new Intent(this, Start.class);
            startActivity(intent);
        }
    }
}
