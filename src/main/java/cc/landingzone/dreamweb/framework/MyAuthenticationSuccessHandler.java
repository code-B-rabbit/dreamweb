package cc.landingzone.dreamweb.framework;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import cc.landingzone.dreamweb.model.enums.LoginMethodEnum;
import cc.landingzone.dreamweb.service.LoginRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class MyAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Autowired
    private LoginRecordService loginRecordService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        // 创建登录记录
        loginRecordService.addLoginRecord(request, authentication.getPrincipal().toString(),
                LoginMethodEnum.NORMAL_LOGIN);

        response.sendRedirect("index.html");
    }
}
