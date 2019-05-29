package sample;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

    public class Database {
        private static final String URL = "jdbc:oracle:thin:@localhost:1521:xe";
        private static final String USER = "STUDENT";
        private static final String PASSWORD = "STUDENT";
        private static Connection connection = null;
        private Database() { }
        public static Connection getConnection() {
            if (connection == null) {
                createConnection();
            }
            return connection;
        }

        public static void createConnection()
        {
            try {
                Class.forName("oracle.jdbc.OracleDriver");
                connection= DriverManager.getConnection(URL,USER,PASSWORD);

            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            }


        }
        public static  void closeConnection()
        {
            try{
                connection.close() ;
            } catch(SQLException e) {
                System.err.println("SQLException: " + e) ;
            }

        }

        public static void rollback()
        {
            try {
                connection.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
