package com.example.piotrhelm.simplytrackme;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import static java.lang.Math.atan2;
import static java.lang.Math.cos;
import static java.lang.Math.sin;
import static java.lang.Math.sqrt;

/**
 * Created by mz on 07.05.17.
 */

class Track {

    static int lastID = 0;
    static double getDistance(double lat1,double lon1, double lat2, double lon2)
    {
        double R = 6371e3;
        double deltaLon = lon1-lon2;
        double deltaLat = lat1-lat2;
        deltaLon *= Math.PI/180;
        deltaLat *= Math.PI/180;
        lon1 *= Math.PI/180;
        lat1 *= Math.PI/180;
        lon2 *= Math.PI/180;
        lat2 *= Math.PI/180;
        double a = sin(deltaLat/2)*sin(deltaLat/2) + cos(lat1)*cos(lat2)*sin(deltaLon/2)*sin(deltaLon/2);
        double c = 2 * atan2(sqrt(a),sqrt(1-a));
        double d = R * c;
        return d;
    }
    static double getDistance(Node a, Node b)
    {
        return getDistance(a.getLat(),a.getLon(),b.getLat(),b.getLon());
    }

    private int id;
    private long start_date;
    private double totalDistance = 0;
    private long end_date;
    private Person owner;
    private class Type {
        StringBuilder name;
    }
    public class Node{
        private double lat;
        private double lon;
        private long time_elapsed;///Since the beginning
        Node(double lattitude, double longitude,long time) {
            lat = lattitude;
            lon = longitude;
            time_elapsed = time;
        }
        double getLat() {
            return lat;
        }
        double getLon(){
            return lon;
        }
        long getTime_elapsed(){
            return time_elapsed;
        }
    }
    private ArrayList<Node> List;
    public Node getLast() {
        if(List.size() == 0)
            return null;
        return List.get(List.size()-1);
    }
    private ArrayList<Person> Participents;
    Track() {
        List = new ArrayList<>();
        start_date = Calendar.getInstance().getTime().getTime();
        id = lastID++;
    }
    public void addNode(double lat, double lon, long time){
        Node temp = new Node(lat,lon,time-start_date);
        Node last = getLast();
        if(last == null)
            List.add(temp);
        else {
            //To change to constant (10)
            if(getDistance(getLast(),temp) > 10) {
                List.add(temp);
            }
            else return;
        }
        if(last != null)
            totalDistance += getDistance(last,temp);
    }
}
