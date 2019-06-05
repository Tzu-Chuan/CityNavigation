using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.Manage.mHandler
{
    
    public partial class addMember : System.Web.UI.Page
    {
        Member_DB m_db = new Member_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 新增&更新會員資料
            ///說明:
            /// * Request["id"]: 成員ID
            /// * Request["M_Name"]: 姓名
            /// * Request["M_Department"]: 所屬單位
            /// * Request["M_Account"]: 帳號
            /// * Request["M_Pwd"]: 密碼
            /// * Request["M_Email"]: E-Mail
            /// * Request["M_Competence"]: 權限
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string id = (string.IsNullOrEmpty(Request["id"])) ? "" : Request["id"].ToString().Trim();
                string M_Name = (string.IsNullOrEmpty(Request["M_Name"])) ? "" : Request["M_Name"].ToString().Trim();
                string M_Department = (string.IsNullOrEmpty(Request["M_Department"])) ? "" : Request["M_Department"].ToString().Trim();
                string M_Account = (string.IsNullOrEmpty(Request["M_Account"])) ? "" : Request["M_Account"].ToString().Trim();
                string M_Pwd = (string.IsNullOrEmpty(Request["M_Pwd"])) ? "" : Request["M_Pwd"].ToString().Trim();
                string M_Email = (string.IsNullOrEmpty(Request["M_Email"])) ? "" : Request["M_Email"].ToString().Trim();
                string M_Competence = (string.IsNullOrEmpty(Request["M_Competence"])) ? "" : Request["M_Competence"].ToString().Trim();

                m_db._M_ID = id;
                m_db._M_Guid = Guid.NewGuid().ToString("N");
                m_db._M_Account = M_Account;
                m_db._M_Pwd = Common.sha1en(M_Pwd);
                m_db._M_Name = M_Name;
                m_db._M_Email = M_Email;
                m_db._M_Competence = M_Competence;
                m_db._M_CreateId = LogInfo.mGuid;
                m_db._M_CreateName = LogInfo.name;
                m_db._M_ModId = LogInfo.mGuid;
                m_db._M_ModName = LogInfo.name;
                if (id == "")
                    m_db.addMember();
                else
                    m_db.modMember();

                string xmlstr = "<?xml version='1.0' encoding='utf-8'?><root><Response>儲存成功</Response></root>";
                xDoc.LoadXml(xmlstr);
            }
            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }
            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }
    }
}