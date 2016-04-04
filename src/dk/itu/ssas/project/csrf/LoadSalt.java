package dk.itu.ssas.project.csrf;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.annotation.*;
import java.security.SecureRandom;
import java.math.BigInteger;

@WebFilter(filterName = "LoadSalt", urlPatterns = "/*")
public class LoadSalt implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {

        // Assume its HTTP
        HttpServletRequest httpReq = (HttpServletRequest) request;

        String salt = (String) httpReq.getSession().getAttribute(CSRFConfig.tokenKey());

        System.out.println("Salt found: " + salt);

        if (salt == null) {
        // Generate the salt and store it in the users cache
            salt = genToken();
            httpReq.getSession().setAttribute(CSRFConfig.tokenKey(), salt);
            System.out.println("salt stored: "+salt);
        }
        // Add the salt to the current request so it can be used
        // by the page rendered in this request
        httpReq.setAttribute(CSRFConfig.tokenKey(), salt);

        chain.doFilter(request, response);
    }


    private String genToken() {
        SecureRandom random = new SecureRandom();
        return new BigInteger(130, random).toString(32);
    }


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}