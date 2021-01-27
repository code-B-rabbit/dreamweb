package cc.landingzone.dreamweb.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.InetAddress;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.jar.Manifest;

import cc.landingzone.dreamweb.common.CommonConstants;
import cc.landingzone.dreamweb.model.WebResult;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.util.ClassUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Controller
@RequestMapping("/system")
public class SystemController extends BaseController implements InitializingBean {

    private Logger logger = LoggerFactory.getLogger(SystemController.class);

    private LocalDateTime startTime;

    @Override
    public void afterPropertiesSet() throws Exception {
        startTime = LocalDateTime.now();
    }

    public static HttpSession getSession() {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        return attr.getRequest().getSession(true); // true == allow create
    }


    @RequestMapping("/getSession.do")
    public void getSession(HttpServletRequest request, HttpServletResponse response) {
        WebResult result = new WebResult();
        try {
            HttpSession session = getSession();
            result.setData(session);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        outputToJSON(response, result);
    }


    /**
     * 开放权限
     *
     * @param request
     * @param response
     */
    @RequestMapping("/getStartInfo")
    public void getStartInfo(HttpServletRequest request, HttpServletResponse response) {
        String result = new String();
        try {
            result = "hostname: " + InetAddress.getLocalHost().getHostName() + " \n " + new Date();
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result = e.getMessage();
        }
        outputToString(response, result);
    }

    @RequestMapping("/getIndexLogoPage.do")
    public void getIndexLogoPage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        WebResult result = new WebResult();
        try {
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            String logoDiv = null;
            if (CommonConstants.ENV_ONLINE) {

                String jarFilePath = ClassUtils.getDefaultClassLoader().getResource("").getPath().replace("!/BOOT-INF/classes!/", "");
                if (jarFilePath.startsWith("file")) {
                    jarFilePath = jarFilePath.substring(5);
                }
                logger.info("jarFilePath:" + jarFilePath);
                JarFile jarFile = new JarFile(jarFilePath);
                JarEntry entry = jarFile.getJarEntry("META-INF/MANIFEST.MF");
//                InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("META-INF/MANIFEST.MF");
                Manifest manifest = new Manifest(jarFile.getManifest());
                String version = manifest.getMainAttributes().getValue("Version");
                if (StringUtils.isBlank(version)) {
                    version = "online version";
                }
                logoDiv = "<div align=\"center\"><i style=\"font-size:30px;margin-top:5px;color:#CFDEEF;animation-duration: 20s;\" class=\"fa fa-sun-o fa-spin\" aria-hidden=\"true\"></i></div><div align='center' style='background-color:#FF594C;margin-top:5px;font-size: 12px;'><font "
                        + "style='color: white;'>" + username + "<br>" + version + "</font></div>";
            } else {
                String version = "test version";
                logoDiv = "<div align=\"center\"><i style=\"font-size:30px;margin-top:5px;color:#CFDEEF;animation-duration: 1s;\" class=\"fa fa-sun-o fa-spin\" aria-hidden=\"true\"></i></div><div align='center' style='background-color:rgb(93,168,48);margin-top:5px;font-size: 12px;"
                        + "'><font style='color: white;'>" + username + "<br>" + version + "</font></div>";
            }
            result.setData(logoDiv);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result.setSuccess(false);
            result.setErrorMsg(e.getMessage());
        }
        outputToJSON(response, result);
    }


}
