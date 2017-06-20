#include <iostream>
#include <string>
#include <set>
#include <ctime>
using namespace std;

/*
    IN:
    maximumID of user.
    OUT:
    Inserts with competitions and

*/

#define BIEG 0
#define ROWER 3
#define ROLKI 4

string Places[32] = {"Krakow","Warszawa","Poznan","Gdynia","Busko","Kielce","Radom","Wadowice","Wroclaw","Poznan","Zakopane"};
string CompetitionPlace[32] = {"Krakowski","Warszawski","Poznanski","Gdynski","Buskijski","Kielecki","Radomski","Wadowicki","Wroclawski","Poznanski","Tatrzanski"};

string CompetitionTypes[32] = {"Polmaraton","Maraton","Mini-maraton","bieg najlepszych","maraton rowerowy","maraton rolkarski","Bieg marzanny","Bieg o szybkosc"};
int TypeOfCompetition[32] = {BIEG,BIEG,BIEG,BIEG,ROWER,ROLKI,BIEG,BIEG};
int distanceComp[32] = {21097,21097*2,21097*2/10,10000,21097*2,21097*2,12345,1024*8};
int main()
{
    srand(time_t(0));
    int maxID;
    cin>>maxID;
    maxID--;
    int numberOfContests = 0;
    for(int i = 0;i < 32;i++)
    {
        string place = Places[i];
        string competitionPlace = CompetitionPlace[i];
        if(place.size() == 0)
            continue;
        for(int j = 0;j < 32;j++)
        {
            string competitionType = CompetitionTypes[j];
            if(competitionType.size() == 0)
                continue;
            int type = TypeOfCompetition[j];
            int dist = distanceComp[j];
            string insertIntoCompetitions = (string)"INSERT INTO simplytrackme.competitions (id_competition, name, place, event_date, id_type, distance)\n" +
            + "VALUES ("
            + to_string(numberOfContests++) + ", "
            + "'" + competitionPlace  + " "+ competitionType + "'" + ", "
            + "'" + place + "', "
            + "current_date - interval '" + to_string(rand()%(2*356)) + " days'" + ", "
            + to_string(type) + ", "
            + to_string(dist) + ");";
            cout<<insertIntoCompetitions<<endl;
            set<int> participants;
            for(int m = 0;m < maxID;m++)
            {
                participants.insert(rand()%maxID+1);
            }
            string insertIntoParticipants;
            for(auto x: participants)
            {
                long double timeInSeconds = dist/1000*5*60;
                long double toAdd = rand()%(int)(dist/1000*120);
                if(rand()%2 == 0)
                    toAdd *= -1;
                timeInSeconds += toAdd;
                insertIntoParticipants = (string)"INSERT INTO simplytrackme.participants (id_competition, id_user, time_result) VALUES("
                + to_string(numberOfContests-1) + ", "
                + to_string(x) + ", "
                + to_string((long long int)timeInSeconds) + ");\n";
                cout<<insertIntoParticipants;
            }
        }
    }
    return 0;
}
