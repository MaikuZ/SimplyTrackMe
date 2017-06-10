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
    private abstract static class UploadTask extends AsyncTask<Void, Void, Boolean> {

        protected Boolean isDone;
        protected String stringResult;
        protected ResultSet resultSet;
        static AppCompatActivity referenceToApplication = referenceToApp;
        Statement stmt;

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
                                "pg23160_1", PreferenceManager.getDefaultSharedPreferences(referenceToApplication).getString("password", "none"));
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
            if (aBoolean) {
                AlertDialog.Builder alertDialog = new AlertDialog.Builder(referenceToApplication);
                alertDialog.setTitle("SQL transfer");
                alertDialog.setMessage(stringResult);
                alertDialog.show();
            }
            super.onPostExecute(aBoolean);
        }
    }
    public static void DeleteTrack(final Track track) {
        UploadTask t = new UploadTask() {
            @Override
            protected void executeQuery(Connection c) throws SQLException {
                String sql = "DELETE FROM simplytrackme.sessions WHERE " +
                        "id_localsession = " + track.getID() + " AND " +
                        "id_owner = (select id_user from simplytrackme.users where user_name like'"
                        +track.getOwner().user_name +"');\n";
                Statement stmt = c.createStatement();
                stmt.executeUpdate(sql);
                isDone = true;
                stmt.close();
            }
        };
        t.execute();
    }
    public static void UploadTrack(AppCompatActivity c, final Track track) {
        String result;
        UploadTask t = new UploadTask() {
            @Override
            protected void executeQuery(Connection c) throws SQLException {
                String sql ="INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)\n" +
                        "VALUES ("+track.getID() + ",coalesce((select max(id_session) from simplytrackme.sessions),0)+1,0,null," +"to_timestamp("+new Date(track.getStart_date()).getTime()/1000+"),"
                        +"to_timestamp("+new Date(track.getEnd_date()).getTime()/1000+")" + ","+ Double.valueOf(track.getTotalDistance()).intValue()
                        +","+track.getElevation()
                        +",(select id_user from simplytrackme.users where user_name like'" +track.getOwner().user_name +"'));";
                long totalDistance = 0;
                Track.Node lastNode = track.getList().get(0);
                int id = 0;
                for(Track.Node x : track.getList()) {
                    sql += "\n INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES(" +
                            +(id++)+","
                            + Double.valueOf(x.getLat()).floatValue()+","
                            + Double.valueOf(x.getLon()).floatValue()+","
                            +totalDistance+","
                            + x.getTime_elapsed()/1000 + ","//In seconds!!!
                            + x.getAltitude() + ","
                            +"(SELECT id_session from simplytrackme.sessions" +
                            " where id_owner = (select id_user from simplytrackme.users where user_name like'"
                            +track.getOwner().user_name +"')"
                            + " AND " +
                            "simplytrackme.sessions.id_localsession ="+ track.getID() +"));\n";
                    totalDistance += Track.getDistance(lastNode,x);
                    lastNode = x;
                }
                sql += "INSERT INTO simplytrackme.user_sessions (id_user, id_session) VALUES (" +
                        "(select id_user from simplytrackme.users where user_name like'"
                        +track.getOwner().user_name +"')"+","
                        +"(SELECT id_session from simplytrackme.sessions" +
                        " where id_owner = (select id_user from simplytrackme.users where user_name like'"
                        +track.getOwner().user_name +"')"
                        + " AND " +
                        "simplytrackme.sessions.id_localsession ="+ track.getID() +")"
                        +")";
                Statement stmt = c.createStatement();
                stmt.executeUpdate(sql);
                isDone = true;
                stmt.close();
            }
            @Override
            protected void onPostExecute(Boolean aBoolean) {
                AlertDialog.Builder alertDialog = new AlertDialog.Builder(referenceToApplication);
                alertDialog.setTitle("SQL transfer");
                alertDialog.setMessage(stringResult);
                alertDialog.show();
                super.onPostExecute(aBoolean);
            }
        };
        t.referenceToApplication = c;
        t.execute();
    }
    public static void GetRanking(RankingActivity c, final Ranking.RankingOp rankingOp) {
        ResultSet rs;
        UploadTask t = new UploadTask() {
            @Override
            protected void executeQuery(Connection c) throws SQLException {
                String sql = "SELECT distance, id_session, u.user_name " +
                        "FROM simplytrackme.sessions JOIN simplytrackme.users u ON sessions.id_owner = u.id_user" +
                        " ORDER BY distance DESC;";
                stmt = c.createStatement();
                resultSet = stmt.executeQuery(sql);
                isDone = true;
            }
            @Override
            protected void onPostExecute(Boolean aBoolean) {
                Ranking r = new Ranking(getResultSet());
                rankingOp.run(r);
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                super.onPostExecute(aBoolean);
            }
        };
        t.referenceToApplication = c;
        t.execute();
    }

}