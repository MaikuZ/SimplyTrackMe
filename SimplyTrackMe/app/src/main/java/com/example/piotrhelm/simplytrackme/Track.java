package com.example.piotrhelm.simplytrackme;

import android.content.Context;

import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import static java.lang.Math.atan2;
import static java.lang.Math.cos;
import static java.lang.Math.sin;
import static java.lang.Math.sqrt;
import static java.lang.StrictMath.abs;

/**
 * Created by mz on 07.05.17.
 */

class Track implements Serializable {

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
    private long startDate;
    private double totalDistance = 0;
    private double elevation = 0;
    private long endDate;
    private Person owner;
    private int trainingType;

    public double getElevation(){
        return elevation;
    }
    public long getStartDate(){
        return startDate;
    }
    public long getEndDate(){
        return endDate;
    }
    public Person getOwner() {
        return owner;
    }


    public double getTotalDistance() {
        return totalDistance;
    }

    public int getID() {
        return id;
    }


    public void setId(int a) {
        id = a;
    }

    public void setEndDate(long a) {
        endDate = a;
    }

    public void setStartDate(long a) {
        startDate = a;
    }
    static String toJSON(Track track_in) {
        Gson gson = new Gson();
        return gson.toJson(track_in);
    };
    void saveToFile(Context mContext){
        String filename = id + ".json";
        String outputString = toJSON(this);
        try {
            FileOutputStream outputStream =  mContext.openFileOutput(filename, Context.MODE_PRIVATE);
            outputStream.write(outputString.getBytes());
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void setOwner(Person a) {
        owner = a;
    }

    public int getTrainingType() {
        return trainingType;
    }

    public void setTrainingType(int trainingType) {
        this.trainingType = trainingType;
    }

    public class Node{
        private double lat;
        private double lon;
        private double altitude;///current meters above the sea.
        private long time_elapsed;///Since the beginning
        Node(double lattitude, double longitude,long time) {
            lat = lattitude;
            lon = longitude;
            time_elapsed = time;
        }
        Node(double lattitude, double longitude,long time,double elevation) {
            lat = lattitude;
            lon = longitude;
            time_elapsed = time;
            altitude = elevation;
        }
        double getLat() {
            return lat;
        }
        double getLon(){
            return lon;
        }
        double getAltitude() { return altitude;}
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

    public ArrayList<Node> getList(){
        return List;
    }

    private ArrayList<Person> Participents;
    Track() {
        List = new ArrayList<>();
        startDate = Calendar.getInstance().getTime().getTime();
        id = lastID++;
    }
    public void addNode(double lat, double lon, long time, double altitude){
        Node temp = new Node(lat,lon,time-startDate,altitude);
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
        if(last != null) {
            totalDistance += getDistance(last, temp);
            elevation += abs(-last.altitude + temp.altitude);
        }
    }
    @Override
    public String toString()
    {
        StringBuilder a = new StringBuilder();
            a.append("Track id: "+id + ", Date: " + new SimpleDateFormat("yyyy-MM-dd").format(new Date(startDate)) +"\n"
                    +"Total Distance: " + new DecimalFormat("#0.0").format(Double.valueOf(totalDistance/1000)) +  " km");
        return a.toString();
    }
    public String toStringDetailed()
    {
        StringBuilder a = new StringBuilder();
        a.append("Track id: " + id
                + "\nBegin: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(startDate)) +"\n"
                + "End: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(endDate)) + "\n\n"
                + "Total Distance: " + new DecimalFormat("#0.0").format(Double.valueOf(totalDistance/1000)) +  " km\n"
                + "Elevation: " + (int)getElevation() + "\n"
                + "Total time: " + (Calendar.getInstance().getTime().getTime() - getStartDate())/1000/60 + " minutes"+"\n"
                + "Average speed: " + new DecimalFormat("#0.0").format((getTotalDistance()/1000)/(Calendar.getInstance().getTime().getTime() - getStartDate())*1000*60*60) + " km/h");
        return a.toString();
    }
}
