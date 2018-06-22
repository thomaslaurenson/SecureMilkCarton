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

// Hashing imports
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;

@WebServlet(name = "login", urlPatterns = {
 "/login"
})
public class Login extends HttpServlet {

 protected void processRequest(HttpServletRequest request, HttpServletResponse response)
 throws ServletException, IOException {
  response.setContentType("text/html;charset=UTF-8");
  PrintWriter out = response.getWriter();
  try {

   System.out.println(">>> Starting securemilkcarton login...");

   // Get the username + password from the user inputs
   String username = request.getParameter("username");
   String password = request.getParameter("password");

   // Print output to catalina.out
   System.out.println(">>> User provided the following credentials:");
   System.out.println("  > Username: " + username);
   System.out.println("  > Password: " + password);

   // Get the user's salt value from the database
   String salt = Hashing.fetchSaltValue(username);

   // Perform MD5 Hash of password
   String hashedPassword = null;
   try 
   {
       hashedPassword = Hashing.generateMD5HashValue(password, salt);
   }
   catch (NoSuchAlgorithmException | NoSuchProviderException e)
   {
       e.printStackTrace();
   }
   
   // Print output to catalina.out
   System.out.println(">>> Attempting login with the following credentials:");
   System.out.println("  > Username: " + username);
   System.out.println("  > Hashed password: " + hashedPassword);
   System.out.println("  > Salt: " + salt);

   try {
    Class.forName("com.mysql.jdbc.Driver");
    // Connect to MySQL database on localhost on port 3306
    // Use username of "root" and password of "passw0rd"
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/securemilkcarton?autoReconnect=true&useSSL=false", "root", "passw0rd");

    // Create an SQL statement to query database for username/password
    Statement st = conn.createStatement();
    String sql = "SELECT * FROM users WHERE username='" + username + "' AND password='" + hashedPassword + "'";

    // Print output to catalina.out log file
    System.out.println("  > Using the following SQL query:");
    System.out.println("  > " + sql);

    // Execute the query against the database
    ResultSet rs = st.executeQuery(sql);

    if (rs.next()) {
     // If username and password match, login and display the seach.jsp page
     HttpSession session = request.getSession();
     session.setAttribute("username", username);
     response.sendRedirect("search.jsp");
    } else {
     // Display a simple HTML page of invalid login
     out.println("<h1>Invalid Login</h1>");
     out.println("Executed query: " + sql);
     out.println("<br/>");
     out.println("Use the back button in your brower to try again...");
    }
    conn.close();
   } catch (Exception e) {
    e.printStackTrace();
   }
  } finally {
   out.close();
  }
 }
 
 /**
  * Handles the HTTP GET method.
  * @param request servlet request
  * @param response servlet response
  * @throws ServletException if a servlet-specific error occurs
  * @throws IOException if an I/O error occurs
  */
 @Override
 protected void doGet(HttpServletRequest request, HttpServletResponse response)
 throws ServletException, IOException {
  processRequest(request, response);
 }

 /**
  * Handles the HTTP POST method.
  * @param request servlet request
  * @param response servlet response
  * @throws ServletException if a servlet-specific error occurs
  * @throws IOException if an I/O error occurs
  */
 @Override
 protected void doPost(HttpServletRequest request, HttpServletResponse response)
 throws ServletException, IOException {
  processRequest(request, response);
 }

 /**
  * Returns a short description of the servlet.
  * @return a String containing servlet description
  */
 @Override
 public String getServletInfo() {
  return "Secure Milk Carton: Written by a Really Bad Web Developer";
 }
}