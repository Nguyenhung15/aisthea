package com.aisthea.fashion.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class UrlRewriteFilter implements Filter {

    private Pattern rewritePattern;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String contextPath = filterConfig.getServletContext().getContextPath();
        
        rewritePattern = Pattern.compile(contextPath + "/(women|men|stylist)/([^/]+)");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String path = httpRequest.getRequestURI();
        Matcher matcher = rewritePattern.matcher(path);

        if (matcher.matches()) {
            String genderKey = matcher.group(1); 
            String categoryIndex = matcher.group(2);

            String genderId = "0";
            if ("men".equals(genderKey)) {
                genderId = "1";
            } else if ("women".equals(genderKey)) {
                genderId = "2";
            } else if ("stylist".equals(genderKey)) {
                genderId = "3";
            }

            String forwardUrl = "/product?action=list&categoryIndex=" + categoryIndex + "&genderid=" + genderId;
            
            request.getRequestDispatcher(forwardUrl).forward(request, response);
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
    }
}