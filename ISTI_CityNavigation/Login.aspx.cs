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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InfoToken.Value = Common.GenToken();
                if (LogInfo.mGuid != "")
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

                AccountInfo accInfo = new Account().ExecLogon(uTxt, Common.sha1en(pTxt));
                if (accInfo != null)
                    Response.Redirect("~/WebPage/CityInfo.aspx?city=02");
                else
                    JavaScript.AlertMessage(this.Page, "帳號密碼有誤");
            }
            else
            {
                JavaScript.AlertMessage(this.Page, "網頁驗證失敗");
            }
        }
    }
}