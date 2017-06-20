/*
 * Skrypt usuwa wszystkie krotki w bazie, poza krotkami stałymi
 * z tabeli type_heartrate_intervals i type_workouts.
 */

delete from simplytrackme.users where true;
