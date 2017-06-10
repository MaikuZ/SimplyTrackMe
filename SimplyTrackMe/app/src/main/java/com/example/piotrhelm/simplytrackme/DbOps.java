package com.example.piotrhelm.simplytrackme;

import android.app.AlertDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
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
    private abstract static class UploadTask extends AsyncTask<Void, Void, Boolean> {

        protected Boolean isDone;
        protected String stringResult;
        protected ResultSet resultSet;

        public Boolean isDone()
        {
            return isDone;
        }
        public String getStringResult()
        {
            return stringResult;
        }
        public ResultSet getResultSet()
        {
            return resultSet;
        }
        protected void executeQuery(Connection c) throws SQLException {
        }
        @Override
        protected Boolean doInBackground(Void ... params) {
            Connection c = null;
            try {
                Class.forName("org.postgresql.Driver");
                DriverManager.setLoginTimeout(3);
                c = DriverManager
                        .getConnection("jdbc:postgresql://23160.p.tld.pl:5432/pg23160_1",
                                "pg23160_1", PreferenceManager.getDefaultSharedPreferences(referenceToApp).getString("password", "none"));
                executeQuery(c);
                c.close();
            } catch (ClassNotFoundException e) {
                stringResult += e.getMessage();
                return Boolean.FALSE;
            } catch (SQLException e) {
                stringResult += e.getMessage();
                return Boolean.FALSE;
            } catch (Exception e) {
                stringResult += e.getMessage();
                return Boolean.FALSE;
            }
            stringResult += "Opened DataBase succesfully";
            return Boolean.FALSE;
        }

        @Override
        protected void onPostExecute(Boolean aBoolean) {
            AlertDialog.Builder alertDialog = new AlertDialog.Builder(referenceToApp);
            alertDialog.setTitle("SQL transfer");
            alertDialog.setMessage(stringResult);
            alertDialog.show();
            super.onPostExecute(aBoolean);
        }
    }
    public static void DeleteTrack(Track track) {
        DeleteTask t = new DeleteTask();
        t.execute(track);
    }
    public static void UploadTrack(final Track track) {
        String result;
        UploadTask t = new UploadTask() {
            @Override
            protected void executeQuery(Connection c) throws SQLException {
                String sql ="INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)\n" +
                        "VALUES ("+track.getID() + ",coalesce((select max(id_session) from simplytrackme.sessions),0)+1,0,null," +"to_timestamp("+new Date(track.getStart_date()).getTime()/1000+"),"
                        +"to_timestamp("+new Date(track.getEnd_date()).getTime()/1000+")" + ","+ Double.valueOf(track.getTotalDistance()).intValue()+",100,(select id_user from simplytrackme.users where user_name like'" +track.getOwner().user_name +"'));";
                Statement stmt = c.createStatement();
                stmt.executeUpdate(sql);
                isDone = true;
                stmt.close();
            }
        };
        t.execute();
    }
}