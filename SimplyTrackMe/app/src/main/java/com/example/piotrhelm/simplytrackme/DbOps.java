package com.example.piotrhelm.simplytrackme;

import android.os.AsyncTask;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;
import android.widget.Toast;

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
    public interface ResultOp {
        public void processResult(ResultSet rs);
    }

    private static class QueryTask extends UploadTask {
        DbOps.ResultOp resultOp;
        String sqlQuery;
        QueryTask(AppCompatActivity ref, String query, DbOps.ResultOp resultOp) {
            super(ref);
            sqlQuery = query;
            this.resultOp = resultOp;
        }
        @Override
        protected boolean executeQuery(Connection c) throws SQLException {
            try {
                stmt = c.createStatement();
            } catch (Exception e) {
                this.cancel(false);
                return true;
            }
            try {
                resultSet = stmt.executeQuery(sqlQuery);
                isDone = true;
            } catch (Exception e) {
//                Toast.makeText(referenceToApplication, "Failed to execute SQL statement", Toast.LENGTH_LONG).show();
                try {
                    stmt.close();
                } catch (Exception e2) {
//                    Toast.makeText(referenceToApplication, "SQL close fail: " + e.getMessage(), Toast.LENGTH_LONG).show();
                }
                this.cancel(false);
                return true;
            }
            return false;
        }
        @Override
        protected void onPostExecute(Boolean aBoolean) {
            ResultSet rs = null;
            if (aBoolean || stmt == null) {
                Toast.makeText(referenceToApplication, "Failed to connect to DB", Toast.LENGTH_LONG).show();
                return;
            }
            try {
                rs = stmt.getResultSet();
            } catch (Exception e) {
                Toast.makeText(referenceToApplication, "SQL getResultSet fail: " + e.getMessage(), Toast.LENGTH_LONG).show();
                return;
            }
            resultOp.processResult(rs);
            try {
                if (stmt != null)
                    stmt.close();
            } catch (Exception e) {
                Toast.makeText(referenceToApplication, "SQL close fail: " + e.getMessage(), Toast.LENGTH_LONG).show();
                e.printStackTrace();
            }
            super.onPostExecute(aBoolean);
        }
    }

    private abstract static class UploadTask extends AsyncTask<Void, Void, Boolean> {

        protected Boolean isDone;
        protected String stringResult = new String();
        protected ResultSet resultSet;
        protected AppCompatActivity referenceToApplication = null;
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

        UploadTask(AppCompatActivity ref) {
            super();
            referenceToApplication = ref;
        }

        abstract protected boolean executeQuery(Connection c) throws SQLException;

        @Override
        protected Boolean doInBackground(Void ... params) {
            Connection c = null;
            try {
                Class.forName("org.postgresql.Driver");
                DriverManager.setLoginTimeout(6);
                c = DriverManager
                        .getConnection("jdbc:postgresql://23160.p.tld.pl:5432/pg23160_1",
                                "pg23160_1", PreferenceManager.getDefaultSharedPreferences(referenceToApplication).getString("password", "none"));
                boolean ret = executeQuery(c);
                c.close();
                if (ret)
                    return Boolean.TRUE;
            } catch (ClassNotFoundException e) {
                stringResult += e.getMessage();
                return Boolean.TRUE;
            } catch (SQLException e) {
                stringResult += e.getMessage();
                return Boolean.TRUE;
            } catch (Exception e) {
                stringResult += e.getMessage();
                return Boolean.TRUE;
            }
            stringResult = "Opened DataBase succesfully";
            return Boolean.FALSE;
        }

        @Override
        protected void onPostExecute(Boolean aBoolean) {
            if (aBoolean) {
                Toast.makeText(referenceToApplication, "SQL fail: " + stringResult, Toast.LENGTH_LONG).show();
            }
            super.onPostExecute(aBoolean);
        }
    }
    public static void DeleteTrack(AppCompatActivity c, final Track track) {
        UploadTask t = new UploadTask(c) {
            @Override
            protected void onPostExecute(Boolean aBoolean) {
                if (!aBoolean)
                    Toast.makeText(referenceToApplication, "Popped succesfully!", Toast.LENGTH_SHORT).show();
                super.onPostExecute(aBoolean);
            }
            @Override
            protected boolean executeQuery(Connection c) throws SQLException {
                String sql = "DELETE FROM simplytrackme.sessions WHERE " +
                        "id_localsession = " + track.getID() + " AND " +
                        "id_owner = (select id_user from simplytrackme.users where user_name like'"
                        +track.getOwner().user_name +"');\n";
                Statement stmt = c.createStatement();
                stmt.executeUpdate(sql);
                isDone = true;
                stmt.close();
                return false;
            }
        };
        t.execute();
    }
    public static void UploadTrack(AppCompatActivity c, final Track track) {
        String result;
        UploadTask t = new UploadTask(c) {
            @Override
            protected boolean executeQuery(Connection c) throws SQLException {
                String sql ="INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)\n" +
                        "VALUES ("+track.getID() + ",coalesce((select max(id_session) from simplytrackme.sessions),0)+1,"+track.getTrainingType()+",null," +"to_timestamp("+new Date(track.getStart_date()).getTime()/1000+"),"
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
                return false;
            }
            @Override
            protected void onPostExecute(Boolean aBoolean) {
                if (!aBoolean)
                    Toast.makeText(referenceToApplication, "Uploaded succesfully!", Toast.LENGTH_SHORT).show();
                super.onPostExecute(aBoolean);
            }
        };
        t.execute();
    }
    public static void ProcessQuery(AppCompatActivity context, String query, final DbOps.ResultOp resultOp) {
        QueryTask queryTask = new QueryTask(context, query, resultOp);
        queryTask.execute();
    }

}