//package com.aisthea.fashion.controller;
//
//import com.aisthea.fashion.utils.MailUtil;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/sendMail")
//public class MailServlet extends HttpServlet {
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        String to = req.getParameter("to");
//        String subject = req.getParameter("subject");
//        String content = req.getParameter("content");
//        if (to != null && subject != null && content != null) {
//            MailUtil.sendMail(to, subject, content);
//            resp.getWriter().write("OK");
//        } else {
//            resp.getWriter().write("Missing params");
//        }
//    }
//}
