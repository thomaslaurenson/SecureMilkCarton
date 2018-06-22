<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <link rel="stylesheet" type="text/css" href="style.css">
      <title>Secure Milk Carton - Login Page</title>
   </head>
   <body>
      <div id="wrapper">
          <div id="header">
         <ul>
            <li><a class="active">Home</a></li>
            <li><a href="search.jsp">Product Search</a></li>
            <li><a href="noticeboard.jsp">Noticeboard</a></li>
         </ul>
         </div>
         <div id="content">
            <div class="imgcontainer">
               <img class="logo" src="securemilkcarton_logo.jpg" alt="Secure Milk Carton">
            </div>
            <div class="input-form">
            <form action="login">
                  <label><b>Username:</b></label>
                  <input type="text" placeholder="Enter Username" name="username" required>
                  <label><b>Password:</b></label>
                  <input type="password" placeholder="Enter Password" name="password" required>
                  <button type="submit">Login</button>
            </form>
            </div>
         </div>
         <div id="footer">
            <p>Copyright &copy; 2018 A Really Bad Web Developer</p>
         </div>
      </div>
   </body>
</html>