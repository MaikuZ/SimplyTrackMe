
-- male
--Calories Burned = [(Age x 0.2017) — (Weight*0.09036) + (Heart Rate x 0.6309) — 55.0969] x Time / 4.184.

-- female
--Calories Burned = [(Age x 0.074) — (Weight x 0.45359237*0.05741) + (Heart Rate x 0.4472) — 20.4022] x Time / 4.184.

--Journal of Sports Sciences - 01-MAR-05 - Prediction of energy expenditure from heart rate monitoring during submaximal exercise.

-- jeszcze nie dokoczone liczenie kalorii
create or replace function count_calories()
  returns void as
  $$
DECLARE
BEGIN
  create view temp as
    select sessions.id_session as id_session,weight*0.4535 as weight_kg,
      heartrate as bpm, extract(epoch from end_time-begin_time) as time_in_secs
    from simplytrackme.user_sessions
  left join simplytrackme.users on user_sessions.id_user = users.id_user
  left join simplytrackme.sessions on user_sessions.id_session = sessions.id_session
  left join simplytrackme.type_workouts on sessions.type = type_workouts.id_type
  left join simplytrackme.type_heartrate_intervals on type_workouts.id_type = type_heartrate_intervals.id_type
  where 3.6*distance/extract(epoch from end_time-begin_time) >= type_heartrate_intervals.minimum_speed
        and 3.6*distance/extract(epoch from end_time-begin_time) <= type_heartrate_intervals.maximum_speed;
  end;
  $$
  language plpgsql;

create or replace view temp as
    select user_sessions.id_user as id_user, users.age as age, users.sex as sex,sessions.id_session as id_session,weight*0.4535 as weight,
      heartrate as bpm, extract(epoch from end_time-begin_time) as time_in_secs
    from simplytrackme.user_sessions
  left join simplytrackme.users on user_sessions.id_user = users.id_user
  left join simplytrackme.sessions on user_sessions.id_session = sessions.id_session
  left join simplytrackme.type_workouts on sessions.type = type_workouts.id_type
  left join simplytrackme.type_heartrate_intervals on type_workouts.id_type = type_heartrate_intervals.id_type
  where 3.6*distance/extract(epoch from end_time-begin_time) >= type_heartrate_intervals.minimum_speed
        and 3.6*distance/extract(epoch from end_time-begin_time) <= type_heartrate_intervals.maximum_speed;

create or replace view calories_burned as
  select id_user, id_session, case when sex = 'm' then count_calories_man() else count_calories_woman() end
    from temp;

select sessions.id_session,sex,age,weight,3.6*distance/extract(epoch from end_time-begin_time) as kmh,heartrate from simplytrackme.user_sessions
  left join simplytrackme.users on user_sessions.id_user = users.id_user
  left join simplytrackme.sessions on user_sessions.id_session = sessions.id_session
  left join simplytrackme.type_workouts on sessions.type = type_workouts.id_type
  left join simplytrackme.type_heartrate_intervals on type_workouts.id_type = type_heartrate_intervals.id_type
  where 3.6*distance/extract(epoch from end_time-begin_time) >= type_heartrate_intervals.minimum_speed and 3.6*distance/extract(epoch from end_time-begin_time) <= type_heartrate_intervals.maximum_speed;

select extract(minutes from end_time - begin_time) + extract(seconds from end_time-begin_time)/60 from simplytrackme.sessions;

