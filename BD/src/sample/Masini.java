package sample;

import java.io.Serializable;

public class Masini implements Serializable {

    private Integer id_masina;
    private String marca;
    private
    String model_masina;
    private
    String clasa;
    private
    Integer pret;
    private
    Integer nota_clienti;
    private
    Integer numar_locuri;
    private
    String optiuni;
    private
    String combustibil;
    private
    Integer numar_note;

    public Masini() {};
   /* public Masini(  String marca, String model_masina, String clasa, Integer pret, Integer nota_clienti, Integer numar_locuri, String optiuni, String combustibil, Integer numar_note) {
       //this.id_masina= id_masina;
        this.marca = marca;
        this.model_masina = model_masina;
        this.clasa = clasa;
        this.pret = pret;
        this.nota_clienti = nota_clienti;
        this.numar_locuri = numar_locuri;
        this.optiuni = optiuni;
        this.combustibil = combustibil;
        this.numar_note = numar_note;
    }*/

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModel_masina() {
        return model_masina;
    }

    public void setModel_masina(String model_masina) {
        this.model_masina = model_masina;
    }

    public String getClasa() {
        return clasa;
    }

    public void setClasa(String clasa) {
        this.clasa = clasa;
    }

    public Integer getPret() {
        return pret;
    }

    public void setPret(Integer pret) {
        this.pret = pret;
    }

    public Integer getNota_clienti() {
        return nota_clienti;
    }

    public void setNota_clienti(Integer nota_clienti) {
        this.nota_clienti = nota_clienti;
    }

    public Integer getNumar_locuri() {
        return numar_locuri;
    }

    public void setNumar_locuri(Integer numar_locuri) {
        this.numar_locuri = numar_locuri;
    }

    public String getOptiuni() {
        return optiuni;
    }

    public void setOptiuni(String optiuni) {
        this.optiuni = optiuni;
    }

    public String getCombustibil() {
        return combustibil;
    }

    public void setCombustibil(String combustibil) {
        this.combustibil = combustibil;
    }

    public Integer getNumar_note() {
        return numar_note;
    }

    public void setNumar_note(Integer numar_note) {
        this.numar_note = numar_note;
    }

    public Integer getId_masina() {
        return id_masina;
    }

    public void setId_masina(Integer id_masina) {
        this.id_masina = id_masina;
    }
}
