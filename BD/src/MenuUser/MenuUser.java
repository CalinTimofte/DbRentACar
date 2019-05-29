package MenuUser;

import javafx.event.ActionEvent;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class MenuUser {

    public void goToHomeUser(ActionEvent event) throws IOException
    {
        Parent tableViewParent = FXMLLoader.load(getClass().getResource("/sample/home.fxml"));
        Scene tableViewScene = new Scene(tableViewParent, 800, 500);

        //This line gets the Stage information
        Stage window = (Stage) ((Node) event.getSource()).getScene().getWindow();

        window.setScene(tableViewScene);
        window.show();
    }


    public void goToSignUp(ActionEvent event) throws IOException
    {

        Parent sceneParent = FXMLLoader.load(getClass().getResource("/sample/SignUp.fxml"));
        Scene sceneViewScene = new Scene(sceneParent,800,500);

        //This line gets the Stage information
        Stage window = (Stage)((Node)event.getSource()).getScene().getWindow();

        window.setScene(sceneViewScene);
        window.show();

    }


    public void goToLoginAdmin(ActionEvent event) throws IOException
    {

        Parent sceneParent = FXMLLoader.load(getClass().getResource("/sample/AdminLogin.fxml"));
        Scene sceneViewScene = new Scene(sceneParent,800,500);

        //This line gets the Stage information
        Stage window = (Stage)((Node)event.getSource()).getScene().getWindow();

        window.setScene(sceneViewScene);
        window.show();

    }


    public String goToProfile(ActionEvent event) throws IOException {

        if(validation.Validation.getId().equals(-1) )
        {
            return "You are not logged in";
        }
        Parent sceneParent = FXMLLoader.load(getClass().getResource("/sample/ProfileUser.fxml"));
        Scene sceneViewScene = new Scene(sceneParent, 800, 500);

        //This line gets the Stage information
        Stage window = (Stage) ((Node) event.getSource()).getScene().getWindow();

        window.setScene(sceneViewScene);
        window.show();
        return null;
    }

}
