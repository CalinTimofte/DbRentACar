package sample;

import MenuUser.MenuUser;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.DatePicker;
import javafx.scene.control.Label;
import javafx.stage.Stage;
import validation.Validation;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

public class Home {
    private MenuUser menuUser = new MenuUser();
    private DbController dbController = new DbController();

    @FXML
    private Label warninglb;

    @FXML
    private ChoiceBox<String> home_oras_pick_up;

    @FXML
    private ChoiceBox<String> home_oras_drop_off;


    @FXML
    private ChoiceBox<String> home_marca;

    @FXML
    private ChoiceBox<String> home_model;

    @FXML
    private ChoiceBox<String> home_clasa;

    @FXML
    private ChoiceBox<String> home_combustibil;

    @FXML
    private DatePicker datepicker_drop;

    /**
     * When this method is called, it will change the Scene to signUp
     */
    public void goToSignUp(ActionEvent event) throws IOException {
        menuUser.goToSignUp(event);
    }

    /**
     * When this method is called, it will change the Scene to LoginAdmin
     */
    public void goToLoginAdmin(ActionEvent event) throws IOException {

        menuUser.goToLoginAdmin(event);
    }

    /**
     * When this method is called, it will change the Scene to Profile
     */
    public void goToProfile(ActionEvent event) throws IOException {

        String msg = menuUser.goToProfile(event);
        if (msg != null)
            warninglb.setText(msg);
    }

    /**
     * When this method is called, it will change the State
     */
    public void logOut(ActionEvent event) throws IOException {
        Integer id = Validation.getId();
        Integer idAdmin = Validation.getId_admin();
        if (idAdmin < 0 && id < 0) {
            warninglb.setText("You are not connected, you can't logout.");
            return;
        }
        if (id >= 0) {
            warninglb.setText(dbController.logout(id));
            Validation.setId(-1);
        }
        if (idAdmin >= 0) {

            Validation.setId_admin(-1);
        }
    }

    @FXML
    public void initialize() {
        warninglb.setText("");
        List<String> idParcari = dbController.afiseazaIdOrasParcari();

        ObservableList obList = FXCollections.observableList(idParcari);
        home_oras_pick_up.getItems().clear();
        obList.add("Select Oras");
        home_oras_pick_up.setValue("Select Oras");
        home_oras_pick_up.getItems().addAll(obList);


        ObservableList obListDrop = FXCollections.observableList(idParcari);
        home_oras_drop_off.getItems().clear();
        obListDrop.add("Select Oras");
        home_oras_drop_off.setValue("Select Oras");
        home_oras_drop_off.getItems().addAll(obListDrop);


        List<String> marca = dbController.afiseazaMarca();

        ObservableList obList5 = FXCollections.observableList(marca);
        home_marca.getItems().clear();
        obList5.add("Marca");
        home_marca.setValue("Marca");
        home_marca.getItems().addAll(obList5);


        List<String> model = dbController.afiseazaModel();
        ObservableList obList6 = FXCollections.observableList(model);
        home_model.getItems().clear();
        obList6.add("Model");
        home_model.setValue("Model");
        home_model.getItems().addAll(obList6);


        List<String> clasa = dbController.afiseazaClasa();
        ObservableList obList7 = FXCollections.observableList(clasa);
        home_clasa.getItems().clear();
        obList7.add("Clasa");
        home_clasa.setValue("Clasa");
        home_clasa.getItems().addAll(obList7);


        List<String> combustibil = dbController.afiseazaCombustibil();
        ObservableList obList8 = FXCollections.observableList(combustibil);
        home_combustibil.getItems().clear();
        obList8.add("Combustibil");
        home_combustibil.setValue("Combustibil");
        home_combustibil.getItems().addAll(obList8);


    }


    public void cautaMasini(ActionEvent event) throws IOException {
        warninglb.setText("");

        String id_parcare = home_oras_pick_up.getValue();
        String id_parcare_drop = home_oras_drop_off.getValue();
        String v_marca = home_marca.getValue();
        String v_model_masina = home_model.getValue();
        String v_clasa = home_clasa.getValue();
        String v_combustibil = home_combustibil.getValue();
        LocalDate date = datepicker_drop.getValue();
        Integer v_id_parcare = 0;
        Integer v_id_parcare_drop = 0;


        if (id_parcare.equals("Select Oras") || id_parcare_drop.equals("Select Oras")) {
            warninglb.setText("Parcarile trebuie sa fie selectate");
            return;
        }

        if (date == null) {
            warninglb.setText("Data trebuie sa fie selectata");
            return;
        }

             //get current date time with Date()
        Date currentDate = new Date();
        Date pickedDate = Date.from(date.atStartOfDay(ZoneId.systemDefault()).toInstant());


        if (currentDate.compareTo(pickedDate) > 0) {
            warninglb.setText("Data aleasa a trecut deja");
            return;
        }


        String id = "";

        for (int i = 0; i < id_parcare.length(); i++) {
            if (id_parcare.charAt(i) != '.')
                id = id + id_parcare.charAt(i);
            else break;
        }

        String id_drop = "";

        for (int i = 0; i < id_parcare_drop.length(); i++) {
            if (id_parcare_drop.charAt(i) != '.')
                id_drop = id_drop + id_parcare_drop.charAt(i);
            else break;
        }


        try {

            v_id_parcare = Integer.parseInt(id);
            v_id_parcare_drop = Integer.parseInt(id_drop);
        } catch (Exception e) {
            warninglb.setText("Probleme de implementare");
            return;
        }


        if (v_marca.equals("Marca")) {
            v_marca = "";
        }
        if (v_model_masina.equals("Model")) {
            v_model_masina = "";
        }

        if (v_clasa.equals("Clasa")) {
            v_clasa = "";
        }

        if (v_combustibil.equals("Combustibil")) {
            v_combustibil = "";
        }

        dbController.afiseaza_masini(v_id_parcare, v_marca, v_model_masina, v_clasa, v_combustibil);


        // trebuie salvat undeva modelul de rezervare
        Rezervari rezervare = new Rezervari(null, null, null, convertToLocalDateViaInstant(currentDate), date, v_id_parcare, v_id_parcare_drop);
        validation.Validation.setRezervare(rezervare);
        goToSearch(event);
    }

    public LocalDate convertToLocalDateViaInstant(Date dateToConvert) {
        return dateToConvert.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
    }

    public void goToSearch(ActionEvent event) throws IOException {

        Parent sceneParent = FXMLLoader.load(getClass().getResource("/sample/Search.fxml"));
        Scene sceneViewScene = new Scene(sceneParent, 800, 500);

        //This line gets the Stage information
        Stage window = (Stage) ((Node) event.getSource()).getScene().getWindow();

        window.setScene(sceneViewScene);
        window.show();
    }

    public void goToAlgoritm(ActionEvent event) throws IOException {

        Parent sceneParent = FXMLLoader.load(getClass().getResource("/sample/Algoritm.fxml"));
        Scene sceneViewScene = new Scene(sceneParent, 800, 500);

        //This line gets the Stage information
        Stage window = (Stage) ((Node) event.getSource()).getScene().getWindow();

        window.setScene(sceneViewScene);
        window.show();
    }



}
