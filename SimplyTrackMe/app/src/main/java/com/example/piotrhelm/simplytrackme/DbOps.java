package com.example.piotrhelm.simplytrackme;

import android.app.AlertDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Created by bartek on 27.05.17.
 */

public class DbOps extends AppCompatActivity {
    static AppCompatActivity referenceToApp = null;
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
                        .getConnection("jdbc:postgresql://23160.p.tld.pl:5432/pg23160_1",
                                "pg23160_1", PreferenceManager.getDefaultSharedPreferences(referenceToApp).getString("password", "none"));
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
    private static class UploadTask extends AsyncTask<Track, Void, Boolean> {
        private void fillTables(Connection c, Track t) throws SQLException {
            Statement stmt = c.createStatement();
            String sql ="INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)\n" +
                    "VALUES ("+t.getID() + ",coalesce((select max(id_session) from simplytrackme.sessions),0)+1,0,null," +"to_timestamp("+new Date(t.getStart_date()).getTime()/1000+"),"
                    +"to_timestamp("+new Date(t.getEnd_date()).getTime()/1000+")" + ","+ new Double(t.getTotalDistance()).intValue()+",100,(select id_user from simplytrackme.users where user_name like'" +t.getOwner().user_name +"'));";
            //max of id_session is current id.
            stmt.executeUpdate(sql);
            stmt.close();
        }
        @Override
        protected Boolean doInBackground(Track... params) {
            Connection c = null;
            Track t;
            if (params.length == 0)
                return null;
            else
                t = params[0];
            try {
                Class.forName("org.postgresql.Driver");
                DriverManager.setLoginTimeout(3);
                c = DriverManager
                        .getConnection("jdbc:postgresql://23160.p.tld.pl:5432/pg23160_1",
                                "pg23160_1", PreferenceManager.getDefaultSharedPreferences(referenceToApp).getString("password", "none"));
                fillTables(c, t);
                c.close();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                return new Boolean(false);
            } catch (SQLException e) {
                e.printStackTrace();
                return new Boolean(false);
            } catch (Exception e) {
                return new Boolean(false);
            }
            System.out.println("Opened database successfully");
            return new Boolean(true);
        }

        @Override
        protected void onPostExecute(Boolean aBoolean) {
            AlertDialog.Builder alertDialog = new AlertDialog.Builder(referenceToApp);
            alertDialog.setTitle("SQL transfer");
            alertDialog.setMessage(aBoolean ? "Sent succesfully." : "Failure sending data.");
            alertDialog.show();
            super.onPostExecute(aBoolean);
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