package com.example.piotrhelm.simplytrackme;

import android.os.AsyncTask;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Created by bartek on 27.05.17.
 */

public class DbOps {
    private static class DeleteTask extends AsyncTask<Track, Void, Void> {
        @Override
        protected Void doInBackground(Track... params) {
            Connection c = null;
            Track t;
            if (params.length == 0)
                return null;
            else
                t = params[0];
            try {
                Class.forName("org.postgresql.Driver");
                c = DriverManager
                        .getConnection("jdbc:postgresql://192.168.43.37:5432/stm",
                                "stm", "stm");
                /* add SQL requests */
                c.close();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.out.println("Opened database successfully");
            return null;
        }
    }
    private static class UploadTask extends AsyncTask<Track, Void, Void> {
        private void fillTables(Connection c, Track t) throws SQLException {
            Statement stmt = c.createStatement();
            String sql = "INSERT INTO COMPANY (id, NAME,AGE,ADDRESS,SALARY) "
                    + "VALUES (10, '" + t.getOwner().name + "', 32, 'California', 20000.00 );";
            stmt.executeUpdate(sql);
            stmt.close();
        }
        @Override
        protected Void doInBackground(Track... params) {
            Connection c = null;
            Track t;
            if (params.length == 0)
                return null;
            else
                t = params[0];
            try {
                Class.forName("org.postgresql.Driver");
                c = DriverManager
                        .getConnection("jdbc:postgresql://192.168.43.37:5432/stm",
                                "stm", "stm");
                fillTables(c, t);
                c.close();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.out.println("Opened database successfully");
            return null;
        }
    }
    public static void DeleteTrack(Track track) {
        DeleteTask t = new DeleteTask();
        t.execute(track);
    }
    public static void UploadTrack(Track track) {
        UploadTask t = new UploadTask();
        t.execute(track);
    }
}
