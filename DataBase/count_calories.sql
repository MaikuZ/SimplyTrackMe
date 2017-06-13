-- male
--Calories Burned = [(Age x 0.2017) — (Weight*0.09036) + (Heart Rate x 0.6309) — 55.0969] x Time / 4.184.

-- female
--Calories Burned = [(Age x 0.074) — (Weight x 0.45359237*0.05741) + (Heart Rate x 0.4472) — 20.4022] x Time / 4.184.

--source : Journal of Sports Sciences - 01-MAR-05 - Prediction of energy expenditure from heart rate monitoring during submaximal exercise.

CREATE OR REPLACE VIEW session_details AS
  SELECT
    user_sessions.id_user,
    users.age,
    users.sex,
    sessions.id_session,
    (users.weight * 2.20462)                                              AS weight,
    type_heartrate_intervals.heartrate                                    AS bpm,
    date_part('epoch' :: TEXT, (sessions.end_time - sessions.begin_time)) AS time_in_secs
  FROM ((((simplytrackme.user_sessions
    LEFT JOIN simplytrackme.users ON ((user_sessions.id_user = users.id_user)))
    LEFT JOIN simplytrackme.sessions ON ((user_sessions.id_session = sessions.id_session)))
    LEFT JOIN simplytrackme.type_workouts ON ((sessions.type = type_workouts.id_type)))
    LEFT JOIN simplytrackme.type_heartrate_intervals ON ((type_workouts.id_type = type_heartrate_intervals.id_type)))
  WHERE (((((3.6 * sessions.distance)) :: DOUBLE PRECISION /
           date_part('epoch', (sessions.end_time - sessions.begin_time)))
          >= (type_heartrate_intervals.minimum_speed) :: DOUBLE PRECISION) AND (
           (((3.6 * sessions.distance)) :: DOUBLE PRECISION /
            date_part('epoch', (sessions.end_time - sessions.begin_time)))
           <= (type_heartrate_intervals.maximum_speed) :: DOUBLE PRECISION));

CREATE OR REPLACE FUNCTION count_calories_woman(user_id INTEGER, session_id INTEGER)
  RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  result   INTEGER;
  result_2 INTEGER;
BEGIN
  result = (SELECT (age * 0.074 - weight * 0.05741 + bpm * 0.4472 - 20.4022) * (time_in_secs / 60) / 4.184
            FROM session_details
            WHERE user_id = id_user AND id_session = session_id) :: INTEGER;
  result_2 = (SELECT 3 * time_in_secs / 60
              FROM session_details
              WHERE user_id = id_user AND id_session = session_id) :: INTEGER;
  RETURN greatest(result, result_2);
END;
$$;

CREATE OR REPLACE FUNCTION count_calories_man(user_id INTEGER, session_id INTEGER)
  RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
  result   INTEGER;
  result_2 INTEGER;
  DECLARE
BEGIN
  result = (SELECT (age * 0.074 - weight * 0.09036 + bpm * 0.6309 - 55.0969) * (time_in_secs / 60) / 4.184
            FROM session_details
            WHERE user_id = id_user AND id_session = session_id) :: INTEGER;
  result_2 = (SELECT 3 * time_in_secs / 60
              FROM session_details
              WHERE user_id = id_user AND id_session = session_id) :: INTEGER;
  RETURN greatest(result, result_2);
END;
$$;


CREATE OR REPLACE VIEW calories_burned AS
  SELECT
    id_user,
    id_session,
    CASE
    WHEN (sex = 'm')
      THEN count_calories_man(id_user, id_session)
    ELSE count_calories_man(id_user, id_session)
    END AS calories_burned
  FROM session_details;
