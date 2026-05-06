package com.cooperative.model;

import java.sql.Timestamp;
import java.sql.Date;

public class Reservation {
    private String idreserv;
    private String idvoit;
    private int idclt;
    private int place;
    private Timestamp dateReserv;  //
    private Date dateVoyage;
    private String payement;
    private int montantAvance;

    // Champs supplémentaires pour affichage
    private String nomClient;
    private String designVoiture;
    private int frais;
    // Ajoutez ces attributs dans la classe Reservation
    private String numtel;


    public Reservation() {}

    // Getters et Setters
    public String getIdreserv() { return idreserv; }
    public void setIdreserv(String idreserv) { this.idreserv = idreserv; }
    public String getIdvoit() { return idvoit; }
    public void setIdvoit(String idvoit) { this.idvoit = idvoit; }
    public int getIdclt() { return idclt; }
    public void setIdclt(int idclt) { this.idclt = idclt; }
    public int getPlace() { return place; }
    public void setPlace(int place) { this.place = place; }
    public Timestamp getDateReserv() { return dateReserv; }
    public void setDateReserv(Timestamp dateReserv) { this.dateReserv = dateReserv; }
    public Date getDateVoyage() { return dateVoyage; }
    public void setDateVoyage(Date dateVoyage) { this.dateVoyage = dateVoyage; }
    public String getPayement() { return payement; }
    public void setPayement(String payement) { this.payement = payement; }
    public int getMontantAvance() { return montantAvance; }
    public void setMontantAvance(int montantAvance) { this.montantAvance = montantAvance; }
    public String getNomClient() { return nomClient; }
    public void setNomClient(String nomClient) { this.nomClient = nomClient; }
    public String getDesignVoiture() { return designVoiture; }
    public void setDesignVoiture(String designVoiture) { this.designVoiture = designVoiture; }
    public int getFrais() { return frais; }
    public void setFrais(int frais) { this.frais = frais; }

    public int getResteAPayer() {
        return frais - montantAvance;
    }
    // Ajoutez ces getters et setters
    public String getNumtel() { return numtel; }
    public void setNumtel(String numtel) { this.numtel = numtel; }
    // Dans Reservation.java, ajoutez cet attribut
    private String designVoitureType;

    // Ajoutez ces getter et setter
    public String getDesignVoitureType() { return designVoitureType; }
    public void setDesignVoitureType(String designVoitureType) { this.designVoitureType = designVoitureType; }

    // Dans Reservation.java, ajoutez cet attribut
    private String typeVoiture;

    // Getters et Setters
    public String getTypeVoiture() { return typeVoiture; }
    public void setTypeVoiture(String typeVoiture) { this.typeVoiture = typeVoiture; }

}

