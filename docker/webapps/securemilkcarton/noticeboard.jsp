<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <link rel="stylesheet" type="text/css" href="style.css">
      <title>Secure Milk Carton - Noticeboard</title>
      <script type="text/javascript" src="jquery.js"></script>
      <script>
         // A function to check if both text boxes have an entry
         function validate_form(thisform) {
             // Fetch the name and comments form entries
             var name = thisform.name.value;
             var comments = thisform.comments.value;

             // Perform checks on user input
             if (name == "" || name == null)
             {
                 // If the name field is empty or null:
                 // Prompt the user that the field is required
                 window.alert("You must supply a name!");
                 return false;
             }
             else if (comments == "" || comments == null)
             {
                 // If the comments field is empty or null:
                 // Prompt the user that the field is required
                 window.alert("You must supply a comment!");
                 return false;
             }
             else
             {
                 // If the user has submitted a valid name and comment:
                 // Post the form, set input boxes to empty and return true
                 $.ajax({
                 url: $(thisform).attr('action'),
                 type: $(thisform).attr('method'),
                 data: {"name": name, "comments": comments},
                 success: function(html) {
                     $("#name").val('');
                     $("#comments").val('');
                     location.reload();
                 }
                 });
                 return true;
             }
             return false;
         }
      </script>
   </head>
   <body>
      <div id="wrapper">
          <div id="header">
         <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="search.jsp">Product Search</a></li>
            <li><a class="active">Noticeboard</a></li>
         </ul>
        </div>
         <div id="content">
            <div class="imgcontainer">
                <img class="logo" src="securemilkcarton_logo.jpg" alt="Secure Milk Carton">
            </div>
            <h1>Please leave your name and comments:</h1>
            <div class="input-form">
               <form method="post" name="noticeboard" action="noticeboard" class="noticeboard" onsubmit="return validate_form(this)">
                     <label><b>Name:</b></label>
                     <input type="text" placeholder="Enter Name" id="name" name="name">
                     <label><b>Message:</b></label>
                     <input type="text" placeholder="Enter Message" id="comments" name="comments">
                     <button name="submit" type="submit" value="submit">Submit</button>
               </form>
            </div>
            <br />       
            <div class="comments_section">
               <%@page import="java.sql.*" %>
               <%
                  try {
                      Class.forName("com.mysql.jdbc.Driver");
                      Connection conn = DriverManager.getConnection("jdbc:mysql://db:3306/securemilkcarton?autoReconnect=true&useSSL=false", "root", "passw0rd");
                  
                      Statement st = conn.createStatement();
                      String sql = "SELECT name, comments FROM noticeboard";
                      System.out.println(sql);
                      ResultSet rs = st.executeQuery(sql);
                  
                      while (rs.next()) {
                          String name = rs.getString("name");
                          String comments = rs.getString("comments");
                          out.println("<div id='noticeboard_comment'>");
                          out.println("Name: ");
                          out.println(name);
                          out.println("<br/>");
                          out.println("Comments: ");
                          out.println(comments);
                          out.println("<br/>");
                          out.println("</div>");
                      }
                      conn.close();
                  } catch (Exception e) {
                      e.printStackTrace();
                  }
                  %>
            </div>
         </div>
         <div id="footer">
            <p>Copyright &copy; 2018 A Really Bad Web Developer</p>
         </div>
      </div>
   </body>
</html>