using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text.RegularExpressions;

namespace ISTI_CityNavigation
{
    public partial class Login : System.Web.UI.Page
    {
        Member_DB m_db = new Member_DB();
        MailUtil sMail = new MailUtil();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InfoToken.Value = Common.GenToken();
                if (!string.IsNullOrEmpty(LogInfo.mGuid))
                    Response.Redirect("~/WebPage/CityInfo.aspx?city=02");
            }
        }

        protected void btn_Click(object sender, EventArgs e)
        {
            if (Common.VeriftyToken(InfoToken.Value))
            {
                string uTxt = uStr.Text.Trim();
                string pTxt = pStr.Text.Trim();
                string strErrorMsg = string.Empty;

                m_db._M_Account = uTxt;
                int accCount = m_db.CheckAccAlive();
                if (accCount < 5)
                {
                    AccountInfo accInfo = new Account().ExecLogon(uTxt, Common.sha1en(pTxt));
                    if (accInfo != null)
                    {
                        /// 登入失敗次數歸 0
                        m_db._M_Account = uTxt;
                        m_db.RecoverFailCount();
                        Response.Redirect("~/WebPage/CityInfo.aspx?city=02");
                    }
                    else
                    {
                        /// 登入失敗次數+1
                        m_db._M_Account = uTxt;
                        m_db.addFailCount();
                        JavaScript.AlertMessage(this.Page, "帳號密碼有誤");
                    }
                }
                else
                    JavaScript.AlertMessage(this.Page, "很抱歉，此帳號已被凍結");
            }
            else
            {
                JavaScript.AlertMessage(this.Page, "網頁驗證失敗，請重新整理");
            }
        }

        protected void sendbtn(object sender, EventArgs e)
        {
            if (Common.VeriftyToken(InfoToken.Value))
            {

                string M_Email = eStr.Text;
                bool bln;
                try
                {
                    System.Net.Mail.MailAddress mail = new System.Net.Mail.MailAddress(M_Email);
                    bln = true;
                }
                catch
                {
                    bln = false;
                }

                if (bln)
                {
                    m_db._M_Email = M_Email;
                    int chkEmail = m_db.CheckEmail();
                    if (chkEmail > 0)
                    {
                        DataTable dt = m_db.getInfoByEmailorGuid();
                        string mGid = Server.UrlEncode(Common.Encrypt(dt.Rows[0]["M_Guid"].ToString()));
                        // 加入申請時間
                        string TmeNow = Server.UrlEncode(Common.Encrypt(DateTime.Now.ToString("yyyy/MM/dd HH:mm")));
                        #region 帳戶資料異動發信(帳號、密碼、E-Mail)
                        string mailContent = @"親愛的用戶您好：<br><br>
                            您的【經濟部智慧城鄉生活應用導航資料庫】 密碼修改網址如下<br>
                            網址 " + ConfigurationManager.AppSettings["MailDomain"] + @"/ChangePwd.aspx?ChangePwd=" + mGid + "&ck=" + TmeNow + @"<br>
                            經濟部智慧城鄉生活應用導航資料庫 感謝您<br><br>
                            << 此為系統寄發信件，請勿回信 >>";
                        sMail.MailTo(M_Email, "經濟部智慧城鄉生活應用導航資料庫-『帳戶密碼修改』", mailContent);
                        #endregion
                        JavaScript.AlertMessage(this.Page, "密碼修改通知已寄出，請至E-mail進行修改");
                    }
                    else
                    {
                        JavaScript.AlertMessage(this.Page, "查無此會員，請重新輸入");
                    }
                }
                else
                {
                    JavaScript.AlertMessage(this.Page, "E-mail格式錯誤請重新輸入");
                }
            }
            else
            {
                JavaScript.AlertMessage(this.Page, "網頁驗證失敗，請重新整理");
            }
        }
    }
}