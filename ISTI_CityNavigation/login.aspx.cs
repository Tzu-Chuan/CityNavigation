using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hid_token.Value = Common.GenToken();
                if (LogInfo.mGuid != "")
                    Response.Redirect("~/WebPage/CityInfo.aspx");
            }
        }

        protected void btn_Click(object sender, EventArgs e)
        {
            if (Common.VeriftyToken(hid_token.Value))
            {
                string ab = AnbTxt.Value.Trim();
                string wo = WordTxt.Value.Trim();
                string strErrorMsg = "";

                AccountInfo accInfo = new Account().ExecLogon(ab, Common.sha1en(wo));
                if (accInfo != null)
                {
                    Response.Redirect("~/WebPage/CityInfo.aspx?city=02");
                }
                else
                {
                    strErrorMsg = "帳號密碼有誤";
                    JavaScript.AlertMessage(this.Page, strErrorMsg);
                }
            }
            else
            {
                JavaScript.AlertMessage(this.Page, "token驗證失敗");
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            ViewStateUserKey = User.Identity.Name;
        }
    }
}