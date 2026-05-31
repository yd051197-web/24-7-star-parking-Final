package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionBD {

    public Connection conectar() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // CORREGIDO: Ahora apunta a starparking
            String url = "jdbc:mysql://localhost:3306/starparking";
            String user = "root";
            String pass = "";

            con = DriverManager.getConnection(url, user, pass);
            System.out.println("🔥 CONEXION RECONECTADA CON EXITO A STARPARKING 🔥");

        } catch (Exception e) {
            System.out.println("❌ ERROR REAL MYSQL: " + e);
        }
        return con;
    }
}