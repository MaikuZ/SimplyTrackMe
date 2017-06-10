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


