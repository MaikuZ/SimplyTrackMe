package com.example.piotrhelm.simplytrackme;

import java.util.ArrayList;

/**
 * Created by mz on 06.05.17.
 */

class Person {
    public Person() {
        this.name = "DUMMY MAN";
    }
    public Person(String name) {
        this.name = name;
    }
    String name;
    Integer age;
    Integer height;
    Integer weight;
    ArrayList<Person> Friends;

    public Person(String name, Integer age, Integer height, Integer weight) {
        this.name = name;
        this.age = age;
        this.height = height;
        this.weight = weight;
    }
}

