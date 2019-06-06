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
    public partial class DeleteMember : System.Web.UI.Page
    {
        Member_DB m_db = new Member_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 新增&更新會員資料
            ///說    明:
            /// * Request["id"]: 成員ID
            /// * Request["M_Account"]: 帳號
            /// * Request["M_Pwd"]: 密碼
            /// * Request["M_Name"]: 姓名
            /// * Request["M_City"]: 縣市
            /// * Request["M_Competence"]: 權限
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string id = (string.IsNullOrEmpty(Request["id"])) ? "" : Request["id"].ToString().Trim();

                m_db._M_ID = id;
                m_db._M_ModId = LogInfo.mGuid;
                m_db._M_ModName = LogInfo.name;
                m_db.DeleteMember();

                string xmlstr = "<?xml version='1.0' encoding='utf-8'?><root><Response>人員已刪除</Response></root>";
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