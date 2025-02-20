package cc.landingzone.dreamweb.sso.sp;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;

import cc.landingzone.dreamweb.common.CommonConstants;
import cc.landingzone.dreamweb.common.EndpointEnum;
import com.aliyuncs.CommonRequest;
import com.aliyuncs.CommonResponse;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.auth.BasicCredentials;
import com.aliyuncs.auth.STSAssumeRoleSessionCredentialsProvider;
import com.aliyuncs.http.ProtocolType;
import com.aliyuncs.profile.DefaultProfile;
import com.aliyuncs.ram.model.v20150501.AttachPolicyToRoleRequest;
import com.aliyuncs.ram.model.v20150501.AttachPolicyToRoleResponse;
import com.aliyuncs.sts.model.v20150401.GetCallerIdentityRequest;
import com.aliyuncs.sts.model.v20150401.GetCallerIdentityResponse;

import cc.landingzone.dreamweb.sso.SamlGenerator;
import cc.landingzone.dreamweb.utils.JsonUtils;

public class SPHelper {

    private static String LINE_BREAK = "<br>";
    private static String LINE_SEPARATED = "<hr>";

    public static void main(String[] args) throws Exception {
        // for test
        // CertManager.initSigningCredential();
        // DefaultBootstrap.bootstrap();
        // String idpProviderName = "MyAzureAD";
        // String roleName = "charlesRole1";
        // DefaultProfile profile =
        // DefaultProfile.getProfile(CommonConstants.Aliyun_REGION_HANGZHOU,
        // CommonConstants.Aliyun_AccessKeyId, CommonConstants.Aliyun_AccessKeySecret);
        // initSP(profile, idpProviderName, roleName);
    }

    public static String initMultiAccountSP(String accessKeyId, String accessKeySecret, String idpProviderName,
            Map<String, List<String>> roleMap) throws Exception {
        StringBuilder result = new StringBuilder();
        DefaultProfile profile = DefaultProfile.getProfile(CommonConstants.Aliyun_REGION_HANGZHOU, accessKeyId, accessKeySecret);
        String endpoint = EndpointEnum.RESOURCE_MANAGER.getEndpoint();
        List<Map<String, String>> accountList = listAccounts(profile, endpoint);
        for (Map<String, String> accountMap : accountList) {
            IAcsClient client = getSubAccountClinet(accessKeyId, accessKeySecret, accountMap.get("AccountId"), CommonConstants.Aliyun_REGION_HANGZHOU);
            String singleLog = initSingleAccountSP(client, idpProviderName, roleMap);
            result.append(singleLog);
        }

        return result.toString();
    }

    /**
     * init sp (alicloud)
     *
     * @param idpProviderName
     * @return
     * @throws Exception
     */
    public static String initSingleAccountSP(IAcsClient client, String idpProviderName,
            Map<String, List<String>> roleMap) throws Exception {
        StringBuilder result = new StringBuilder();

        String stsEndpoint = EndpointEnum.STS.getEndpoint();
        String imsEndpoint = EndpointEnum.IMS.getEndpoint();
        String ramEndpoint = EndpointEnum.RAM.getEndpoint();

        String uid = getUid(client, stsEndpoint);

        result.append("UID:" + uid);
        result.append(LINE_BREAK);
        result.append("idpProvider: " + idpProviderName);
        result.append(LINE_BREAK);
        result.append("roleMap: " + JsonUtils.toJsonString(roleMap));
        result.append(LINE_BREAK);

        String policyDocument = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Condition\":{\"StringEquals\":{\"saml:recipient\":\"https://signin.aliyun.com/saml-role/sso\"}},\"Effect\":\"Allow\",\"Principal\":{\"Federated\":[\"acs:ram::"
                + uid + ":saml-provider/" + idpProviderName + "\"]}}],\"Version\":\"1\"}";
        // String policyName = "AdministratorAccess";
        // String policyType = "System";

        result.append("policyDocument: " + policyDocument);
        result.append(LINE_BREAK);
        // result.append("policyName: " + policyName);
        // result.append(LINE_BREAK);
        // result.append("policyType: " + policyType);
        // result.append(LINE_BREAK);
        result.append(LINE_BREAK);
        result.append(LINE_SEPARATED);

        result.append("1. add saml provider");
        result.append(LINE_BREAK);
        // 1. add saml provider, this samlMetadata can download from IDP(for example:
        // Azure AD)
        String samlMetadata = SamlGenerator.generateMetaXML();
        String addSAMLProviderResult = addSAMLProviders(client, idpProviderName, samlMetadata, imsEndpoint);
        result.append("result: " + addSAMLProviderResult);
        result.append(LINE_BREAK);
        result.append(LINE_BREAK);
        result.append(LINE_SEPARATED);

        String roleExpression = "";

        for (Map.Entry<String, List<String>> entry : roleMap.entrySet()) {
            String roleName = entry.getKey();
            // 2. create role
            result.append("2. create role");
            result.append(LINE_BREAK);
            String createRoleResult = createRole(client, roleName, policyDocument, ramEndpoint);
            result.append("result: " + createRoleResult);
            result.append(LINE_BREAK);
            result.append(LINE_BREAK);
            result.append(LINE_SEPARATED);

            String policyType = "System";
            for (String policyName : entry.getValue()) {
                result.append("3. attach policy to role");
                result.append(LINE_BREAK);
                // 3. attach policy to role
                String attachPolicyToRoleResult = attachPolicyToRole(client, policyName, policyType, roleName, ramEndpoint);
                result.append("result: " + attachPolicyToRoleResult);
                result.append(LINE_BREAK);
                result.append(LINE_BREAK);
                result.append(LINE_SEPARATED);
            }
            roleExpression += "acs:ram::" + uid + ":role/" + roleName + ",acs:ram::" + uid + ":saml-provider/"
                    + idpProviderName;
            roleExpression += LINE_BREAK;
        }

        result.append("roleExpression: ");
        result.append(LINE_BREAK);
        result.append("------------------------------------------------------------------------------");
        result.append(LINE_BREAK);
        result.append(roleExpression);
        result.append(LINE_BREAK);
        result.append("------------------------------------------------------------------------------");
        result.append(LINE_BREAK);
        return result.toString();
    }

    public static String attachPolicyToRole(IAcsClient client, String policyName, String policyType, String roleName, String endpoint)
            throws Exception {
        AttachPolicyToRoleRequest request = new AttachPolicyToRoleRequest();
        request.setSysEndpoint(endpoint);
        request.setPolicyName(policyName);
        request.setPolicyType(policyType);
        request.setRoleName(roleName);
        AttachPolicyToRoleResponse response = client.getAcsResponse(request);
        return response.getRequestId();
    }

    public static String createRole(IAcsClient client, String roleName, String policyDocument, String endpoint) throws Exception {
        CommonRequest request = new CommonRequest();
        request.setSysDomain(endpoint);
        request.setSysVersion("2015-05-01");
        request.setSysAction("CreateRole");
        request.setSysProtocol(ProtocolType.HTTPS);
        request.putQueryParameter("RoleName", roleName);
        request.putQueryParameter("AssumeRolePolicyDocument", policyDocument);
        CommonResponse response = client.getCommonResponse(request);
        return response.getData();
    }

    public static String getUid(IAcsClient client, String endpoint) throws Exception {
        GetCallerIdentityRequest request = new GetCallerIdentityRequest();
        request.setSysEndpoint(endpoint);

        GetCallerIdentityResponse response = client.getAcsResponse(request);
        return response.getAccountId();
    }

    public static String addSAMLProviders(IAcsClient client, String providerName, String samlMetadata, String endpoint)
            throws Exception {
        CommonRequest request = new CommonRequest();
        request.setSysDomain(endpoint);
        request.setSysVersion("2019-08-15");
        request.setSysAction("CreateSAMLProvider");
        request.setSysProtocol(ProtocolType.HTTPS);
        request.putQueryParameter("SAMLProviderName", providerName);
        request.putQueryParameter("SAMLMetadataDocument", samlMetadata);
        CommonResponse response = client.getCommonResponse(request);
        return response.getData();
    }

    /**
     * get resource account list
     *
     * @return
     * @throws Exception
     */
    public static List<Map<String, String>> listAccounts(DefaultProfile profile, String endpoint) throws Exception {
        IAcsClient client = new DefaultAcsClient(profile);
        CommonRequest request = new CommonRequest();
        // request.setSysDomain("resourcemanager.aliyuncs.com");
        request.setSysDomain(endpoint);
        request.setSysVersion("2020-03-31");
        request.setSysAction("ListAccounts");
        // 暂时先设置成100,如果账号数量超过100,需要修改代码,增加翻页的逻辑
        request.putQueryParameter("PageSize", "100");
        request.setSysProtocol(ProtocolType.HTTPS);
        CommonResponse response = client.getCommonResponse(request);
        String result = response.getData();
        System.out.println("==================================");
        System.out.println(result);
        JSONObject jsonObject = JSON.parseObject(result);
        JSONArray accountList = jsonObject.getJSONObject("Accounts").getJSONArray("Account");
        List<Map<String, String>> accountMapList = new ArrayList<>();
        // List<String> list = new ArrayList<>();
        for (int i = 0; i < accountList.size(); i++) {
            Map<String, String> accountMap = JsonUtils.parseObject(accountList.getJSONObject(i).toJSONString(),
                    new TypeReference<Map<String, String>>() {
                    });
            accountMapList.add(accountMap);
            // list.add(accountList.getJSONObject(i).getString("AccountId"));
        }
        return accountMapList;
    }

    /**
     * 根据master的AK,获取子账号的操作权限
     * 
     * @param accessKeyId
     * @param accessKeySecret
     * @param uid
     * @return
     * @throws Exception
     */
    public static DefaultAcsClient getSubAccountClinet(String accessKeyId, String accessKeySecret, String uid, String region)
            throws Exception {
        BasicCredentials basicCredentials = new BasicCredentials(accessKeyId, accessKeySecret);
        DefaultProfile profile = DefaultProfile.getProfile(region, accessKeyId, accessKeySecret);
        STSAssumeRoleSessionCredentialsProvider provider = new STSAssumeRoleSessionCredentialsProvider(basicCredentials,
                "acs:ram::" + uid + ":role/resourcedirectoryaccountaccessrole", profile);
        DefaultAcsClient client = new DefaultAcsClient(profile, provider);
        return client;
    }
}
