-- wypelniam tabele type_workouts
insert into simplytrackme.type_workouts values(0,'bieganie');
insert into simplytrackme.type_workouts values(1,'rower');
insert into simplytrackme.type_workouts values(2,'rolki');
insert into simplytrackme.type_workouts values(3,'narty');


-- dodac check, ze hearthrate w przedziale (50,220)
-- dodac check, ze srednia predkosc biegania w przedziale (0,20)

-- wypelnianie dla biegania
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (0.0,5.0,0,70);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (5.0,6.0,0,80);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (6.0,7.0,0,90);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (7.0,8.0,0,100);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (8.0,9.0,0,110);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (9.0,10.0,0,130);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (10.0,11.0,0,150);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (11.0,12.0,0,160);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (12.0,13.0,0,170);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (13.5,14.0,0,180);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (14.0,14.5,0,185);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (14.5,20.0,0,190);

-- dodac check, ze srednia predkosc na rolkach jest w przedziale(0,45)

-- wypelnienie dla rolek
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (0.0,6.0,2,80);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (6.0,7.0,2,80);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (7.0,9.0,2,90);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (9.0,10.0,2,100);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (10.0,11.0,2,110);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (11.0,12.0,2,120);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (12.0,14.0,2,125);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (14.0,16.0,2,135);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (16.0,18.0,2,145);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (18.0,20.0,2,155);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (20.0,21.0,2,160);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (21.0,22.0,2,170);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (22.0,25.0,2,175);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (25.0,30.0,2,180);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (30.0,45.0,2,190);

-- dodac check, ze srednia predkosc dla rowerow jest w przedziale (0,50)

-- wypelnienie dla roweru
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (0.0,5.0,1,70)
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (5.0,10.0,1,80);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (10.0,13.0,1,90);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (13.0,15.0,1,100);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (15.0,18.0,1,110);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (18.0,20.0,1,120);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (20.0,21.0,1,130);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (21.0,23.0,1,140);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (23.0,25.0,1,150);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (25.0,27.0,1,160);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (27.0,29.0,1,170);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (29.0,31.0,1,175);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (31.0,33.0,1,180);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (33.0,34.0,1,185);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (34.0,35.0,1,190);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (35.0,50.0,1,195);

-- dodach check, ze srednia predkosc dla nart to max 120

insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (0.0,5.0,3,60);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (5.0,20.0,3,100);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (20.0,40.0,3,140);
insert into simplytrackme.type_heartrate_intervals (minimum_speed, maximum_speed, id_type, heartrate) values (40.0,120.0,3,160);


-- male
--Calories Burned = [(Age x 0.2017) — (Weight*0.09036) + (Heart Rate x 0.6309) — 55.0969] x Time / 4.184.

-- female
--Calories Burned = [(Age x 0.074) — (Weight x 0.45359237*0.05741) + (Heart Rate x 0.4472) — 20.4022] x Time / 4.184.

--Journal of Sports Sciences - 01-MAR-05 - Prediction of energy expenditure from heart rate monitoring during submaximal exercise.

/* jeszcze nie dokoczone liczenie kalorii
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
*/
