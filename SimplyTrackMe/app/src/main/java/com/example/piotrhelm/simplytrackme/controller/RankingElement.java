package com.example.piotrhelm.simplytrackme.controller;

import java.io.Serializable;

/**
 * Created by bartek on 10.06.17.
 */

public class RankingElement implements Serializable {
    public String owner;
    public String result;
    public RankingElement() {

    }
    public RankingElement(String owner, String result) {
        this.owner = owner;
        this.result = result;
    }
}
