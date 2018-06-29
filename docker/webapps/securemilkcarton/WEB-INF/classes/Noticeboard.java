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

@WebServlet(name = "noticeboard", urlPatterns = {
 "/noticeboard"
})
public class Noticeboard extends HttpServlet {

 protected void processRequest(HttpServletRequest request, HttpServletResponse response)
 throws ServletException, IOException {
  response.setContentType("text/html;charset=UTF-8");
  PrintWriter out = response.getWriter();
  try {

   System.out.println(">>> Starting NotceBoard update...");

   // Fetch the name and comments that are input by the user
   String name = request.getParameter("name");
   String comments = request.getParameter("comments");

   System.out.println("  > Addind message to noticeboard using:");
   System.out.println("  > Name: " + name);
   System.out.println("  > Comments: " + comments);

   try {
    Class.forName("com.mysql.jdbc.Driver");
    // Connect to MySQL database on localhost on port 3306
    // Use username of "root" and password of "passw0rd"
    Connection conn = DriverManager.getConnection("jdbc:mysql://db:3306/securemilkcarton?autoReconnect=true&useSSL=false", "root", "passw0rd");

    // Create an SQL statement to insert name, comment into database 
    conn.setAutoCommit(false);
    String sql = "INSERT into noticeboard (name, comments) VALUES ('" + name + "', '" + comments + "')";
    Statement st = conn.prepareStatement(sql);

    // Print output to catalina.out log file
    System.out.println("  > Using the following SQL query:");
    System.out.println("  > " + sql);

    // Update the query against the database
    st.executeUpdate(sql);
    conn.commit();
   } catch (Exception e) {
    e.printStackTrace();
   }

   // Send a response to noticeboard.jsp
   // This will refresh the page and display the new comment
   response.sendRedirect("noticeboard.jsp");

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