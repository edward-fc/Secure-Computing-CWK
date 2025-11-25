package comp3911.cwk2;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;

@SuppressWarnings("serial")
public class AppServlet extends HttpServlet {

  private static final String CONNECTION_URL = "jdbc:sqlite:db.sqlite3";
  private static final String AUTH_QUERY = "SELECT id, password FROM user WHERE username = ?";
  private static final String SEARCH_QUERY = "SELECT * FROM patient WHERE surname = ? AND gp_id = ?";

  private final Configuration fm = new Configuration(Configuration.VERSION_2_3_28);
  private Connection database;

  @Override
  public void init() throws ServletException {
    configureTemplateEngine();
    connectToDatabase();
  }

  private void configureTemplateEngine() throws ServletException {
    try {
      fm.setDirectoryForTemplateLoading(new File("./templates"));
      fm.setDefaultEncoding("UTF-8");
      fm.setTemplateExceptionHandler(TemplateExceptionHandler.HTML_DEBUG_HANDLER);
      fm.setLogTemplateExceptions(false);
      fm.setWrapUncheckedExceptions(true);
    }
    catch (IOException error) {
      throw new ServletException(error.getMessage());
    }
  }

  private void connectToDatabase() throws ServletException {
    try {
      database = DriverManager.getConnection(CONNECTION_URL);
    }
    catch (SQLException error) {
      throw new ServletException(error.getMessage());
    }
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
   throws ServletException, IOException {
    try {
      Template template = fm.getTemplate("login.html");
      template.process(null, response.getWriter());
      response.setContentType("text/html");
      response.setStatus(HttpServletResponse.SC_OK);
    }
    catch (TemplateException error) {
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
   throws ServletException, IOException {
     // Get form parameters
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String surname = request.getParameter("surname");

    try {
      HttpSession session = request.getSession(false);
      Integer doctorId = session != null ? (Integer) session.getAttribute("doctorId") : null;

      // authenticate if no valid session is present
      if (doctorId == null) {
        doctorId = authenticated(username, password);
        if (doctorId != null) {
          session = request.getSession(true);
          session.setAttribute("doctorId", doctorId);
          session.setMaxInactiveInterval(15 * 60); // 15 minute idle timeout
        }
      }

      // if authentication succeeded, doctorId will be non-null
      if (doctorId != null) {
        // Enforce access control: refuse search if not logged in
        if (surname == null || surname.isEmpty()) {
            response.sendRedirect("/");
            return;
        }
        // Get search results and merge with template
        Map<String, Object> model = new HashMap<>();
        // pass the doctorId to searchResults to ensure only
        // records belonging to that doctor are returned
        model.put("records", searchResults(surname, doctorId));
        Template template = fm.getTemplate("details.html");
        template.process(model, response.getWriter());
      }
      else {
        Template template = fm.getTemplate("invalid.html");
        template.process(null, response.getWriter());
      }
      response.setContentType("text/html");
      response.setStatus(HttpServletResponse.SC_OK);
    }
    catch (Exception error) {
      error.printStackTrace();
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
  * Authenticates a user by verifying the supplied password
  * against the bcrypt hash stored in the database.
  */
  private Integer authenticated(String username, String password) {

    // input validation
    if (username == null || password == null) return null;
    if (username.isEmpty() || password.isEmpty()) return null;

    try {
        // use a PreparedStatement instead of building SQL using string
        // concatenation. This prevents attackers from injecting SQL
        // into the username field.
        String sql = AUTH_QUERY;

        PreparedStatement pstmt = database.prepareStatement(sql);
        pstmt.setString(1, username);

        ResultSet rs = pstmt.executeQuery();

        // if no user with that username exists then authentication fails
        if (!rs.next()) {
            return null;
        }
        // retrieve the stored bcrypt hash
        String storedHash = rs.getString("password");
        // instead of comparing plaintext passwords inside SQL, we now
        // compare the user’s input to the bcrypt hash using
        // BCrypt.checkpw(). This ensures passwords are never stored
        // or transmitted in plaintext and prevents attackers from
        // recovering GP credentials if the database is exposed.
        if (!BCrypt.checkpw(password, storedHash)) {
            return null;
        }
        // authentication succeeded, return the doctor's ID
        // assuming the username is unique and corresponds to a single doctor
        Integer doctorId = rs.getInt("id");
        System.err.println("DEBUG: auth success for user=" + username + ", doctorId=" + doctorId);
        return doctorId;

    } catch (SQLException e) {
        e.printStackTrace();
        return null;
    }
  }

  /**
  * Searches for patient records matching the given surname.
  */
  private List<Record> searchResults(String surname, int doctorId) throws SQLException {
    // The original version used string formatting to construct SQL
    // (String.format(SEARCH_QUERY, surname)), which allowed an
    // attacker to inject raw SQL into the WHERE clause.
    // Replacing the dynamic SQL string with a parameterised query
    // prevents injected characters such as ' OR '1'='1 from altering
    // the structure of the SQL command. PreparedStatement safely treats
    // the surname as data rather than executable SQL.
    List<Record> records = new ArrayList<>();
    try (PreparedStatement pstmt = database.prepareStatement(SEARCH_QUERY)) {
      // bind the user input securely to the SQL parameter
      pstmt.setString(1, surname);
      pstmt.setInt(2, doctorId);
      ResultSet results = pstmt.executeQuery();
      // build the list of Record objects from the query results
      while (results.next()) {
        Record rec = new Record();
        rec.setSurname(results.getString(2));
        rec.setForename(results.getString(3));
        rec.setAddress(results.getString(4));
        rec.setDateOfBirth(results.getString(5));
        rec.setDoctorId(results.getString(6));
        rec.setDiagnosis(results.getString(7));
        records.add(rec);
      }
    }
    return records;
  }
}
