package validation;

import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import sample.Rezervari;

public class Validation {
    private static Integer id = -1 ;
    private static Integer id_admin = -1;
    public static Rezervari rezervare;

    public static boolean isValueNoEmpty(String val) {

        if (val != null || !val.isEmpty())
           return true;
        return false;
    }

  private static boolean isTextFieldNoEmpty(TextField tf) {
        boolean bool = false;
        if (tf.getText().length() != 0 || !tf.getText().isEmpty())
            bool = true;
        return bool;
    }

    //check
    public static boolean isTextFieldNoEmpty(TextField tf, Label lb, String errorMessage) {
        boolean bool = true;
        String msg = null;
        if (!isTextFieldNoEmpty(tf)) {
            bool = false;
        msg=errorMessage;
        }
        lb.setText(msg);
        return bool;
    }

    public static Integer getId() {
        return id;
    }

    public static void setId(Integer id) {
        Validation.id = id;
    }

    public static Integer getId_admin() {
        return id_admin;
    }

    public static void setId_admin(Integer id_admin) {
        Validation.id_admin = id_admin;
    }

    public static Rezervari getRezervare() {
        return rezervare;
    }

    public static void setRezervare(Rezervari rezervare) {
        Validation.rezervare = rezervare;
    }
}
