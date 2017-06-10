package com.example.piotrhelm.simplytrackme;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

/**
 * Created by bartek on 10.06.17.
 */

public class RankingAdapter extends ArrayAdapter<RankingElement> {
    Context context;
    int layoutResourceId;
    RankingElement elements[] = {new RankingElement("wrong", "wrong")};

    public RankingAdapter(@NonNull Context context, @LayoutRes int resource, @NonNull RankingElement[] objects) {
        super(context, resource, objects);
        this.layoutResourceId = resource;
        this.context = context;
        this.elements = objects;
    }

    @Override
    public View getView(int pos, View convertView, ViewGroup parent) {
        View row = convertView;
        RankingElementHolder holder = null;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new RankingElementHolder();
            holder.title = (TextView) row.findViewById(R.id.rankTitle);
            holder.subtitle = (TextView) row.findViewById(R.id.rankSubtitle);

            row.setTag(holder);
        } else {
            holder = (RankingElementHolder) row.getTag();
        }

        RankingElement object = elements[pos];
        holder.title.setText(object.owner);
        holder.subtitle.setText(object.result);

        return row;
    }
    static class RankingElementHolder {
        TextView title;
        TextView subtitle;
    }
}
