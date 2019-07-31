using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation.handler
{
    public partial class ChangeUserPwd : System.Web.UI.Page
    {
        Member_DB m_db = new Member_DB();
        MemberLog_DB ml_db = new MemberLog_DB();
        MailUtil sMail = new MailUtil();
        string M_Pwd, gid, mGuid;
        protected void Page_Load(object sender, EventArgs e)
        {
            XmlDocument xDoc = new XmlDocument();
            try
            {
                gid = (string.IsNullOrEmpty(Request["gid"])) ? "" : Request["gid"].ToString().Trim();
                M_Pwd = (string.IsNullOrEmpty(Request["M_Pwd"])) ? "" : Request["M_Pwd"].ToString().Trim();

                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (Common.VeriftyToken(token))
                {
                    string xmlstr = string.Empty;
                    if (gid != "")
                    {
                        mGuid = Common.Decrypt(gid);
                        m_db._M_Guid = mGuid;
                        DataTable OldDt = m_db.getInfoByEmailorGuid();
                        m_db._M_Pwd = Common.sha1en(M_Pwd);
                        m_db.changeMemberPwd();
                        Modify_Log(OldDt);
                        string mEmail = OldDt.Rows[0]["M_Email"].ToString();
                        #region 帳戶資料異動發信(帳號、密碼、E-Mail)
                        string mailContent = @"親愛的用戶您好：<br><br>
                            您的【經濟部智慧城鄉生活應用導航資料庫】 網站帳戶密碼修改成功<br>
                            若您沒有修改密碼，請通知管理人員<br>
                            經濟部智慧城鄉生活應用導航資料庫 感謝您<br><br>
                            << 此為系統寄發信件，請勿回信 >>";
                        sMail.MailTo(mEmail, "經濟部智慧城鄉生活應用導航資料庫-『密碼修改成功通知』", mailContent);
                        #endregion
                    }
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root><Response>儲存成功</Response></root>";
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
        /// 修改成員 Log
        /// </summary>
        /// <summary>
        /// 修改成員 Log
        /// </summary>
        private void Modify_Log(DataTable olddt)
        {
            string changeStr = string.Empty;
            m_db._M_Guid = mGuid;
            DataTable dt = m_db.getMemberById();
            if (dt.Rows.Count > 0)
            {
                if (olddt.Rows[0]["M_Account"].ToString() != dt.Rows[0]["M_Account"].ToString())
                {
                    if (changeStr != "") changeStr += "<br>";
                    changeStr += "帳號【" + olddt.Rows[0]["M_Account"].ToString() + "】修改為【" + dt.Rows[0]["M_Account"].ToString() + "】";
                }
                if (olddt.Rows[0]["M_Pwd"].ToString() != dt.Rows[0]["M_Pwd"].ToString())
                {
                    if (changeStr != "") changeStr += "<br>";
                    changeStr += "修改密碼";
                }
                if (olddt.Rows[0]["M_Name"].ToString() != dt.Rows[0]["M_Name"].ToString())
                {
                    if (changeStr != "") changeStr += "<br>";
                    changeStr += "姓名【" + olddt.Rows[0]["M_Name"].ToString() + "】修改為【" + dt.Rows[0]["M_Name"].ToString() + "】";
                }
                if (olddt.Rows[0]["M_Email"].ToString() != dt.Rows[0]["M_Email"].ToString())
                {
                    if (changeStr != "") changeStr += "<br>";
                    changeStr += "E-mail【" + olddt.Rows[0]["M_Email"].ToString() + "】修改為【" + dt.Rows[0]["M_Email"].ToString() + "】";
                }
                if (olddt.Rows[0]["M_Competence"].ToString() != dt.Rows[0]["M_Competence"].ToString())
                {
                    if (changeStr != "") changeStr += "<br>";
                    changeStr += "所屬單位/權限【" + GetCompetence(olddt.Rows[0]["M_Competence"].ToString()) + "】修改為 【" + GetCompetence(dt.Rows[0]["M_Competence"].ToString()) + "】";
                }

                if (!string.IsNullOrEmpty(changeStr))
                {
                    string tempStr = @"修改成員：" + dt.Rows[0]["M_Name"].ToString() + "；<br>修改項目：<br>" + changeStr;

                    ml_db._ML_IP = Common.GetIPv4Address();
                    ml_db._ML_ChangeGuid = mGuid;
                    ml_db._ML_Description = tempStr;
                    ml_db._ML_ModId = LogInfo.mGuid;
                    ml_db._ML_ModName = LogInfo.name;
                    ml_db.addLog();
                }
            }
        }

        private string GetCompetence(string item)
        {
            string rVal = string.Empty;
            CodeTable_DB c_db = new CodeTable_DB();
            c_db._C_Item = item;
            DataTable dt = c_db.getCommonCode("03");
            if (dt.Rows.Count > 0)
                rVal = dt.Rows[0]["C_Item_Cn"].ToString();
            return rVal;
        }
    }
}