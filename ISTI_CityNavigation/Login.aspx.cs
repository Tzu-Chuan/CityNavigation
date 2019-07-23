using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation
{
    public partial class Login : System.Web.UI.Page
    {
        Member_DB m_db = new Member_DB();
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
    }
}