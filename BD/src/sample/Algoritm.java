package sample;

import MenuUser.MenuUser;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;

import java.io.IOException;
import java.util.List;

public class Algoritm {
    private MenuUser menuUser = new MenuUser();
    private DbController dbController = new DbController();

    @FXML
    private ChoiceBox<String> choice_algoritm_parcare1;
    @FXML
    private ChoiceBox<String> choice_algoritm_parcare2;
    @FXML
    private Label warning_algoritm;
    @FXML
    private TextArea afisare_drum;

    @FXML
    public void initialize() {
        warning_algoritm.setText("");
        List<String> idParcari = dbController.afiseazaIdOrasParcari();

        ObservableList obList_alg = FXCollections.observableList(idParcari);
        choice_algoritm_parcare1.getItems().clear();
        obList_alg.add("Select Parcare");
        choice_algoritm_parcare1.setValue("Select Parcare");
        choice_algoritm_parcare1.getItems().addAll(obList_alg);


        ObservableList obListDrop_alg = FXCollections.observableList(idParcari);
        choice_algoritm_parcare2.getItems().clear();
        obListDrop_alg.add("Select Parcare");
        choice_algoritm_parcare2.setValue("Select Parcare");
        choice_algoritm_parcare2.getItems().addAll(obListDrop_alg);
    }

    public void goToHome(ActionEvent event) throws IOException {
        menuUser.goToHomeUser(event);
    }

    public void apeleazaAlgoritm(ActionEvent event) throws IOException {
        warning_algoritm.setText("");

        if (choice_algoritm_parcare1.getValue().equals("Select Parcare") || choice_algoritm_parcare2.getValue().equals("Select Parcare")) {
            warning_algoritm.setText("Parcarile trebuie sa fie selectate");
            return;
        }

        String id_parcare = choice_algoritm_parcare1.getValue();
        String id_parcare_drop = choice_algoritm_parcare2.getValue();

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

        Integer v_id_parcare;
        Integer v_id_parcare_drop;

        try {
            v_id_parcare = Integer.parseInt(id);
            v_id_parcare_drop = Integer.parseInt(id_drop);
        } catch (Exception e) {
            warning_algoritm.setText("Probleme neasteptate");
            return;
        }

      Integer status = dbController.apeleazaAlgoritm( v_id_parcare ,v_id_parcare_drop,afisare_drum);
        if(status == 0 )
        {
            warning_algoritm.setText("Ceva nu a mers bine :( ");
            return;
        }

    }
}
