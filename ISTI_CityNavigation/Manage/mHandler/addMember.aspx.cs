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
        MemberLog_DB ml_db = new MemberLog_DB();
        MailUtil sMail = new MailUtil();
        string id, mGuid, M_Name, M_Account, OldAcc, M_Pwd, OldPW, M_Email, OldMail, M_Competence;
        bool ModMailStatus = false; // 修改帳號、密碼、E-Mail 狀態
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 新增&更新會員資料
            ///說    明:
            /// * Request["id"]: 成員ID
            /// * Request["gid"]: 成員GUID
            /// * Request["M_Name"]: 姓名
            /// * Request["M_Account"]: 帳號
            /// * Request["oldacc"]: 原帳號
            /// * Request["M_Pwd"]: 密碼
            /// * Request["oldpw"]: 原密碼
            /// * Request["M_Email"]: E-Mail
            /// * Request["oldmail"]: 原E-Mail
            /// * Request["M_Competence"]: 權限
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
                mGuid = (string.IsNullOrEmpty(Request["gid"])) ? Guid.NewGuid().ToString("N") : Request["gid"].ToString().Trim();
                M_Name = (string.IsNullOrEmpty(Request["M_Name"])) ? "" : Request["M_Name"].ToString().Trim();
                M_Account = (string.IsNullOrEmpty(Request["M_Account"])) ? "" : Request["M_Account"].ToString().Trim();
                OldAcc = (string.IsNullOrEmpty(Request["oldacc"])) ? "" : Request["oldacc"].ToString().Trim();
                M_Pwd = (string.IsNullOrEmpty(Request["M_Pwd"])) ? "" : Request["M_Pwd"].ToString().Trim();
                OldPW = (string.IsNullOrEmpty(Request["oldpw"])) ? "" : Request["oldpw"].ToString().Trim();
                M_Email = (string.IsNullOrEmpty(Request["M_Email"])) ? "" : Request["M_Email"].ToString().Trim();
                OldMail = (string.IsNullOrEmpty(Request["oldmail"])) ? "" : Request["oldmail"].ToString().Trim();
                M_Competence = (string.IsNullOrEmpty(Request["M_Competence"])) ? "" : Request["M_Competence"].ToString().Trim();

                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (Common.VeriftyToken(token))
                {
                    string xmlstr = string.Empty;

                    /// 檢查帳號是否重複
                    if (M_Account != OldAcc)
                    {
                        ModMailStatus = true;
                        m_db._M_Account = M_Account;
                        int chkAcc = m_db.CheckAccount();
                        if (chkAcc > 0)
                        {
                            xDoc = ExceptionUtil.GetErrorMassageDocument("此帳號已存在，請重新輸入");
                            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
                            xDoc.Save(Response.Output);
                            return;
                        }
                    }

                    /// 檢查E-Mail 是否重複
                    if (M_Email != OldMail)
                    {
                        ModMailStatus = true;
                        m_db._M_Email = M_Email;
                        int chkEmail = m_db.CheckEmail();
                        if (chkEmail > 0)
                        {
                            xDoc = ExceptionUtil.GetErrorMassageDocument("此 E-Mail 已存在，請重新輸入");
                            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
                            xDoc.Save(Response.Output);
                            return;
                        }
                    }

                    /// 檢查密碼是否修改
                    if (OldPW != M_Pwd)
                    {
                        ModMailStatus = true;
                        m_db._M_Pwd = Common.sha1en(M_Pwd);
                    }
                    else
                        m_db._M_Pwd = M_Pwd;

                    m_db._M_ID = id;
                    m_db._M_Guid = mGuid;
                    m_db._M_Account = M_Account;
                    m_db._M_Name = M_Name;
                    m_db._M_Email = M_Email;
                    m_db._M_Competence = M_Competence;
                    m_db._M_CreateId = LogInfo.mGuid;
                    m_db._M_CreateName = LogInfo.name;
                    m_db._M_ModId = LogInfo.mGuid;
                    m_db._M_ModName = LogInfo.name;
                    if (id == "")
                    {
                        m_db.addMember();
                        Add_Log();

                        #region 帳號開通發信
                        string mailContent = @"親愛的用戶您好：<br><br>
                        已為您開通 【經濟部智慧城鄉生活應用導航資料庫】 網站帳戶<br>
                        網址 https://twsmartcitydata.org.tw <br>
                        帳號：" + M_Account + @" <br>
                        密碼：" + M_Pwd + @" <br>
                        請使用此帳號密碼作登入使用<br><br>
                        經濟部智慧城鄉生活應用導航資料庫 感謝您<br><br>
                        << 此為系統寄發信件，請勿回信 >>";
                        sMail.MailTo(M_Email, "經濟部智慧城鄉生活應用導航資料庫-『帳號開通』", mailContent);
                        #endregion
                    }
                    else
                    {
                        DataTable OldDt = m_db.getMemberById();
                        m_db.modMember();
                        Modify_Log(OldDt);

                        #region 帳戶資料異動發信(帳號、密碼、E-Mail)
                        if (ModMailStatus)
                        {
                            string mailContent = @"親愛的用戶您好：<br><br>
                            您的【經濟部智慧城鄉生活應用導航資料庫】 網站帳戶異動資訊如下<br>
                            網址 https://twsmartcitydata.org.tw <br>
                            帳號：" + M_Account + @" <br>
                            密碼：" + M_Pwd + @" <br>
                            E-Mail：" + M_Email + @" <br><br>
                            經濟部智慧城鄉生活應用導航資料庫 感謝您<br><br>
                            << 此為系統寄發信件，請勿回信 >>";
                            sMail.MailTo(M_Email, "經濟部智慧城鄉生活應用導航資料庫-『帳戶資料異動』", mailContent);
                        }
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
        /// 新增成員 Log
        /// </summary>
        private void Add_Log()
        {
            ml_db._ML_IP = Common.GetIPv4Address();
            ml_db._ML_ChangeGuid = mGuid;
            ml_db._ML_Description = "新增成員【" + M_Name + "】";
            ml_db._ML_ModId = LogInfo.mGuid;
            ml_db._ML_ModName = LogInfo.name;
            ml_db.addLog();
        }

        /// <summary>
        /// 修改成員 Log
        /// </summary>
        private void Modify_Log(DataTable olddt)
        {
            string changeStr = string.Empty;
            m_db._M_ID = id;
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
                    string tempStr = @"修改成員：" + M_Name + "；<br>修改項目：<br>" + changeStr;

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