#include <iostream>
#include <fstream>
#include<vector>
#include<cmath>
#include <ctime>
using namespace std;

long double getStraightDistanceTo(long double lat1,long double lon1,long double lat2,long double lon2)///Returns in meters...
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
    //cout<<deltaLon<<" "<<deltaLat<<endl;
    long double a = sin(deltaLat/2)*sin(deltaLat/2) + cos(lat1)*cos(lat2)*sin(deltaLon/2)*sin(deltaLon/2);
    long double c = 2 * atan2(sqrt(a),sqrt(1-a));
    long double d = R * c;
    return d;
}
bool charInString(char a, string t)
{
    for(auto x: t)
    {
        if(x == a)
            return true;
    }
    return false;
}
bool afterOnlyNumbers(char a,string t)
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

   /* "Read file into vector<char>"  See linked thread above*/
   vector<char> buffer((istreambuf_iterator<char>(myfile)), istreambuf_iterator<char>( ));
   vector<pair<double,double> > Pairs;
   vector<string> Read;
        string temp = "";
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
       double lat = stod(currentLatDouble);
       double lon = stod(currentLonDouble);
       Pairs.push_back(make_pair(lat,lon));
   }
   pair<double,double> lastNode = *Pairs.begin();
   int i = 0;
   string InsertIntoNodes;
   long long int totalDistance = 0;
   long long int duration = 0;
   long long int id_node = 0;
   for(auto x: Pairs)
   {
       if(i++ == 0)
            continue;
        double distance = getStraightDistanceTo(x.first,x.second,lastNode.first,lastNode.second);
        distance/=1000;//km
        //V = droga/czas
        //czas = droga/V
       // cout<<":"<<distance<<endl;
        double time_min = distance/minV;///in hours
        time_min *= 3600 * 1000;
       // cout<<(int)time_min/1000<<endl;
        double time_max = distance/maxV;///in hours
        time_max *= 3600 * 1000;
       // cout<<(int)time_max/1000<<endl;
        long long int a = time_max;
        long long int b = time_min;
        //cout<<(b-a)<<endl;
        if(b-a == 0)
            continue;
        long long int c = rand()%(b-a);
        long long int atLast = c + a;
        atLast/=1000;
        totalDistance += distance*1000;
        duration += atLast;
        //cout<<x.first<<" : "<<x.second<<" : "<<atLast<<" distance: "<<(int)(distance*1000)<<endl;
        InsertIntoNodes += "INSERT INTO simplytrackme.nodes (id_node ,lat, lon, total_distance, duration, elevation, id_session) VALUES("
        + to_string(id_node++) +","
        + to_string(x.first) + ","
        + to_string(x.second) + ","
        + to_string(totalDistance) + ","
        + to_string(duration) + ","
        + "0" + ","
        + "(SELECT id_session from simplytrackme.sessions"
        +" where id_owner = "
        + to_string(idUser) + " AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = "+to_string(idUser)
        + " group by id_owner)"
        + "));\n";
   }
    string InsertIntoSessions;
    InsertIntoSessions +=
    (string)"INSERT INTO simplytrackme.sessions (id_localsession,id_session,type,id_route, begin_time, end_time, distance, elevation, id_owner)"
    +"VALUES ("
    + "(SELECT max(id_localsession)+1 from simplytrackme.sessions where id_owner = "+to_string(idUser)
    + " group by id_owner)"
    + ",coalesce((select max(id_session) from simplytrackme.sessions),0)+1,"
    + to_string(idType)+",null,"
    +"current_timestamp,"
    +"current_timestamp + interval'" + to_string(duration) + " s',"
    + to_string(totalDistance)
    +","+"0,"
    +to_string(idUser) + ");\n";

    string InsertIntoUserSessions;
    InsertIntoUserSessions +=
    (string)"INSERT INTO simplytrackme.user_sessions (id_user, id_session) VALUES (" + to_string(idUser) + "," +  "(SELECT id_session from simplytrackme.sessions"
        +" where id_owner = "
        + to_string(idUser) + " AND id_localsession = (SELECT max(id_localsession) from simplytrackme.sessions where id_owner = "+to_string(idUser)
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
        string name;
        cin>>name;
        double minV;
        double maxV;
        cin>>minV>>maxV;
        int idUser;
        cin>>idUser;
        int idType;
        cin>>idType;
        cout<<ExtractGPX(name,minV,maxV + 0.001,idUser,idType)<<endl;
    }
}
