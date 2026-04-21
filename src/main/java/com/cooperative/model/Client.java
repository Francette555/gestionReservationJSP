package com.cooperative.model;

public class Client {
    private int idclt;
    private String nom;
    private String numtel;

    public Client() {}

    public Client(int idclt, String nom, String numtel) {
        this.idclt = idclt;
        this.nom = nom;
        this.numtel = numtel;
    }

    public int getIdclt() { return idclt; }
    public void setIdclt(int idclt) { this.idclt = idclt; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getNumtel() { return numtel; }
    public void setNumtel(String numtel) { this.numtel = numtel; }

    @Override
    public String toString() {
        return "Client{idclt=" + idclt + ", nom='" + nom + "', numtel='" + numtel + "'}";
    }
}