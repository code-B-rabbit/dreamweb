package cc.landingzone.dreamweb.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cc.landingzone.dreamweb.model.WebResult;
import cc.landingzone.dreamweb.service.RSAService;

@Controller
@RequestMapping("/rsakey")
public class RSAKeyController extends BaseController {

    @Autowired
    private RSAService rsaService;

    private Logger logger = LoggerFactory.getLogger(RSAKeyController.class);

    @RequestMapping("/updateRSAKey.do")
    public void updateRSAKey(HttpServletRequest request, HttpServletResponse response) {
        WebResult result = new WebResult();
        try {
            rsaService.updateRSAKey();
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result.setSuccess(false);
            result.setErrorMsg(e.getMessage());
        }
        outputToJSON(response, result);
    }

    @RequestMapping("/getPublicKey.do")
    public void getPublicKey(HttpServletRequest request, HttpServletResponse response) {
        WebResult result = new WebResult();
        try {
            Map<String, String> map = new HashMap<String, String>();
            map.put("publicKey", rsaService.getPublicKey());
            result.setData(map);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            result.setSuccess(false);
            result.setErrorMsg(e.getMessage());
        }
        outputToJSON(response, result);
    }
}
