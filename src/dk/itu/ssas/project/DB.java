package dk.itu.ssas.project;

import java.sql.Connection;
import java.sql.SQLException;
import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

public class DB {
	public static Connection getConnection() throws SQLException {
		// Better way to do this is setting database connect info in
		// servlet context; but for the SSAS project, that just adds
		// complications. 
		MysqlDataSource ds = null;
		
			ds = new MysqlDataSource();
			ds.setUrl("jdbc:mysql://localhost:3306/image_site_db");
			ds.setUser("SSAS");
			ds.setPassword("SSAS");
			return ds.getConnection();
	}
}
