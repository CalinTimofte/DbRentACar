package sample;

import MenuUser.MenuUser;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import java.io.IOException;


public class SignUp {
    private DbController dbController = new DbController();

    private MenuUser menuUser=new MenuUser();
    // for login
    @FXML
    private Label error_username_login;
    @FXML
    private Label error_password_login;
    @FXML
    private TextField usernameLogin;
    @FXML
    private TextField passwordLogin;


    //for register
    @FXML
    private Label    warningRegisterUser;

    @FXML
    private Label    warningLoginUser;

    @FXML
    private Label error_username_register;
    @FXML
    private Label error_parola_register;
    @FXML
    private Label error_nume_register;
    @FXML
    private Label error_prenume_register;
    @FXML
    private Label error_telefon_register;
    @FXML
    private Label error_email_register;
    @FXML
    private Label error_permis_register;
    @FXML
    private TextField username_register;
    @FXML
    private TextField nume_register;
    @FXML
    private TextField prenume_register;
    @FXML
    private TextField telefon_register;
    @FXML
    private TextField email_register;
    @FXML
    private TextField parola_register;
    @FXML
    private TextField permis_register;


    @FXML
    public void Login() {
        boolean isUsernameEmpty = validation.Validation.isTextFieldNoEmpty(usernameLogin, error_username_login, "Username is required.");
        boolean isPasswordEmpty = validation.Validation.isTextFieldNoEmpty(passwordLogin, error_password_login, "Password is required.");
        if (isUsernameEmpty && isPasswordEmpty) {

            Integer id = dbController.loginUser(usernameLogin.getText(),passwordLogin.getText());
            System.out.println(id);
            if(id==-1) {
                warningLoginUser.setText("Login nereusit :( ");
                return;
            }
            if(id>=0)
            {
                validation.Validation.setId(id);
                warningLoginUser.setText("Login realizat cu succes");
                return;
            }

        }
    }

    public void Register() {
        boolean isUsernameValid = validation.Validation.isTextFieldNoEmpty(username_register, error_username_register, "Username trebuie completat.");
        boolean isNameValid = validation.Validation.isTextFieldNoEmpty(nume_register, error_nume_register, "Numele trebuie completat.");
        boolean isPrenumeValid = validation.Validation.isTextFieldNoEmpty(prenume_register, error_prenume_register, "Prenumle trebuie completat.");
        boolean isTelefonValid = validation.Validation.isTextFieldNoEmpty(telefon_register, error_telefon_register, "Numarul de telefon trebuie completat.");
        boolean isEmailValid = validation.Validation.isTextFieldNoEmpty(email_register, error_email_register, "Email-ul trebuie completat.");
        boolean isPasswordValid = validation.Validation.isTextFieldNoEmpty(parola_register, error_parola_register, "Password trebuie completat.");
        boolean isPermisValid = validation.Validation.isTextFieldNoEmpty(permis_register, error_permis_register, "Numarul permisului trebuie completat.");


        if (isUsernameValid && isPasswordValid && isNameValid && isPrenumeValid && isTelefonValid && isEmailValid && isPermisValid) {


                   Integer status = dbController.registerUser(username_register.getText(),nume_register.getText() ,prenume_register.getText() ,telefon_register.getText(), email_register.getText(), parola_register.getText(), permis_register.getText()) ;
            if (status == 0) {
                warningRegisterUser.setText( "Date invalide");
                return;
            }
            if (status == 1) {
                warningRegisterUser.setText( "Inregistrare reusita. Please login now.") ;
                return;
            }

            warningRegisterUser.setText( "A aparut o problema la baza de date") ;

        }
    }

    /**
     * When this method is called, it will change the Scene to home
     */
    public void goToHome(ActionEvent event) throws IOException {

       menuUser.goToHomeUser(event);
    }

}
