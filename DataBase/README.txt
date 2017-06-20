Wszystkie implementacje użytych funkcji są umieszczone w folderze functions_used. 
W folderze generators znajdują się pliki c++, które generowały potrzebne nam inserty. 
Dodatkowo w folderze generators/GPStoPSQL jest program do konwertowania plików o rozszerzeniu 
.gpx na polecenia psql wypełniające bazę. 
create.sql może działać długo z powodu dużej liczby insertów do tabeli nodes. 
clear.sql usuwa całą bazę wraz z funkcjami, które stworzył. 
empty_database.sql usuwa wszystkie krotki z wyjątkiem tych z tabeli type_heartrate_intervals i type_workouts. 

