package sample;

import javafx.collections.ObservableList;
import javafx.scene.Cursor;
import javafx.scene.control.Label;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DbController {


    public List<String> afiseazaIdOrasParcari() {
        List<String> idParcare = new ArrayList<>();

        try {
            Connection con = Database.getConnection();

            Statement getParcari = con.createStatement();
            ResultSet rs = getParcari.executeQuery("SELECT * FROM parcari");

            while (rs.next()) {
                idParcare.add(rs.getInt("Id_parcare") + ". " + rs.getString("Oras")+ " "+ rs.getString("Adresa"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return idParcare;
    }




    public List<String> afiseazaMarca() {
        List<String> marca = new ArrayList<>();

        try {
            Connection con = Database.getConnection();

            Statement getMarca = con.createStatement();
            ResultSet rs = getMarca.executeQuery("SELECT distinct marca FROM masini order by marca");

            while (rs.next()) {
                marca.add(rs.getString("marca"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }


        return marca;
    }

    public List<String> afiseazaModel() {
        List<String> model = new ArrayList<>();

        try {
            Connection con = Database.getConnection();

            Statement getModel = con.createStatement();
            ResultSet rs = getModel.executeQuery("SELECT distinct model_masina FROM masini");

            while (rs.next()) {
                model.add(rs.getString("model_masina"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }


        return model;
    }


    public List<String> afiseazaClasa() {
        List<String> clasa = new ArrayList<>();

        try {
            Connection con = Database.getConnection();

            Statement getClasa = con.createStatement();
            ResultSet rs = getClasa.executeQuery("SELECT distinct clasa FROM masini order by clasa");

            while (rs.next()) {
                clasa.add(rs.getString("clasa"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }


        return clasa;
    }


    public List<String> afiseazaCombustibil() {
        List<String> combustibil = new ArrayList<>();

        try {
            Connection con = Database.getConnection();

            Statement getModel = con.createStatement();
            ResultSet rs = getModel.executeQuery("SELECT distinct combustibil FROM masini");

            while (rs.next()) {
                combustibil.add(rs.getString("combustibil"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }


        return combustibil;
    }

    public String logout(Integer id) {

        String mesaj ="";
        try {
            Connection con = Database.getConnection();
            CallableStatement cstmt = con.prepareCall("{call logoutUser(?,?)}");
            cstmt.registerOutParameter("mesaj", java.sql.Types.VARCHAR);
            cstmt.setInt("v_id_user", id);

            cstmt.execute();
             mesaj = cstmt.getString("mesaj");
           return mesaj;
        } catch (java.sql.SQLException e) {
            System.out.println("Exception from database.");
        }
        return mesaj;
    }


    public void afiseazaDateProfil(Integer id, Label profileUsername, Label profileName, Label profilePassword, Label profileTelefon, Label profileEmail) {


        try {
            Connection con = Database.getConnection();
            CallableStatement cstmt = con.prepareCall("{call profil_utilizator(?,?,?,?,?,?)}");
            cstmt.registerOutParameter("v_username", java.sql.Types.VARCHAR);
            cstmt.registerOutParameter("v_nume", java.sql.Types.VARCHAR);
            cstmt.registerOutParameter("v_prenume", java.sql.Types.VARCHAR);
            cstmt.registerOutParameter("v_numar_telefon", java.sql.Types.VARCHAR);
            cstmt.registerOutParameter("v_email", java.sql.Types.VARCHAR);

            cstmt.setInt("v_id_user", id);

            cstmt.execute();

            profileUsername.setText(cstmt.getString("v_username"));
            profileName.setText(cstmt.getString("v_nume"));
            profilePassword.setText(cstmt.getString("v_prenume"));
            profileTelefon.setText(cstmt.getString("v_numar_telefon"));
            profileEmail.setText(cstmt.getString("v_email"));

        } catch (java.sql.SQLException e) {
            System.out.println("Exception from database.");
        }

    }

    public void afiseazaIstoricProfil(Integer v_id_client, ObservableList<Rezervari> rezervari) {


        try {
            Connection con = Database.getConnection();


            String sql = "SELECT * FROM rezervari WHERE id_client = ? ORDER BY FIRST_RENT_DATE DESC";

            PreparedStatement prepStmt = con.prepareStatement(sql);
            prepStmt.setInt(1, v_id_client);
            ResultSet rs = prepStmt.executeQuery();

            while (rs.next()) {
                rezervari.add(new Rezervari(rs.getInt("ID_REZERVARI"), rs.getInt("ID_MASINA"), rs.getDate("FIRST_RENT_DATE").toLocalDate(), rs.getDate("LAST_RENT_DATE").toLocalDate(), rs.getInt("ID_PARCARE_PRELUARE"), rs.getInt("ID_PARCARE_PREDARE")));
            }


        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            System.out.println("Exception from database. Istoric Profil");
        }
    }

    public Integer registerUser(String userUsername, String userNume, String userPrenume, String userTelefon, String userEmail, String userParola, String userPermis) {

        Integer status = -1;
        try {
            Connection con = Database.getConnection();
            CallableStatement cstmt = con.prepareCall("{?= call register_user(?,?,?,?,?,?,?)}");
            cstmt.registerOutParameter(1, Types.INTEGER);
            cstmt.setString(2, userUsername);
            cstmt.setString(3, userNume);
            cstmt.setString(4, userPrenume);
            cstmt.setString(5, userTelefon);
            cstmt.setString(6, userEmail);
            cstmt.setString(7, userParola);
            cstmt.setString(8, userPermis);


            cstmt.execute();
            status = cstmt.getInt(1);


        } catch (java.sql.SQLException e) {

            System.out.println(" Exceptie sql");
        }
        return status;
    }


    public Integer loginUser(String usernameLogin, String passwordLogin) {
        Integer id = -1;

        try {
            Connection con = Database.getConnection();
            String sql = "SELECT * FROM clienti WHERE USERNAME = ? AND PAROLA = ?";

            PreparedStatement prepStmt = con.prepareStatement(sql);
            prepStmt.setString(1, usernameLogin);
            prepStmt.setString(2, passwordLogin);

            ResultSet rs = prepStmt.executeQuery();
while(rs.next())
         id = rs.getInt("ID_CLIENT");

if(id != -1) {
    login_istoric(id);
    return id;
}
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            System.out.println(" Exceptie sql");
        }

        return id;
    }


    public void login_istoric(Integer id) {

        try {
            Connection con = Database.getConnection();
            CallableStatement cstmt = con.prepareCall("{call login_istoric(?)}");
            cstmt.setInt("v_id_client", id);

            cstmt.execute();

        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            System.out.println("Exception from database.");
        }
    }

    public Integer loginAdmin(String usernameLogin, String passwordLogin) {
        Integer id = -1;

        try {
            Connection con = Database.getConnection();
            String sql = "SELECT * FROM admini WHERE USERNAME ='" +usernameLogin+"' AND PAROLA ='"+passwordLogin+"'";
            PreparedStatement prepStmt = con.prepareStatement(sql);
            ResultSet rs = prepStmt.executeQuery();

            while(rs.next())
                id = rs.getInt("ID_ADMIN");

            if(id != -1) {
                return id;
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            System.out.println(" Exceptie sql");
        }

        return id;
    }


    public void afiseaza_masini(Integer v_id_parcare ,String v_marca ,String v_model_masina ,String v_clasa ,String v_combustibil ) {


        try {
            Connection con = Database.getConnection();
            CallableStatement cstmt = con.prepareCall("{call afiseaza_masini(?,?,?,?,?)}");
            cstmt.setInt("v_id_parcare ", v_id_parcare);
            cstmt.setString("v_marca",v_marca);
            cstmt.setString("v_model_masina",v_model_masina);
            cstmt.setString("v_clasa",v_clasa);
            cstmt.setString("v_combustibil",v_combustibil);

            cstmt.execute();

        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            System.out.println("Exception from database.");
        }
    }

}
