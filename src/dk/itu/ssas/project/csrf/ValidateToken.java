package dk.itu.ssas.project.csrf;

import java.util.List;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.annotation.*;

@WebFilter(filterName = "ValidateToken", urlPatterns = {"/login.jsp", "/register.jsp", "/Comment", "/Uploader", "/Invite"})
public class ValidateToken implements Filter  {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {


        // Assume its HTTP
        HttpServletRequest httpReq = (HttpServletRequest) request;

        // disable for index page
        String path = httpReq.getRequestURI();
        String contextPath = httpReq.getContextPath();
        if (path.equals(contextPath + "/")) {
            chain.doFilter(request, response); // Just continue chain.
            return;
        }


        final String csrfKey = CSRFConfig.tokenKey();
        String token = (String) httpReq.getParameter(csrfKey);

        // Validate that the token is in the cache
        String storedToken = (String) httpReq.getSession().getAttribute(csrfKey);

        System.out.println("Validate token: "+ token);
        System.out.println("Validate storedToken: "+ storedToken);

        if (storedToken != null && token != null && storedToken.equals(token)){

            // If the token is in the cache, we move on
            chain.doFilter(request, response);
        } else {
            // Otherwise we throw an exception aborting the request flow
            throw new ServletException("Potential CSRF detected!! Inform a scary sysadmin ASAP.");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}