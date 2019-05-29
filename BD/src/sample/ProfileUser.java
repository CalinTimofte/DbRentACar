package sample;

import MenuUser.MenuUser;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.AnchorPane;

import java.io.IOException;
import java.util.Date;

public class ProfileUser {
    private MenuUser menuUser = new MenuUser();
    private DbController dbController = new DbController();

    @FXML
    private Label profileUsername;

    @FXML
    private Label profileNume;

    @FXML
    private Label profilePrenume;

    @FXML
    private Label profileTelefon;

    @FXML
    private Label profileEmail;

    @FXML
    private TableView<Rezervari> tableIstoricRezervari;


    /**
     * When this method is called, it will change the Scene to home
     */
    public void goToHome(ActionEvent event) throws IOException {
       menuUser.goToHomeUser(event);
    }

    @FXML
    public void initialize() {
        if(validation.Validation.getId() != -1)
        dbController.afiseazaDateProfil(validation.Validation.getId(),  profileUsername, profileNume, profilePrenume, profileTelefon,  profileEmail);

        this.makeTableView();

    }
    private void makeTableView()
    {
        //Id_Rezervare column
        TableColumn<Rezervari, Integer> idRezervareColumn = new TableColumn<>("Id_Rezervare");
        idRezervareColumn.setMinWidth(30);
        idRezervareColumn.setCellValueFactory(new PropertyValueFactory<>("idRezervare"));

        //Id_Masina column
        TableColumn<Rezervari, Integer> idMasinaColumn = new TableColumn<>("Id_Masina");
        idMasinaColumn.setMinWidth(30);
        idMasinaColumn.setCellValueFactory(new PropertyValueFactory<>("idMasina"));

//First rent date column
        TableColumn<Rezervari, Date> firstRentDateColumn = new TableColumn<>("First_rent_date");
        firstRentDateColumn.setMinWidth(90);
        firstRentDateColumn.setCellValueFactory(new PropertyValueFactory<>("firstRentDate"));

        //last rent date column
        TableColumn<Rezervari, Date> lastRentDateColumn = new TableColumn<>("Last_rent_date");
        lastRentDateColumn.setMinWidth(90);
        lastRentDateColumn.setCellValueFactory(new PropertyValueFactory<>("lastRentDate"));


        //Id_Parcare_preluare column
        TableColumn<Rezervari, Integer> idParcarePreluareColumn = new TableColumn<>("Id_parcare_preluare");
        idParcarePreluareColumn.setMinWidth(30);
        idParcarePreluareColumn.setCellValueFactory(new PropertyValueFactory<>("idParcarePreluare"));

        //Id_Parcare_predare column
        TableColumn<Rezervari, Integer> idParcarePredareColumn = new TableColumn<>("Id_parcare_predare");
        idParcarePredareColumn.setMinWidth(30);
        idParcarePredareColumn.setCellValueFactory(new PropertyValueFactory<>("idParcarePredare"));

        tableIstoricRezervari.getItems().clear();
        tableIstoricRezervari.setItems(getRezervari());
        tableIstoricRezervari.getColumns().addAll(idRezervareColumn, idMasinaColumn, firstRentDateColumn, lastRentDateColumn, idParcarePreluareColumn, idParcarePredareColumn);


    }

    //Get all of the products
    public ObservableList<Rezervari> getRezervari(){
        ObservableList<Rezervari> rezervari = FXCollections.observableArrayList();

        dbController.afiseazaIstoricProfil( validation.Validation.getId(),  rezervari);

        return rezervari;
    }

}
