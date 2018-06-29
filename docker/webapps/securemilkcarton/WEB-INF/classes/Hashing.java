// Import required java libraries
import java.io.*;

// Java Servlet imports
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

// SQL imports
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

// Hashing imports
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;

public class Hashing {

 	public static String generateMD5HashValue(String password, String salt) throws NoSuchAlgorithmException, NoSuchProviderException {
		String generatedPassword = null;
		try {
			// Create MessageDigest instance for MD5
			MessageDigest md = MessageDigest.getInstance("MD5");

            // Combine salt (string in base64) with password (string)
            String passwordToHash = salt + password;
			
            // Convert passwordToHash (the combined salt and password) into bytes
            byte[] bytes = md.digest(passwordToHash.getBytes());            
            
            // Create a new StringBuilder object to convert hash (in bytes) to a string
            StringBuilder sb = new StringBuilder();

            // Loop through bytes array
            for (int i = 0; i < bytes.length; i++) {
            // For each character in array ...
            // Convert to hexidecimal (base16)
            // Append to StringBuilder object
            sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
            }

            // Finally, copy StringBuilder object to the generatedPassword variable
            generatedPassword = sb.toString();
            
            // And return the hashed salt + password
            return generatedPassword;
            
            } catch (NoSuchAlgorithmException e) {
                // Print output to catalina.out log file
                System.out.println(">>> ERROR: Failed hashing salt + password.");
                // Print the error message
                e.printStackTrace();
                
                // And return an empty string
                return "";
            }
    }
    
    public static String fetchSaltValue(String username) {
  // Initialize salt variable	
  String salt = null;

  // Using the supplied username, fetch the salt value from the database
  // Specifically, lookup username in users table
  try {
   Class.forName("com.mysql.jdbc.Driver");
   // Connect to MySQL database on localhost on port 3306
   // Use username of "root" and password of "passw0rd"
   Connection conn = DriverManager.getConnection("jdbc:mysql://db:3306/securemilkcarton?autoReconnect=true&useSSL=false", "root", "passw0rd");

   // Create an SQL statement to insert name, comment into database 
   // This page uses a prepared statement
   // THIS IS GOOD SECURITY !!!!!!!!!!
   conn.setAutoCommit(false);
   String sql = "SELECT salt FROM users WHERE username=?";
   PreparedStatement ps = conn.prepareStatement(sql);
   ps.setString(1, username);

   // Print output to catalina.out log file
   System.out.println("  > Using the following SQL statement:");
   System.out.println("  > " + ps); // Not sure if this can be printed

   // Execute the query against the database
   ResultSet rs = ps.executeQuery();

   if (rs.next()) {
    // If username has a salt value in the database 
    salt = rs.getString("salt");
   } else {
    // Display a simple HTML page of invalid login
    System.out.println(">>> ERROR: Could not find username in the users table.");
    System.out.println("  > ERROR: Setting salt value as empty string.");
    salt = "";
   }
   conn.close();
  } catch (Exception e) {
                // Print output to catalina.out log file
                System.out.println(">>> ERROR: Failed fetching salt.");
                // Print the error message
                e.printStackTrace();
                
                // And set an empty string for the salt value
                salt = "";  }

  // Return the salt value
  return salt;
 }
}