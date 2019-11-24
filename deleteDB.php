<html>
   
   <head>
      <title>Delete a MySQL Database</title>
   </head>
   <h3> Databases on your system <h3>
   <body>
      <?php
	  // Database Info
	   $dbhost = 'localhost:3036';
       $dbuser = 'root';
       $dbpass = 'password';
	   
	   $dbcnx = mysql_connect ($dbhost, $dbuser, $dbpass); 
 
	   
       // This will show all the database on system
	  $result = mysql_query("SHOW DATABASES");        
      while ($row = mysql_fetch_array($result)) { 	  
      echo $row[0]."<br>";  
	  }
         if(isset($_POST['delete'])) {

            $conn = mysql_connect($dbhost, $dbuser, $dbpass);
            
            if(! $conn ) {
               die('Could not connect: ' . mysql_error());
            }
				
            $emp_id = $_POST['emp_id'];
            
            $sql = "DROP DATABASE $emp_id" ;
            
            $retval = mysql_query( $sql, $conn );
            
            if(! $retval ) {
               die('Could not delete data: ' . mysql_error());
            }
            
            echo "Deleted data successfully\n";
            
            mysql_close($conn);
         }else {
            ?>
               <form method = "post" action = "<?php $_PHP_SELF ?>">
                  <table width = "400" border = "0" cellspacing = "1" 
                     cellpadding = "2">
                     
                     <tr>
                        <td width = "100">Database Name:</td>
                        <td><input name = "emp_id" type = "text" 
                           id = "emp_id"></td>
                     </tr>
                     
                     <tr>
                        <td width = "100"> </td>
                        <td> </td>
                     </tr>
                     
                     <tr>
                        <td width = "100"> </td>
                        <td>
                           <input name = "delete" type = "submit" 
                              id = "delete" value = "Delete">
                        </td>
                     </tr>
                     
                  </table>
               </form>
            <?php
         }
      ?>
      
   </body>
</html>