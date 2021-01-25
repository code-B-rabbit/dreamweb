package cc.landingzone.dreamweb.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cc.landingzone.dreamweb.model.WebResult;
import cc.landingzone.dreamweb.sso.tools.ResourceDirectoryAccountFactory;
import cc.landingzone.dreamweb.utils.UUIDUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/aliyunTools")
public class AliyunToolsController extends BaseController {


    @RequestMapping("/createAccount.do")
    public void createAccount(HttpServletRequest request, HttpServletResponse response) {
        WebResult result = new WebResult();
        try {
            final String accessKeyId = request.getParameter("accessKeyId");
            final String accessKeySecret = request.getParameter("accessKeySecret");
            final String email = request.getParameter("email");
            final String id = UUIDUtils.generateUUID();
            ResourceDirectoryAccountFactory.logMap.put(id, new StringBuilder());
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        ResourceDirectoryAccountFactory.buildNewRD(accessKeyId, accessKeySecret, email, id);
                    } catch (Exception e) {
                        logger.error(e.getMessage(), e);
                    }
                }
            }).start();
            result.setData(id);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result.setSuccess(false);
            result.setErrorMsg(e.getMessage());
        }
        outputToJSON(response, result);
    }

    @RequestMapping("/getProcessById.do")
    public void getProcessById(HttpServletRequest request, HttpServletResponse response) {
        WebResult result = new WebResult();
        try {
            String id = request.getParameter("id");
            if (null == ResourceDirectoryAccountFactory.logMap.get(id)) {
                result.setData("can not find log,id:" + id);
            } else {
                String log = ResourceDirectoryAccountFactory.logMap.get(id).toString();
                result.setData(log);
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result.setSuccess(false);
            result.setErrorMsg(e.getMessage());
        }
        outputToJSON(response, result);
    }
}
