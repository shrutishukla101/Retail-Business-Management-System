// usage:  1. compile: javac -cp /usr/lib/oracle/18.3/client64/lib/ojdbc8.jar getCust.java
//         2. execute: java -cp /usr/lib/oracle/18.3/client64/lib/ojdbc8.jar getCust.java

import java.sql.*;
import java.io.*;
import oracle.jdbc.pool.OracleDataSource;

public class getCust {

    public static void main(String args[]) throws SQLException {
        
        // Method for Part1 of JDBC - get all customers
        getAllCust();
        
        // Wait for user for Part2
        System.out.println();
        System.out.println("Press enter to continue...");try{        System.in.read();}catch(Exception e){	e.printStackTrace();}
        
        // Method for Part2 of JDBC - get one customer for a cid
        getOneCust();
    }

    private static void getAllCust() {
        try {
            // Connection to Oracle server.
            OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
            ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111");
            Connection conn = ds.getConnection("asrivas3", "sr927641");

            // Query
            Statement stmt = conn.createStatement();

            // Save result
            ResultSet rset;
            rset = stmt.executeQuery("SELECT * FROM customers");

            System.out.println("CID, Name, Telephone#, Visits Made, Last Visit Date ");
            // Print
            while (rset.next()) {
                System.out.print(rset.getString(1) + ", ");
                System.out.print(rset.getString(2) + ", ");
                System.out.print(rset.getString(3) + ", ");
                System.out.print(rset.getString(4) + ", ");
                System.out.println(rset.getString(5) + ", ");
            }

            // close the result set, statement, and the connection
            rset.close();
            stmt.close();
            conn.close();
        } catch (SQLException ex) {
            System.out.println(
                    "\n*** SQLException caught 1st***\n" + ex.getStackTrace() + ex.getMessage()
                            + ex.getLocalizedMessage());
        } catch (Exception e) {
            System.out.println(
                    "\n*** other Exception caught 2nd***\n" + e.getStackTrace() + e.getMessage()
                            + e.getLocalizedMessage());
        }
    }

    private static void getOneCust() {
        try {

            // Connection to Oracle server.
            OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
            ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111");
            Connection conn = ds.getConnection("asrivas3", "sr927641");

            // Input CID from keyboard
            BufferedReader readKeyBoard;
            String cid;
            readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
            System.out.print("Please enter customer's CID:");
            cid = readKeyBoard.readLine();

            // Prepare statement and save in resultset
            PreparedStatement select1 = conn.prepareStatement("SELECT * FROM customers where cid = '" + cid + "'");
            ResultSet rset;
            select1.executeUpdate();
            rset = select1.executeQuery();

            // Check if CID exists or not and then display desired output
            if (!rset.isBeforeFirst()) {
                System.out.println("Customer doesn't exist");
            } else {
                System.out.println("CID, Name, Telephone#, Visits Made, Last Visit Date ");
                while (rset.next()) {
                    System.out.print(rset.getString(1) + ", ");
                    System.out.print(rset.getString(2) + ", ");
                    System.out.print(rset.getString(3) + ", ");
                    System.out.print(rset.getString(4) + ", ");
                    System.out.println(rset.getString(5) + ", ");
                }
            }
            // close the resultset, statement, and the connection
            rset.close();
            select1.close();
            conn.close();
        } catch (SQLException ex) {
            System.out.println("\n*** SQLException caught 1st***\n" + ex.getStackTrace() + ex.getMessage()
                    + ex.getLocalizedMessage());
        } catch (Exception e) {
            System.out.println("\n*** other Exception caught 2nd***\n" + e.getStackTrace() + e.getMessage()
                    + e.getLocalizedMessage());
        }
    }
}
