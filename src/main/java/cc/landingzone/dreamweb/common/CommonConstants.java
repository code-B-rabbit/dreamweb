package cc.landingzone.dreamweb.common;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CommonConstants {

    private static final Logger logger = LoggerFactory.getLogger(CommonConstants.class);

    public static final String Aliyun_AccessKeyId;

    public static final String Aliyun_AccessKeySecret;

    public static final String Aliyun_REGION_HANGZHOU = "cn-hangzhou";

    public static final String WEB_LANDINGZONE_ID;
    public static final String WEB_LANDINGZONE_SECRET;

    public static final String LOGOUT_SUCCESS_URL;

    // 是否线上环境
    public static final boolean ENV_ONLINE;

    public static final String CONFIG_PATH = System.getProperty("user.dir") + "/config/";

    static {
        Properties properties = loadProperties();
        ENV_ONLINE = Boolean.parseBoolean(properties.getProperty("dreamweb.env_online"));
        Aliyun_AccessKeyId = properties.getProperty("dreamweb.aliyun_accesskeyid");
        Aliyun_AccessKeySecret = properties.getProperty("dreamweb.aliyun_accesskeysecret");
        WEB_LANDINGZONE_ID = properties.getProperty("dreamweb.weixin.landingzone.id");
        WEB_LANDINGZONE_SECRET = properties.getProperty("dreamweb.weixin.landingzone.secret");
        String logoutSuccessUrl = properties.getProperty("dreamweb.logout_success_url");
        if (StringUtils.isBlank(logoutSuccessUrl) || "<your_logout_success_url>".equals(logoutSuccessUrl)) {
            LOGOUT_SUCCESS_URL = "/login?logout";
        } else {
            LOGOUT_SUCCESS_URL = logoutSuccessUrl;
        }
    }

    public static Properties loadProperties() {
        Properties properties = new Properties();
        try {
            InputStream ins = CommonConstants.class.getResourceAsStream("/application.properties");
            if (ins == null) {
                ins = new FileInputStream(CommonConstants.CONFIG_PATH + "/application.properties");
            }
            properties.load(ins);
            ins.close();
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return properties;
    }

}
