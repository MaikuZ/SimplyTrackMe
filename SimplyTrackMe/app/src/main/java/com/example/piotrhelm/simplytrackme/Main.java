package com.example.piotrhelm.simplytrackme;

import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;

import static java.lang.StrictMath.max;

public class Main extends AppCompatActivity {
    private ListView drawerList;
    private TextView greetingTextView;
    private TextView greeterDescriptor;
    private DrawerLayout drawerLayout;
    private ActionBarDrawerToggle drawerToggle;
    private ArrayAdapter<String> adapter;
    private Spinner spinner;
    private Handler h;
    private int training_type;
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
        greeterDescriptor = (TextView)findViewById(R.id.greeter_descriptor);
        greeterDescriptor.setText("");
        spinner = (Spinner)findViewById(R.id.spinner2);
        ArrayAdapter<CharSequence> ad = ArrayAdapter.createFromResource(this,
                R.array.trainings, android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(ad);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                training_type = position;
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
        h = new Handler();
        updateGreeter();
        h.postDelayed(new Runnable() {
            @Override
            public void run() {
                updateGreeter();
                h.postDelayed(this, 500);
            }
        }, 500);

    }
    private void updateGreeter() {
        DbOps.ProcessQuery(this,
                "select user_name, distance, w.name from simplytrackme.sessions s " +
                        "join simplytrackme.users u on u.id_user = s.id_owner join " +
                        "simplytrackme.type_workouts w on w.id_type=s.type order by id_session desc limit 1",
                new DbOps.ResultOp() {
                    @Override
                    public void processResult(ResultSet rs) {
                        /*
                        try {
                            rs.next();
                        } catch (SQLException e) {
                            e.printStackTrace();
                            return;
                        }
                        try {
                            StringBuilder str = new StringBuilder();
                            str.append("Latest session was ");
                            str.append(rs.getString(3));
                            str.append(" by ");
                            str.append(rs.getString(1));
                            str.append(", distance ");
                            int metres = rs.getInt(2);
                            str.append(new DecimalFormat("#0.0").format(Double.valueOf(metres/1000)));
                            str.append(" km.");
                            greeterDescriptor.setText(str);
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                        */
                    }
                });
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
            intent.putExtra("training_type", training_type);
            startActivity(intent);
        }
    }
}
