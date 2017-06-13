#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>
#include <ctime>
using namespace std;

/*
    INPUT:
    n - number of files
        FOR EACH FILE
            fileName
            minV,maxV
            id_user
            id_type
    OUTPUT:
    PSQL INSERTS

    This program is used to parse .gpx file and extract from it all points.
    It then having set minV and maxV as minimum and maximum velocity generates random time intervals between these points.
    So that the avarage speed is around avg(minV,maxV) and the velocity isn't constant but random.
    It then returns prints in stdout the PSQL INSERTS
*/
long double getStraightDistanceTo(long double lat1,long double lon1,long double lat2,long double lon2)//Returns in meters...
{
    long double R = 6371e3;
    long double deltaLon = lon1-lon2;
    long double deltaLat = lat1-lat2;
    deltaLon *= M_PIl/180;
    deltaLat *= M_PIl/180;
    lon1 *= M_PIl/180;
    lat1 *= M_PIl/180;
    lon2 *= M_PIl/180;
    lat2 *= M_PIl/180;
    long double a = sin(deltaLat/2)*sin(deltaLat/2) + cos(lat1)*cos(lat2)*sin(deltaLon/2)*sin(deltaLon/2);
    long double c = 2 * atan2(sqrt(a),sqrt(1-a));
    long double d = R * c;
    return d;
}
bool charInString(char a, string t)//Returns true if a char is found in that string
{
    for(auto x: t)
    {
        if(x == a)
            return true;
    }
    return false;
}
bool afterOnlyNumbers(char a,string t)//checks if after 'a' char are only chars like 0.123456789
{
    if(!charInString(a,t))
        return false;
    bool only =false;
    for(auto x: t)
    {
        if(only)
        {
            if(!charInString(x,"0.123456789"))
                return false;
        }
        if(x == a)
        {
            only = true;
        }
    }
    return true;
}
bool startsWith(string s, string t)
{
    for(int i = 0;i < s.size();i++)
    {
        if(t.size()<=i)
            return false;
        if(t[i] != s[i])
            return false;
    }
    return true;
}
string ExtractGPX(string nameFile,double minV, double maxV,int idUser,int idType)
{
   ifstream myfile(nameFile);
   if(!myfile.good())
   {
       return "";
   }
   vector<char> buffer((istreambuf_iterator<char>(myfile)), istreambuf_iterator<char>( ));
   vector<pair<long double,long double> > Pairs;
   vector<string> Read;
   string temp = "";
   //First parsing.
   //Push to read only fragments surrounded by whitespaces that are suspected to be lat="number" or lon="number"
   for(int i = 0;i < buffer.size();i++)
   {
        if(buffer[i] == ' ' or buffer[i] == '\n' or buffer[i] == '\0')
        {
            string tempForTemp = "";
            for(auto x: temp)
            {
                if(charInString(x,"latlon=0123456789."))
                    tempForTemp += x;
            }
            temp = tempForTemp;
            if(temp.size() > 4 and charInString('l',temp) and temp[0] == 'l' and charInString(temp.back(),"0123456789")
               and afterOnlyNumbers('=',temp))
                Read.push_back(temp);
            temp = "";
            continue;
        }
        temp+=buffer[i];
   }
   //Collect the pairs lat,lon into Pairs
   for(int i = 0;i < Read.size()-1;i++)
   {
       string currentLat = Read[i];
       if(!startsWith("lat=",currentLat))
            continue;
       string currentLon = Read[i+1];
       if(!startsWith("lon=",currentLon))
            continue;
       string currentLatDouble;
       for(int j = 4;j < currentLat.size();j++)
       {
           currentLatDouble += currentLat[j];
       }
       string currentLonDouble;
       for(int j = 4;j < currentLon.size();j++)
       {
           currentLonDouble += currentLon[j];
       }
       long double lat = stold(currentLatDouble);
       long double lon = stold(currentLonDouble);
       Pairs.push_back(make_pair(lat,lon));
   }

   pair<long double,long double> lastNode = *Pairs.begin();
   int i = 0;
   string InsertIntoNodes;
   long double totalDistance = 0;
   long long int duration = 0;
   long long int id_node = 0;
   for(auto x: Pairs)
   {
       if(i++ == 0)
            continue;
        long double distance = getStraightDistanceTo(x.first,x.second,lastNode.first,lastNode.second);
		lastNode = x;
		totalDistance += distance;
        distance/=1000;///To km's
        //t = s/V
        double time_min = distance/minV;///in hours
        time_min *= 3600 * 1000;
        double time_max = distance/maxV;///in hours
        time_max *= 3600 * 1000;
        long long int a = time_max;///in MS
        long long int b = time_min;///in MS
        if(b-a == 0)///We can't divide by zero
            continue;
        long long int c = rand()%(b-a);///We get a random value so that the velocity is between minV and maxV, but still random.
        long long int atLast = c + a;///The time between these nodes.
        atLast /= 1000;
        duration += atLast;

        InsertIntoNodes +=
        (string)"INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES("
        + to_string(id_node++) + ","
        + to_string(x.first) + ","
        + to_string(x.second) + ","
        + to_string((long long int)totalDistance) + ","
        + to_string(duration) + ","
        + "0" + ","
        + "(SELECT id_session from simplytrackme.sessions"
        +" where id_owner = "
        + to_string(idUser)
        + " AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = "
        + to_string(idUser)
        + " group by id_owner)"
        + "));\n";
   }
    string InsertIntoSessions;
    InsertIntoSessions +=
    (string)"INSERT INTO simplytrackme.sessions "
    + "(id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)"
    + "VALUES ("
    + "(SELECT max(id_localsession)+1 from simplytrackme.sessions where id_owner = "
    + to_string(idUser)
    + " group by id_owner)"
    + ",coalesce((select max(id_session) from simplytrackme.sessions),0)+1,"
    ///^correct localssession. It is the maximum+1.
    + to_string(idType) +", " ///Type of exercise
    + "null," ///route id
    + "current_timestamp," ///begin_time
    + "current_timestamp + interval'"
    + to_string(duration) + " s'," ///end_time
    + to_string((long long int)totalDistance) + "," ///total_distance
    + "0," ///elevation
    +to_string(idUser) + ");\n";///id_user

    string InsertIntoUserSessions;
    InsertIntoUserSessions +=
    (string)"INSERT INTO simplytrackme.user_sessions (id_user, id_session) VALUES ("
    + to_string(idUser) + ","
    + "(SELECT id_session from simplytrackme.sessions"
    + " where id_owner = "
    + to_string(idUser) + " AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = "
    + to_string(idUser)
    + " group by id_owner)));\n";
   return InsertIntoSessions + InsertIntoNodes + InsertIntoUserSessions;
}
int main()
{
    srand(time_t(0));
    int n;///Liczba plikow
    cin>>n;
    for(int i = 0;i< n;i++)
    {
        ///name,minV,maxV,idUser,idType
        string name;
        cin>>name;
        double minV,maxV;
        cin>>minV>>maxV;
        int idUser;
        cin>>idUser;
        int idType;
        cin>>idType;
        cout<<"--"<<name<<":id_user="<<idUser<<":id_type="<<idType<<":minV"<<minV<<":maxV"<<maxV<<endl;
        cout<<ExtractGPX(name,minV,maxV + 0.001,idUser,idType)<<endl;
    }
}
