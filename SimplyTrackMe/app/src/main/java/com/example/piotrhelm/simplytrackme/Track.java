package com.example.piotrhelm.simplytrackme;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by mz on 07.05.17.
 */

class Track {

    static int lastID = 0;
    private int id;
    private long start_date;
    private long end_date;
    private Person owner;
    private class Type {
        StringBuilder name;
    }
    private class Node{
        double lat;
        double lon;
        long time_elapsed;///Since the beginning
        Node(double lattitude, double longitude,long time) {
            lat = lattitude;
            lon = longitude;
            time_elapsed = time;
        }
    }
    private ArrayList<Node> List;
    private ArrayList<Person> Participents;
    Track() {
        List = new ArrayList<>();
        start_date = Calendar.getInstance().getTime().getTime();
        id = lastID++;
    }
    public void addNode(double lat, double lon, long time){
        List.add(new Node(lat,lon,time-start_date));
    }
}
