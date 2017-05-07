package com.example.piotrhelm.simplytrackme;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by mz on 07.05.17.
 */

class Track {

    static int lastID = 0;
    private int id;
    private String start_date;
    private String end_date;
    private Person owner;
    private class Type {
        StringBuilder name;
    }
    private class Node{
        double lat;
        double lon;
        double time_elapsed;///Since the beginning
    }
    private ArrayList<Node> List;
    private ArrayList<Person> Participents;
    Track() {
        List = new ArrayList<>();
        start_date = DateFormat.getDateTimeInstance().format(new Date());
        id = lastID++;
    }
}
