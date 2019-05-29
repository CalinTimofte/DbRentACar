package sample;

import java.time.LocalDate;


public class Rezervari {

    private Integer idRezervare;
    private Integer idClient;
    private Integer idMasina;
    private LocalDate firstRentDate;
    private LocalDate lastRentDate;
    private Integer idParcarePreluare;
    private Integer idParcarePredare;

    public Rezervari(Integer idRezervare, Integer idMasina, LocalDate firstRentDate, LocalDate lastRentDate, Integer idParcarePreluare, Integer idParcarePredare) {
        this.idRezervare = idRezervare;
        this.idMasina = idMasina;
        this.firstRentDate = firstRentDate;
        this.lastRentDate = lastRentDate;
        this.idParcarePreluare = idParcarePreluare;
        this.idParcarePredare = idParcarePredare;
    }
    public Rezervari(Integer idRezervare,Integer idClient, Integer idMasina, LocalDate firstRentDate, LocalDate lastRentDate, Integer idParcarePreluare, Integer idParcarePredare) {
        this.idRezervare = idRezervare;
        this.idClient=idClient;
        this.idMasina = idMasina;
        this.firstRentDate = firstRentDate;
        this.lastRentDate = lastRentDate;
        this.idParcarePreluare = idParcarePreluare;
        this.idParcarePredare = idParcarePredare;
    }

    public Integer getIdRezervare() {
        return idRezervare;
    }

    public void setIdRezervare(Integer idRezervare) {
        this.idRezervare = idRezervare;
    }

    public Integer getIdMasina() {
        return idMasina;
    }

    public void setIdMasina(Integer idMasina) {
        this.idMasina = idMasina;
    }

    public LocalDate getFirstRentDate() {
        return firstRentDate;
    }

    public void setFirstRentDate(LocalDate firstRentDate) {
        this.firstRentDate = firstRentDate;
    }

    public LocalDate getLastRentDate() {
        return lastRentDate;
    }

    public void setLastRentDate(LocalDate lastRentDate) {
        this.lastRentDate = lastRentDate;
    }

    public Integer getIdParcarePreluare() {
        return idParcarePreluare;
    }

    public void setIdParcarePreluare(Integer idParcarePreluare) {
        this.idParcarePreluare = idParcarePreluare;
    }

    public Integer getIdParcarePredare() {
        return idParcarePredare;
    }

    public void setIdParcarePredare(Integer idParcarePredare) {
        this.idParcarePredare = idParcarePredare;
    }

    public Integer getIdClient() {
        return idClient;
    }

    public void setIdClient(Integer idClient) {
        this.idClient = idClient;
    }
}