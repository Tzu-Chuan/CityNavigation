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
    public partial class RecoverMember : System.Web.UI.Page
    {
        Member_DB m_db = new Member_DB();
        MemberLog_DB ml_db = new MemberLog_DB();
        string id;
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 恢復凍結帳號
            ///說    明:
            /// * Request["id"]: 成員ID
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                #region 登入判斷
                if (string.IsNullOrEmpty(LogInfo.mGuid))
                {
                    xDoc = ExceptionUtil.GetErrorMassageDocument("請重新登入");
                    Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
                    xDoc.Save(Response.Output);
                    return;
                }
                #endregion

                id = (string.IsNullOrEmpty(Request["id"])) ? "" : Request["id"].ToString().Trim();
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (Common.VeriftyToken(token))
                {
                    m_db._M_ID = id;
                    m_db._M_ModId = LogInfo.mGuid;
                    m_db._M_ModName = LogInfo.name;
                    m_db.RecoverMember();
                    addLog();

                    string xmlstr = "<?xml version='1.0' encoding='utf-8'?><root><Response>人員已回復正常使用狀態</Response></root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetErrorMassageDocument("TokenFail");
                }
            }
            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }
            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }

        /// <summary>
        /// 恢復成員 Log
        /// </summary>
        private void addLog()
        {
            m_db._M_ID = id;
            DataTable dt = m_db.getMemberById();
            if (dt.Rows.Count > 0)
            {
                ml_db._ML_IP = Common.GetIPv4Address();
                ml_db._ML_ChangeGuid = dt.Rows[0]["M_Guid"].ToString();
                ml_db._ML_Description = "回復成員【" + dt.Rows[0]["M_Name"].ToString() + "】使用狀態";
                ml_db._ML_ModId = LogInfo.mGuid;
                ml_db._ML_ModName = LogInfo.name;
                ml_db.addLog();
            }
        }
    }
}