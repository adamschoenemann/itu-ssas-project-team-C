package dk.itu.ssas.project;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileItemIterator;
import org.apache.tomcat.util.http.fileupload.FileItemStream;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;

/**
 * Servlet implementation class Uploader
 */
@WebServlet("/Uploader")
public class Uploader extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Uploader() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

            String userIdStr = (String) request.getSession().getAttribute("user");

            // user not logged in
            if (userIdStr == null) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

			// TODO: is the factory used below really secure?
			// Create a factory for disk-based file items
			DiskFileItemFactory factory = new DiskFileItemFactory();

			// Configure a repository (to ensure a secure temp location is used)
			ServletContext servletContext = this.getServletConfig().getServletContext();
			File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
			factory.setRepository(repository);

			// Create a new file upload handler
			ServletFileUpload upload = new ServletFileUpload(factory);

			// Parse the request
			FileItemIterator items = upload.getItemIterator(request);
			FileItemStream fis = items.next();
			InputStream iis = fis.openStream();

			Connection con = DB.getConnection();

			String sql = "INSERT INTO images (jpeg, owner) values (?, ?)";
			PreparedStatement statement = con.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			statement.setBlob(1, iis);
			statement.setString(2, userIdStr);
			statement.executeUpdate();

			ResultSet rs = statement.getGeneratedKeys();
			rs.next();
			String image_id = rs.getString(1);

			sql = "INSERT INTO perms (image_id, user_id) values (?, ?)";
            statement = con.prepareStatement(sql);
            statement.setInt(1, Integer.parseInt(image_id));
            statement.setInt(2, Integer.parseInt(userIdStr));

			statement.executeUpdate();

		}
		catch (SQLException | FileUploadException e)
		{
            System.err.println("Something went wrong with upload");
		}
        catch (NumberFormatException e) {
            System.err.println("Received a non-numeric parameter where not expected");
        }

        response.sendRedirect("main.jsp");
	}

}
