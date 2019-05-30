package sample;

import MenuUser.MenuUser;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.util.ArrayList;
import java.util.Scanner;


public class Search {
    private MenuUser menuUser = new MenuUser();
    private DbController dbController = new DbController();
    private static final String filepath = "C:\\Users\\bianc\\OneDrive\\Desktop\\SGBD-GIT\\DbRentACar\\Db\\tempdoc.txt";
    private Integer page = 0;
    private Boolean ultimaPagina = false;

    @FXML
    private TableView<Masini> tabel_masini;

    @FXML
    private Label warning_search;

    @FXML
    public void initialize() {
        warning_search.setText("");
        makeTableMasini();
    }

    private void makeTableMasini() {
        // id;
        TableColumn<Masini, Integer> idColumn = new TableColumn<>("ID");
        idColumn.setMinWidth(30);
        idColumn.setCellValueFactory(new PropertyValueFactory<>("id_masina"));

        //marca
        TableColumn<Masini, String> marcaColumn = new TableColumn<>("Marca");
        marcaColumn.setMinWidth(30);
        marcaColumn.setCellValueFactory(new PropertyValueFactory<>("marca"));

        // model_masina;
        TableColumn<Masini, String> model_masinaColumn = new TableColumn<>("Model Masina");
        model_masinaColumn.setMinWidth(30);
        model_masinaColumn.setCellValueFactory(new PropertyValueFactory<>("model_masina"));

        //clasa;
        TableColumn<Masini, String> clasaColumn = new TableColumn<>("Clasa");
        clasaColumn.setMinWidth(30);
        clasaColumn.setCellValueFactory(new PropertyValueFactory<>("clasa"));

        // pret;
        TableColumn<Masini, Integer> pretColumn = new TableColumn<>("Pret");
        pretColumn.setMinWidth(30);
        pretColumn.setCellValueFactory(new PropertyValueFactory<>("pret"));

        //nota_clienti;
        TableColumn<Masini, Integer> nota_clientiColumn = new TableColumn<>("Nota");
        nota_clientiColumn.setMinWidth(30);
        nota_clientiColumn.setCellValueFactory(new PropertyValueFactory<>("nota_clienti"));


        // numar_locuri;
        TableColumn<Masini, Integer> numar_locuriColumn = new TableColumn<>("Numar locuri");
        numar_locuriColumn.setMinWidth(30);
        numar_locuriColumn.setCellValueFactory(new PropertyValueFactory<>("numar_locuri"));


        // optiuni;
        TableColumn<Masini, String> optiuniColumn = new TableColumn<>("Optiuni");
        optiuniColumn.setMinWidth(30);
        optiuniColumn.setCellValueFactory(new PropertyValueFactory<>("optiuni"));

        // combustibil;
        TableColumn<Masini, String> combustibilColumn = new TableColumn<>("Combustibil");
        combustibilColumn.setMinWidth(30);
        combustibilColumn.setCellValueFactory(new PropertyValueFactory<>("combustibil"));

        popularetabel();
        tabel_masini.getColumns().addAll(idColumn, marcaColumn, model_masinaColumn, clasaColumn, pretColumn, nota_clientiColumn, numar_locuriColumn, optiuniColumn, combustibilColumn);


    }

    public void popularetabel() {
        if (!new File(filepath).exists()) {
            warning_search.setText("Fisierul nu a fost gasit");
            return;
        }

        tabel_masini.getItems().clear();
        tabel_masini.setItems(getMasini());
    }

    //Get all of the products
    public ObservableList<Masini> getMasini() {
        ObservableList<Masini> masini = FXCollections.observableArrayList();


        getPage(masini);

        return masini;
    }

    public void getPage(ObservableList<Masini> masini) {
        ArrayList<String> masiniList = new ArrayList<>(100000);
        //read from file
        File file = new File(filepath);
        try {
            Scanner sc = new Scanner(file);
            while (sc.hasNextLine()) {
                masiniList.add(sc.nextLine());
            }
        } catch (Exception e) {
            System.out.println("File not found exception, problem");
            return;
        }
        int initial = 10 * page;
        for (int i = initial; i < initial + 10; i++) {
            try {
                String str = masiniList.get(i);
                String[] arrOfStr = str.split(" ", 12);

                Masini oMasina = new Masini();
                int j = 0;
                for (String a : arrOfStr) {
                    switch (j) {
                        case 0:
                            j++;
                            try {
                                oMasina.setId_masina(Integer.parseInt(a));
                            } catch (Exception e) {

                                warning_search.setText("Probleme de implementare.");
                                return;
                            }
                            break;
                        case 1:
                            oMasina.setMarca(a);
                            j++;
                            break;

                        case 2:
                            oMasina.setModel_masina(a);
                            j++;
                            break;
                        case 3:
                            oMasina.setClasa(a);
                            j++;
                            break;
                        case 4: //pret
                            j++;
                            try {
                                oMasina.setPret(Integer.parseInt(a));
                            } catch (Exception e) {
                                warning_search.setText("Probleme de implementare");
                                return;
                            }
                            break;
                        case 5: //note  clienti
                            j++;
                            try {
                                oMasina.setNota_clienti(Integer.parseInt(a));
                            } catch (Exception e) {
                                warning_search.setText("Probleme de implementare");
                                return;
                            }
                            break;

                        case 6:
                            j++;
                            try {
                                oMasina.setNumar_locuri(Integer.parseInt(a));
                            } catch (Exception e) {
                                warning_search.setText("Probleme de implementare");
                                return;
                            }
                            break;
                        case 7:
                            oMasina.setOptiuni(a);
                            j++;
                            break;
                        case 8:
                            oMasina.setCombustibil(a);
                            j++;
                            break;

                        case 9:
                            j++;
                            try {
                                oMasina.setNumar_note(Integer.parseInt(a));
                            } catch (Exception e) {
                                warning_search.setText("Probleme de implementare");
                                return;
                            }
                            break;

                        default:
                            warning_search.setText("Probleme la citire");
                            return;
                    }

                }

                masini.add(oMasina);
            } catch (Exception e) {
                ultimaPagina = true;
                return;
            }
        }
    }


    public void nextPage(ActionEvent event) throws IOException {
        warning_search.setText("");
        if (ultimaPagina == false)
            this.page++;
        else warning_search.setText("Ati ajuns la ultima pagina");
        popularetabel();
    }

    public void previousPage(ActionEvent event) throws IOException {
        warning_search.setText("");
        if (page >= 1) {
            this.page--;
            ultimaPagina = false;
        } else warning_search.setText("Ati ajuns la prima pagina");

        popularetabel();
    }

    public void goToHome(ActionEvent event) throws IOException {


        page = 0;
        menuUser.goToHomeUser(event);


    }

    public void makeRezervation(ActionEvent event) throws IOException {


        if (validation.Validation.getId().equals(-1)) {
            warning_search.setText("You are not logged in, you can't add a reservation");
            return;
        }

        ObservableList<Masini> masiniList;
       masiniList=tabel_masini.getSelectionModel().getSelectedItems();

       if (masiniList.isEmpty())
       {
           warning_search.setText("Please select a car to make a reservation");
           return;
       }
       Integer id= masiniList.get(0).getId_masina();

    Integer status= dbController.mekeReservation(id);
       if(status==1)
       {
           warning_search.setText("Rezervare inregistrata");
           return;
       }
        warning_search.setText("Rezervare nu a putut fi inregistrata");
        return;

        }


}
