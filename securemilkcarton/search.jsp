<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <link rel="stylesheet" type="text/css" href="style.css">
      <title>Secure Milk Carton - Milk Products Search Page</title>
   </head>
   <body>
      <div id="wrapper">
        <div id="header"> 
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a class="active">Product Search</a></li>
            <li><a href="noticeboard.jsp">Noticeboard</a></li>
         </ul>
         </div>
         <div id="content">
            <%
            if ((session.getAttribute("username") == null) || (session.getAttribute("username") == "")) {
            %>
            <h1>Welcome To SecureMilkProducts...</h1>
            <h3><a href="index.jsp">Please login to view this page</a></h3>
            <%} else {
                %>
             <h1>Welcome: <%=session.getAttribute("username")%></h1>

            <div class="imgcontainer">
                <img class="logo" src="securemilkcarton_logo.jpg" alt="Secure Milk Carton">
            </div>

            <h1>Search Milk Product Database:</h1>
            <div class="input-form">
               <form>
                     <label><b>Product Name:</b></label>
                     <input type="text" placeholder="Enter Milk Product Name" name="username" required>
                     <button type="submit" value="Submit">Submit</button>
               </form>
            </div>
            <div class="search_results">
               <h3>Search Results:</h3>
               <table id="search" align="center">
                  <thead>
                     <tr>
                        <th>Username</th>
                        <th>Codename</th>
                        <th>Title</th>
                     </tr>
                  </thead>
                  <tbody>
                     <%@page import="java.sql.*" %>
                     <%
                        String username = request.getParameter("username");
                        try 
                        {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/securemilkcarton?autoReconnect=true&useSSL=false", "root", "passw0rd");
                        
                            Statement st = conn.createStatement();
                            String sql = "SELECT username, name, description FROM members WHERE username='" + username + "'";
                            System.out.println(sql);
                            ResultSet rs = st.executeQuery(sql);
                        
                            while (rs.next()) {
                               String uname = rs.getString("username");
                               String name = rs.getString("name");
                               String description = rs.getString("description");
                               out.println("<tr>");
                               out.println("<td>" + uname + "</td>");
                               out.println("<td>" + name + "</td>");
                               out.println("<td>" + description + "</td>");
                               out.println("</tr>");
                            }
                        } 
                        catch (Exception e) 
                        {
                            System.out.println(">>> ERROR running search.jsp query...");
                            e.printStackTrace();
                        }
                        %>
                  </tbody>
               </table>
            </div>
            <%
            }
            %>
         </div>
         <div id="footer">
            <p>Copyright &copy; 2018 A Really Bad Web Developer</p>
         </div>
      </div>
   </body>
</html>