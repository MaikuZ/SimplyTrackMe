#include <iostream>
#include <vector>

std::vector<std::string> words = {"brilliant", "grit", "habit", "horn,",
                                  "preserve", "eternity", "hideous", "hotel", "present", "donut", "andrew",
                                  "the_conquerer",
                                  "fast", "smart", "food", "car", "runners", "swimmers"};

void single_group() {
    std::string exec_psql;
    bool is_private = std::rand() % 2 != 0;
    std::string my_bool = is_private ? "true" : "false";
    exec_psql = "INSERT INTO simplytrackme.groups (name,private) values ('"
                + (words[std::rand() % words.size() + 0]) + '_' + (words[std::rand() % words.size() + 0]) + "\',"
                + my_bool + ");";
    std::cout << exec_psql << std::endl;
}

void generate_groups(int size) {
    for (int i = 0; i < size; i++)
        single_group();
}

int main() {
    srand(time(NULL));
    int nummber;
    std::cin >> nummber;
    generate_groups(nummber);
}

