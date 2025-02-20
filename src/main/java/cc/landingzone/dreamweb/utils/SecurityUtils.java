package cc.landingzone.dreamweb.utils;

import java.beans.PropertyDescriptor;

import org.springframework.cglib.core.ReflectUtils;
import org.springframework.util.Assert;

import cc.landingzone.dreamweb.model.User;

public class SecurityUtils {

    /**
     * 过滤对象中会导致xss攻击的字符串
     *
     * @param o
     * @throws Exception
     */
    public static void xssFilter(Object o) throws Exception {
        Assert.notNull(o, "object can not be null!");
        PropertyDescriptor[] list = ReflectUtils.getBeanSetters(o.getClass());
        for (PropertyDescriptor p : list) {
            if (!String.class.equals(p.getPropertyType())) {
                continue;
            }
            if (null == p.getReadMethod()) {
                continue;
            }
            Object a = p.getReadMethod().invoke(o, new Object[] {});
            if (null != a) {
                String target = a.toString().replaceAll("<script>", "").replaceAll("javascript:", "")
                        .replaceAll("<", "").replaceAll(">", "");
                p.getWriteMethod().invoke(o, target);
            }
        }
    }

    public static void main(String[] args) throws Exception {
        User user = new User();
        user.setName("test<a>");
        user.setComment("<script>");
        xssFilter(user);
        System.out.println(JsonUtils.toJsonString(user));
    }

}
