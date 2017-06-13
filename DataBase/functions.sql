-- creating ranking of sum of distance run in the last (interval)
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
----
