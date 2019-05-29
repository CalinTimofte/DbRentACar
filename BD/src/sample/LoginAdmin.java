package sample;

import MenuUser.MenuUser;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;

import java.io.IOException;

public class LoginAdmin {
    private MenuUser menuUser = new MenuUser();
    private DbController dbController = new DbController();

    @FXML
    private TextField usernameLoginAdmin;
    @FXML
    private TextField passwordLoginAdmin;

    @FXML
    private Label error_admin_username;
    @FXML
    private Label error_admin_password;
    @FXML
    private Label warrning_admin_username;

    /**
     * When this method is called, it will change the Scene to home
     */
    public void goToHome(ActionEvent event) throws IOException {
      menuUser.goToHomeUser(event);
    }

    @FXML
    public void LoginAdmin() {
        boolean isUsernameEmpty = validation.Validation.isTextFieldNoEmpty(usernameLoginAdmin, error_admin_username, "Username is required.");
        boolean isPasswordEmpty = validation.Validation.isTextFieldNoEmpty(passwordLoginAdmin, error_admin_password, "Password is required.");
        if (isUsernameEmpty && isPasswordEmpty) {

           Integer id_admin = dbController.loginAdmin(usernameLoginAdmin.getText(),passwordLoginAdmin.getText());
if(id_admin ==-1)
{
    warrning_admin_username.setText("Failde login");
}
else warrning_admin_username.setText("Login as admin succesful");
        }
    }


}
