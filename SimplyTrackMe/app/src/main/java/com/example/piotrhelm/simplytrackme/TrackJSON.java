package com.example.piotrhelm.simplytrackme;
import com.google.gson.Gson;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;


/**
 * Created by andrzej_zdobywca on 07.05.17.
 */

public class TrackJSON {

    public static void main(String [] args) {
        Track track = createDummyTrack();
        toJSON(track);
    }

    private static void toJSON(Track track_in) {
        Gson gson = new Gson();
        String json = gson.toJson(track_in);
        System.out.println(json);
    };

    private static Track createDummyTrack() {
        Track track = new Track();
        track.setEnd_date(12209292);
        track.setId(12);
        track.setOwner(new Person());
        track.setStart_date(1202020);
        return track;
    }
}
