-- empty group
CREATE OR REPLACE FUNCTION check_if_empty_group()
  RETURNS TRIGGER AS
$$
DECLARE
  counter INTEGER;
BEGIN
  counter = (SELECT count(*)
             FROM simplytrackme.group_members
             WHERE id_group = old.id_group);
  IF counter = 0
  THEN
    DELETE FROM simplytrackme.groups
    WHERE id_group = old.id_group;
  END IF;
  RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_group
  AFTER DELETE ON simplytrackme.group_members
  FOR EACH ROW
    EXECUTE PROCEDURE check_if_empty_group();
----

-- competition trigger
CREATE OR REPLACE FUNCTION check_if_empty_competition()
  RETURNS TRIGGER AS
$$
DECLARE
  counter INTEGER;
BEGIN
  counter = (SELECT count(*)
             FROM simplytrackme.participants
             WHERE id_user = old.id_user);
  IF counter = 0
  THEN
    DELETE FROM simplytrackme.competitions
    WHERE id_competition = old.id_competition;
  END IF;
  RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_competition
  AFTER DELETE ON simplytrackme.participants
  FOR EACH ROW
    EXECUTE PROCEDURE check_if_empty_competition();
----


-- ranking all time
drop view if EXISTS ranking_distance_alltime;
CREATE VIEW ranking_distance_alltime AS (
  SELECT
    us.id_user,
    sum(distance)
  FROM simplytrackme.users
    LEFT JOIN simplytrackme.user_sessions us ON simplytrackme.users.id_user = us.id_user
    LEFT JOIN simplytrackme.sessions s ON us.id_session = s.id_session
    group by us.id_user
    order by 2 desc
);

select * from ranking_distance_month;

create or replace rule ranking_distance_alltime_do_nothing as on INSERT
  to ranking_distance_all_time do instead nothing;
----


--Trigger user_session

CREATE OR REPLACE FUNCTION delete_if_owner()
  RETURNS TRIGGER AS
$$
BEGIN
  IF (old.id_user = (SELECT id_owner FROM simplytrackme.sessions WHERE id_session = old.id_session)) THEN
    DELETE FROM simplytrackme.sessions WHERE id_session = old.id_session;
  END IF;
  return null;
END;
$$
LANGUAGE plpgsql;

CREATE trigger user_owner_delete after delete on simplytrackme.user_sessions
for each row execute procedure delete_if_owner();

--person distance
CREATE OR REPLACE FUNCTION person_distance(interval, _name VARCHAR)
  RETURNS numeric AS
$$
BEGIN
  RETURN (SELECT
    coalesce(sum(distance),0)
  FROM simplytrackme.users
    JOIN simplytrackme.user_sessions us ON simplytrackme.users.id_user = us.id_user
    JOIN simplytrackme.sessions s ON us.id_session = s.id_session
  WHERE current_date - s.begin_time <= $1 AND user_name = _name);
END;
$$
LANGUAGE plpgsql;
--ranking distance
CREATE OR REPLACE FUNCTION ranking_distance(INTERVAL)
  RETURNS TABLE(
    _user_name VARCHAR,
    distance   NUMERIC
  ) AS
$$
BEGIN
  RETURN QUERY
  SELECT
    user_name,
    coalesce((SELECT person_distance($1, user_name)), 0)
  FROM simplytrackme.users
  order by 2 desc,1;
END;
$$
LANGUAGE plpgsql;
