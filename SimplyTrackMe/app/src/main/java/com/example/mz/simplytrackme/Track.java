package com.example.mz.simplytrackme;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by mz on 06.05.17.
 */

class Track {
    private int id;
    private Date start;
    private Date end;
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
}
