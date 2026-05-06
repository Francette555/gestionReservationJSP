package com.cooperative.model;

import java.util.List;

public class PlacesResponse {
    private boolean success;
    private List<Integer> places;
    private String error;

    // Getters et Setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public List<Integer> getPlaces() { return places; }
    public void setPlaces(List<Integer> places) { this.places = places; }
    public String getError() { return error; }
    public void setError(String error) { this.error = error; }
}