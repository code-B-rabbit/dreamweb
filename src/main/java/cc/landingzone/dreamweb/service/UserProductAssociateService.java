package cc.landingzone.dreamweb.service;

import cc.landingzone.dreamweb.dao.ProductDao;
import cc.landingzone.dreamweb.dao.UserProductAssociateDao;
import cc.landingzone.dreamweb.model.Page;
import cc.landingzone.dreamweb.model.Product;
import cc.landingzone.dreamweb.model.UserProductAssociate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 查询用户有权限的产品列表
 *
 * @author: laodou
 * @createDate: 2022/6/21
 */
@Component
public class UserProductAssociateService {

    @Autowired
    private UserProductAssociateDao userProductAssociateDao;

    @Autowired
    private ProductDao productDao;

    @Transactional
    public List<Product> listProductByUserId(Integer userId) {
        List<Integer> productIds = userProductAssociateDao.listProductIdsByUserId(userId);
        List<Product> products = new ArrayList<>();
        for (Integer productId : productIds) {
            Product product = productDao.getProductById(productId);
            products.add(product);
        }
        return products;
    }

    @Transactional
    public List<UserProductAssociate> listUserProductAssociate(Page page) {
        Map<String, Object> map = new HashMap<>();
        map.put("page", page);
        List<UserProductAssociate> list = userProductAssociateDao.listUserProductAssociate(map);
        if (null != page) {
            if (null != page.getStart() && null != page.getLimit()) {
                Integer total = userProductAssociateDao.getUserProductAssociateTotal(map);
                page.setTotal(total);
            } else {
                page.setTotal(list.size());
            }
        }
        return list;
    }

    @Transactional
    public void saveUserProductAssociate(UserProductAssociate userProductAssociate) {
        UserProductAssociate userProductAssociate1 = getUserProductAssociateByProductIdAndUserId(
            userProductAssociate.getProductId(), userProductAssociate.getUserId());
        if (userProductAssociate1 != null) {
            throw new IllegalArgumentException("此权限已存在！");
        }
        userProductAssociateDao.saveUserProductAssociate(userProductAssociate);
    }

    @Transactional
    public UserProductAssociate getUserProductAssociateByProductIdAndUserId(Integer productId, Integer userId) {
        return userProductAssociateDao.getUserProductAssociateByProductIdAndUserId(productId, userId);
    }

    @Transactional
    public UserProductAssociate getUserProductAssociateById(Integer id) {
        return userProductAssociateDao.getUserProductAssociateById(id);
    }

    @Transactional
    public void updateUserProductAssociate(UserProductAssociate userProductAssociate) {
        UserProductAssociate userProductAssociate1 = getUserProductAssociateByProductIdAndUserId(
            userProductAssociate.getProductId(), userProductAssociate.getUserId());
        if (userProductAssociate1 != null && userProductAssociate1.getId() != userProductAssociate.getId()) {
            throw new IllegalArgumentException("此权限已存在！");
        }
        userProductAssociateDao.updateUserProductAssociate(userProductAssociate);
    }

    @Transactional
    public void deleteUserProductAssociate(Integer id) {
        userProductAssociateDao.deleteUserProductAssociate(id);
    }

    @Transactional
    public String getServicecatalogPortfolioId(Integer productId, Integer userId) {
        return userProductAssociateDao.getServicecatalogPortfolioId(productId, userId);
    }

}
